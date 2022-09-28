import 'dart:convert';

// add a file with your credentials that includes the two strings
// igdbClientId and igdbClientSecret in order to use this api
import 'package:flutter/foundation.dart';
import 'package:pile_of_shame/src/network/igdb/credentials.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_filters.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_image.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_platform.dart';
import 'package:http/http.dart' as http;

import 'models/igdb_authorization.dart';

class IGDBApi {
  // Singleton code
  static final IGDBApi _instance = IGDBApi._internal();
  factory IGDBApi() {
    return _instance;
  }
  IGDBApi._internal();

  // Instance variables
  IGDBAuthorization? _token;

  // Class variables
  static String baseUrl = "api.igdb.com";

  Map<String, String> _httpHeader() {
    if (_token == null) {
      throw Exception("Token is not set!");
    }
    return {
      "Client-ID": igdbClientId,
      "Authorization": "Bearer ${_token!.accessToken}",
    };
  }

  Future<IGDBAuthorization> _authorize() async {
    if (_token == null || _token!.expirationDate.isBefore(DateTime.now())) {
      // fetch a token if there is none or if the current token has expired
      final url = Uri.https(
        "id.twitch.tv",
        "oauth2/token",
        {
          "client_id": igdbClientId,
          "client_secret": igdbClientSecret,
          "grant_type": "client_credentials",
        },
      );
      final result = await http.post(url);
      if (result.statusCode == 200) {
        _token = IGDBAuthorization.fromJson(jsonDecode(result.body));
      } else {
        _token = null;
        throw Exception(result.body.toString());
      }
    }
    return _token!;
  }

  Future<http.Response> _performRequest(
      {required Uri url, required String body, int retries = 5}) async {
    await _authorize();

    for (var i = 0; i < retries; ++i) {
      // retry up to 5 times
      final response = await http.post(url, headers: _httpHeader(), body: body);
      if (response.statusCode == 429) {
        // Too many requests, wait for 2 seconds, then retry
        await Future.delayed(const Duration(seconds: 1));
        debugPrint("Too many requests, dude!");
      } else {
        // No Too-many-requests response. Move on by returning the response.
        return response;
      }
    }
    return http.Response("$retries Retries failed", 500);
  }

  Future<List<IGDBPlatformFamily>> getPlatformFamilies() async {
    const String platformFamiliesEndpoint = "v4/platform_families";
    Uri url = Uri.https(
      baseUrl,
      platformFamiliesEndpoint,
    );

    final response = await _performRequest(
      url: url,
      body: "fields *;",
    );
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBPlatformFamily> parsedResults =
          results.map((e) => IGDBPlatformFamily.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response.body.toString());
  }

  Future<List<IGDBPlatform>> getPlatforms() async {
    const String platformsEndpoint = "v4/platforms";
    Uri url = Uri.https(baseUrl, platformsEndpoint);

    final platformFamilies = await getPlatformFamilies();
    // select nintendo, xbox and playstation
    final List<int> filteredPlatformIds = platformFamilies
        .where((family) {
          return family.slug == "nintendo" ||
              family.slug == "xbox" ||
              family.slug == "playstation";
        })
        .map((e) => e.id)
        .toList();

    IGDBFilters filters = IGDBFilters(
      fields: [
        "abbreviation",
        "alternative_name",
        "name",
        "platform_family",
        "platform_logo",
        "slug"
      ],
      conditions: "platform_family = (${filteredPlatformIds.join(",")})",
      limit: 50,
    );

    final response = await _performRequest(url: url, body: filters.toString());

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBPlatform> parsedResults =
          results.map((e) => IGDBPlatform.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response.body.toString());
  }

  Future<List<IGDBGame>> getGameByNameAndPlatform(
      String gameName, int? platformId) async {
    const String gamesEndpoint = "v4/games";
    Uri url = Uri.https(baseUrl, gamesEndpoint);

    // try searching for the game first
    IGDBFilters searchFilters = IGDBFilters(
      fields: [
        "alternative_names",
        "artworks.*",
        "cover.*",
        "first_release_date",
        "name",
        "platforms",
        "screenshots.*",
        "slug",
        "version_parent",
      ],
      search: gameName,
    );

    final response =
        await _performRequest(url: url, body: searchFilters.toString());
    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBGame> parsedResults =
          results.map((e) => IGDBGame.fromJson(e)).toList();
      if (parsedResults.isNotEmpty) {
        return parsedResults;
      }
    }

