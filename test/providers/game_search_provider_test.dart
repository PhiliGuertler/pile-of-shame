import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';

void main() {
  final Game gameOuterWilds = Game(
    id: 'outer-wilds',
    lastModified: DateTime(2023, 1, 1),
    name: 'Outer Wilds',
    platform: GamePlatform.xboxOne,
    price: 24.99,
    status: PlayStatus.completed,
    dlcs: [],
    usk: USK.usk12,
  );
  final Game gamePokemonX = Game(
    id: 'pokemon-x',
    lastModified: DateTime(2023, 1, 2),
    name: 'Pokémon X',
    platform: GamePlatform.steam,
    price: 19.99,
    status: PlayStatus.playing,
    dlcs: [],
    usk: USK.usk0,
  );
  final Game gameSsx3 = Game(
    id: 'ssx-3',
    lastModified: DateTime(2023, 1, 3),
    name: 'SSX 3',
    platform: GamePlatform.playStation2,
    price: 39.95,
    status: PlayStatus.completed100Percent,
    dlcs: [],
    usk: USK.usk6,
  );
  final Game gameOriAndTheBlindForest = Game(
    id: 'ori-and-the-blind-forest',
    lastModified: DateTime(2023, 1, 4),
    name: 'Ori and the blind forest',
    platform: GamePlatform.playStation4,
    price: 25,
    status: PlayStatus.onPileOfShame,
    dlcs: [],
    usk: USK.usk12,
  );

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });

  test("applyGameSearch returns all games by default", () {
    final originalGames = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, originalGames);
  });
  test(
      "applyGameSearch returns games containing the search tokens in lower-case in the correct order",
      () {
    final originalGames = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    container
        .read(gameSearchProvider.notifier)
        .setSearch("ori and the blind forest");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [gameOriAndTheBlindForest]);
  });
  test(
      "applyGameSearch returns games containing the search tokens in lower-case in the wrong order",
      () {
    final originalGames = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    container
        .read(gameSearchProvider.notifier)
        .setSearch("ori blind forest and the");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [gameOriAndTheBlindForest]);
  });
  test("applyGameSearch returns games containing diacritics as expected", () {
    final originalGames = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    container.read(gameSearchProvider.notifier).setSearch("POKEMON");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [gamePokemonX]);
  });
  test("applyGameSearch returns games by their name and platform abbreviation",
      () {
    final originalGames = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    container.read(gameSearchProvider.notifier).setSearch("ori ps4");

    final result = container.read(applyGameSearchProvider(originalGames));

    expect(result, [gameOriAndTheBlindForest]);
  });
}
