import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pile_of_shame/src/network/rawg/authentication.dart';

class RawgGame {
  String? name;
  int? id;
  int? metacriticScore;
  String? backgroundImage;
  String? released;

  RawgGame({
    this.name,
    this.id,
    this.metacriticScore,
    this.backgroundImage,
    this.released,
  });

  factory RawgGame.fromJson(Map<String, dynamic> json) {
    return RawgGame(
      name: json['name'],
      id: json['id'],
      metacriticScore: json['metacritic'],
      backgroundImage: json['background_image'],
      released: json['released'],
    );
  }
}

class RawgApi {
  static final RawgApi _instance = RawgApi._internal();
  factory RawgApi() => _instance;

  RawgApi._internal();

  Future<Iterable<RawgGame>> searchGameByName(String gameName) async {
    final queryParameters = {
      'key': rawgApiKey,
      'search': gameName,
    };
    final response = await http.get(
      Uri.https('api.rawg.io', '/api/games', queryParameters),
    );

    if (response.statusCode == 200) {
      // find the game we wanted
      final List<dynamic> results = jsonDecode(response.body)['results'];
      final Iterable<RawgGame> parsedResults =
          results.map((result) => RawgGame.fromJson(result));
      return parsedResults;
    }
    throw Exception('Fetching game failed');
  }
}
