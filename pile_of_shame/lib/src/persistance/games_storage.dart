import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/game.dart';

class GamesStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    debugPrint('LocalPath: ${directory.toString()}');

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/games.json');
  }

  Future<List<Game>> readGames() async {
    try {
      // Get the file
      final file = await _localFile;
      // Read it
      final contents = await file.readAsString();
      // decode the json contents to a List of Games
      List<dynamic> decodedContents = jsonDecode(contents);
      // generate Game-Objects from the decoded contents
      return decodedContents.map((entry) => Game.fromJson(entry)).toList();
    } catch (error) {
      debugPrint(
          'An error occured while reading the file: ${error.toString()}');
      // return an empty list
      return <Game>[];
    }
  }

  Future<File> writeGames(List<Game> games) async {
    // Get the file
    final file = await _localFile;
    // write the games as a json
    return file.writeAsString(jsonEncode(games));
  }
}
