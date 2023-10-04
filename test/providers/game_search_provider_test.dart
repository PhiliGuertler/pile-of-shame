import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';

import '../../test_resources/test_games.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });

  test("applyGameSearch returns all games by default", () {
    final originalGames = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, originalGames);
  });
  test(
      "applyGameSearch returns games containing the search tokens in lower-case in the correct order",
      () {
    final originalGames = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    container
        .read(gameSearchProvider.notifier)
        .setSearch("ori and the blind forest");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [TestGames.gameOriAndTheBlindForest]);
  });
  test(
      "applyGameSearch returns games containing the search tokens in lower-case in the wrong order",
      () {
    final originalGames = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    container
        .read(gameSearchProvider.notifier)
        .setSearch("ori blind forest and the");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [TestGames.gameOriAndTheBlindForest]);
  });
  test("applyGameSearch returns games containing diacritics as expected", () {
    final originalGames = [
      TestGames.gameDistance,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    container.read(gameSearchProvider.notifier).setSearch("distance");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [TestGames.gameDistance]);
  });
  test("applyGameSearch returns games by their name and platform abbreviation",
      () {
    final originalGames = [
      TestGames.gameDistance,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    container.read(gameSearchProvider.notifier).setSearch("ori ps4");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [TestGames.gameOriAndTheBlindForest]);
  });
}
