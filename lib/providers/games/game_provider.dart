import 'dart:convert';

import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_storage.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_provider.g.dart';

@riverpod
GameStorage gameStorage(GameStorageRef ref) => GameStorage(ref: ref);

@riverpod
FutureOr<GamesList> games(GamesRef ref) async {
  final gameFile = await ref.watch(gameFileProvider.future);

  final content = await gameFile.readAsString();
  if (content.isNotEmpty) {
    return GamesList.fromJson(jsonDecode(content));
  }
  return const GamesList(games: []);
}

@riverpod
AsyncValue<Game> gameById(GameByIdRef ref, String id) {
  final games = ref.watch(gamesProvider);
  return games.when(
    data: (data) =>
        AsyncValue.data(data.games.singleWhere((element) => element.id == id)),
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
