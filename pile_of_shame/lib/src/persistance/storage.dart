import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  Future<bool> deleteGame(Game game) async {
    final List<Game> gameList = await readGames();
    final index = gameList.indexOf(game);
    if (index == -1) {
      return false;
    }
    gameList.removeAt(index);
    await writeGames(gameList);
    return true;
  }

  Future<bool> deleteGameByUuid(String uuid) async {
    final List<Game> gameList = await readGames();
    final index = gameList.indexWhere((element) => element.uuid == uuid);
    if (index == -1) {
      return false;
    }
    gameList.removeAt(index);
    await writeGames(gameList);
    return true;
  }

  Future<Game> getGameByUuid(String uuid) async {
    final List<Game> gameList = await readGames();
    final matches = gameList.where((element) => element.uuid == uuid);
    if (matches.length == 1) {
      return matches.first;
    }
    throw Exception('Game with uuid $uuid does not exist.');
  }

  Future<List<Game>> importGames() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        final contents = await file.readAsString();
        // decode the json contents to a List of Games
        List<dynamic> decodedContents = jsonDecode(contents);
        // generate Game-Objects from the decoded contents
        List<Game> importedGames =
            decodedContents.map((entry) => Game.fromJson(entry)).toList();
        // Merge existing games with imported games
        List<Game> existingGames = await readGames();
        List<Game> mergedGames = List.from(existingGames);
        for (var importedGame in importedGames) {
          if (mergedGames
              .where((element) => element.uuid == importedGame.uuid)
              .isEmpty) {
            mergedGames.add(importedGame);
          }
        }

        return mergedGames;
      } catch (error) {
        debugPrint(
            'An error occured while reading the file: ${error.toString()}');
        // return an empty list
        return <Game>[];
      }
    }
    return <Game>[];
  }

  Future<bool> exportGames() async {
    // TODO: Implement this feature! On windows, we can use FilePicker.saveFile, on Android use share_plus
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Wähle einen Speicherort für die Export-Datei:',
        fileName: 'games_pile-of-shame.json',
      );
      if (outputFile == null) {
        // User cancelled export
        return false;
      }
      // Write the file
      File file = File(outputFile);
      List<Game> storedGames = await readGames();
      file.writeAsString(jsonEncode(storedGames));
      return true;
    } else {
      debugPrint('TODO: Implement sharing to the phone\'s internal storage');
    }
    return false;
  }
}
