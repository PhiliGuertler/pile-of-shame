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

const List<String> igdbGameFields = [
  "alternative_names",
  "artworks.*",
  "cover.*",
  "rating",
  "first_release_date",
  "name",
  "platforms.*",
  "screenshots.*",
  "slug",
  "version_parent",
];

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

  Future<List<IGDBGame>> getGameByExactName(String gameName) async {
    const String gamesEndpoint = "v4/games";
    Uri url = Uri.https(baseUrl, gamesEndpoint);

    final conditions =
        IGDBFilterUtils.generateGameNameCondition(gameName.trim(), true);

    // try searching for the game first
    IGDBFilters searchFilters = IGDBFilters(
      fields: igdbGameFields,
      conditions: conditions.join(" | "),
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
    return [];
  }

  Future<List<IGDBGame>> getGameBySearchName(String gameName) async {
    const String gamesEndpoint = "v4/games";
    Uri url = Uri.https(baseUrl, gamesEndpoint);

    // try searching for the game first
    IGDBFilters searchFilters = IGDBFilters(
      fields: igdbGameFields,
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

    // fallback to exact name, as that also searches for other languages
    return getGameByExactName(gameName);
  }

  Future<List<IGDBGame>> getGameById(int id) async {
    const String gamesEndpoint = "v4/games";
    Uri url = Uri.https(baseUrl, gamesEndpoint);

    // try searching for the game first
    IGDBFilters searchFilters = IGDBFilters(
      fields: igdbGameFields,
      conditions: "id = $id",
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

    throw Exception("Game with id $id not found.");
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
