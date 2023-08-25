import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/game_file_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.freezed.dart';
part 'game_provider.g.dart';

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
    final gameFile = await ref.watch(gameFileProvider.future);
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
    // This also invalidates this provider, as the build method calls watch on gameFileProvider
    ref.invalidate(gameFileProvider);
  }

  Future<void> importGamesFromFile(File file) async {
    // TODO: Persist these values?
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
    final contents = await file.readAsString();
    final jsonContents = jsonDecode(contents);
    final gameList = GamesList.fromJson(jsonContents);
      return gameList.games;
    });
  }
}

@riverpod
AsyncValue<Game> gameById(GameByIdRef ref, String id) {
  final games = ref.watch(gamesProvider);
  return games.when(
    data: (data) =>
        AsyncValue.data(data.singleWhere((element) => element.id == id)),
    error: (error, stackTrace) => throw error,
    loading: () => const AsyncValue.loading(),
  );
}

@riverpod
AsyncValue<DLC> dlcByGameAndId(
    DlcByGameAndIdRef ref, String gameId, String dlcId) {
  final game = ref.watch(gameByIdProvider(gameId));
  return game.when(
    data: (game) => AsyncValue.data(
        game.dlcs.singleWhere((element) => element.id == dlcId)),
    error: (error, stackTrace) => throw error,
    loading: () => const AsyncValue.loading(),
  );
}
