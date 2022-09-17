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

  /// saves or updates a game in storage
  /// returns true if the game was added, false if updated
  Future<bool> addOrUpdateGame(Game game) async {
    // find game with given game' s uuid
    final List<Game> gameList = await readGames();
    final int gameIndex = gameList.indexOf(game);
    bool result = false;
    if (gameIndex == -1) {
      // this game does not exist in the list yet, add it
      result = true;
      gameList.add(game);
    } else {
      // this game does exist, update it in the list
      gameList[gameIndex] = game;
    }
    await writeGames(gameList);
    return result;
  }
}
