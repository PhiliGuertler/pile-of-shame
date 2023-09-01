import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';

class GameStorage {
  final Ref ref;

  const GameStorage({required this.ref});

  Future<void> persistGamesList(GamesList gamesList, [File? outputFile]) async {
    final encodedList = jsonEncode(gamesList.toJson());
    File output = outputFile ?? await ref.read(gameFileProvider.future);
    await output.writeAsString(encodedList);
    if (outputFile == null) {
      ref.invalidate(gameFileProvider);
    }
  }

  Future<GamesList> readGamesFromFile(File inputFile) async {
    final fileContents = await inputFile.readAsString();
    final json = jsonDecode(fileContents);
    return GamesList.fromJson(json);
  }

  Future<void> persistCurrentGames() async {
    final games = await ref.read(gamesProvider.future);
    final gameFile = await ref.read(gameFileProvider.future);
    await persistGamesList(games, gameFile);
  }
}
