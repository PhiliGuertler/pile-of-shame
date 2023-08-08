import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/game_file_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';
part 'game_provider.freezed.dart';

@freezed
class GamesList with _$GamesList {
  const factory GamesList({
    required List<Game> games,
  }) = _GamesList;

  factory GamesList.fromJson(Map<String, dynamic> json) =>
      _$GamesListFromJson(json);
}

@riverpod
class Games extends _$Games {
  @override
  FutureOr<List<Game>> build() async {
    return await _readStoredGames();
  }

  FutureOr<List<Game>> _readStoredGames() async {
    final gameFile = await ref.read(gameFileProvider.future);
    final content = await gameFile.readAsString();
    if (content.isNotEmpty) {
      final games = GamesList.fromJson(jsonDecode(content));
      return games.games;
    }
    return [];
  }

  Future<void> storeGames(List<Game> games) async {
    final gameFile = await ref.read(gameFileProvider.future);
    final gameList = GamesList(games: games);
    final encodedList = jsonEncode(gameList.toJson());
    await gameFile.writeAsString(encodedList);
    ref.invalidate(gameFileProvider);
  }
}
