import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/game.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // ######################################################################## //
  // ### Games ############################################################## //

  Future<File> get _localGamesFile async {
    final path = await _localPath;
    return File('$path/games.json');
  }

  Future<List<Game>> readGames() async {
    try {
      // Get the file
      final file = await _localGamesFile;
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
    final file = await _localGamesFile;
    // write the games as a json
    return file.writeAsString(jsonEncode(games));
  }

  // ######################################################################## //
  // ### Platforms ########################################################## //

  Future<File> get _localPlatformsFile async {
    final path = await _localPath;
    return File('$path/platforms.json');
  }

  Future<List<String>> readPlatforms() async {
    try {
      // Get the file
      final file = await _localPlatformsFile;
      // Read it
      final contents = await file.readAsString();
      // decode the json contents to a List of Platforms
      List<dynamic> decodedContents = jsonDecode(contents);
      // generate Platform-Objects from the decoded contents
      return decodedContents.map((entry) => entry.toString()).toList();
    } catch (error) {
      debugPrint(
          'An error occured while reading the file: ${error.toString()}');
      // return an empty list
      return <String>[];
    }
  }

  Future<File> writePlatforms(List<String> platforms) async {
    // Get the file
    final file = await _localPlatformsFile;
    // write the games as a json
    return file.writeAsString(jsonEncode(platforms));
  }
}
