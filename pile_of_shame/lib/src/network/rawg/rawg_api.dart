import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pile_of_shame/src/network/rawg/authentication.dart';

class RawgGame {
  String name;
  int id;
  int metacriticScore;
  Uri backgroundImage;
  String released;

  RawgGame({
    required this.name,
    required this.id,
    required this.metacriticScore,
    required this.backgroundImage,
    required this.released,
  });

  factory RawgGame.fromJson(Map<String, dynamic> json) {
    return RawgGame(
      name: json['name'],
      id: json['id'],
      metacriticScore: json['metacritic'],
      backgroundImage: Uri.parse(json['background_image']),
      released: json['released'],
    );
  }
}

class RawgApi {
  static final RawgApi _instance = RawgApi._internal();
  factory RawgApi() => _instance;

  RawgApi._internal() {}

  Future<Iterable<RawgGame>> searchGameByName(String gameName) async {
    final response = await http.post(Uri.parse(
        'https://api.rawg.io/api/games?search=$gameName&key=$rawgApiKey'));

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