    // the game was not found using the search-request (maybe it's in a different language)
    // retry by searching through alternative_names
    final nameTokens = gameName.split(RegExp(r'[\s:]'));
    List<int> indexGeneration =
        List<int>.generate(nameTokens.length - 1, (i) => i);
    List<String> nameSearch = [];
    List<String> alternativeNameSearch = [];
    for (var index in indexGeneration) {
      String before = nameTokens.sublist(0, index + 1).join(" ");
      String after = nameTokens.sublist(index + 1).join(" ");
      String sum = "$before: $after";
      nameSearch.add("name ~ *\"$sum\"*");
      alternativeNameSearch.add("alternative_names.name ~ *\"$sum\"*");
    }

    List<String> conditions = [];
    String regularNameCondition =
        "name ~ *\"${gameName.toLowerCase()}\"*${nameSearch.isNotEmpty ? " | " : ""}${nameSearch.join(" | ")}";
    conditions.add(regularNameCondition);
    String alternativeNameCondition =
        "alternative_names.name ~ *\"${gameName.toLowerCase()}\"*${alternativeNameSearch.isNotEmpty ? " | " : ""}${alternativeNameSearch.join(" | ")}";
    conditions.add(alternativeNameCondition);
    String? platformCondition =
        platformId != null ? "platform = $platformId" : null;
    if (platformCondition != null) {
      conditions.add(platformCondition);
    }

    IGDBFilters filters = IGDBFilters(
      fields: [
        "alternative_names",
        "artworks.*",
        "cover.*",
        "first_release_date",
        "name",
        "platforms",
        "screenshots.*",
        "slug",
        "version_parent",
      ],
      conditions: conditions.join(" | "),
    );

    String body = filters.toString();

    final response2 = await _performRequest(url: url, body: body);

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response2.body);
      final List<IGDBGame> parsedResults =
          results.map((e) => IGDBGame.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response2.body.toString());
  }

  Future<List<IGDBImage>> getCoversById(List<int> coverIds) async {
    const String coverEndpoint = "v4/covers";
    Uri url = Uri.https(baseUrl, coverEndpoint);

    IGDBFilters filters = IGDBFilters(fields: [
      "animated",
      "game",
      "height",
      "image_id",
      "url",
      "width",
    ], conditions: "id = (${coverIds.join(",")})");

    final response = await _performRequest(url: url, body: filters.toString());

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBImage> parsedResults =
          results.map((e) => IGDBImage.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response.body.toString());
  }

  Future<List<IGDBImage>> getScreenshotsById(List<int> screenshotIds) async {
    const String coverEndpoint = "v4/screenshots";
    Uri url = Uri.https(baseUrl, coverEndpoint);

    IGDBFilters filters = IGDBFilters(fields: [
      "animated",
      "game",
      "height",
      "image_id",
      "url",
      "width",
    ], conditions: "id = (${screenshotIds.join(",")})");

    final response = await _performRequest(url: url, body: filters.toString());

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBImage> parsedResults =
          results.map((e) => IGDBImage.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response.body.toString());
  }

  Future<List<IGDBImage>> getPlatformLogosById(
      List<int> platformLogoIds) async {
    const String coverEndpoint = "v4/platform_logos";
    Uri url = Uri.https(baseUrl, coverEndpoint);

    IGDBFilters filters = IGDBFilters(fields: [
      "animated",
      "game",
      "height",
      "image_id",
      "url",
      "width",
    ], conditions: "id = (${platformLogoIds.join(",")})");

    final response = await _performRequest(url: url, body: filters.toString());

    if (response.statusCode == 200) {
      final List<dynamic> results = jsonDecode(response.body);
      final List<IGDBImage> parsedResults =
          results.map((e) => IGDBImage.fromJson(e)).toList();
      return parsedResults;
    }
    throw Exception(response.body.toString());
  }
}
