import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  group("sortGamesProvider", () {
    test("loads persisted GameSorting correctly", () async {
      SharedPreferences.setMockInitialValues(
        {"sorter": '{"isAscending":false,"sortStrategy":"byLastModified"}'},
      );
      final initialValue = await container.read(sortGamesProvider.future);
      expect(
          initialValue,
          const GameSorting(
            isAscending: false,
            sortStrategy: SortStrategy.byLastModified,
          ));
    });
    test("falls back to default GameSorting if no persisted entry is found",
        () async {
      SharedPreferences.setMockInitialValues(
        {},
      );
      final initialValue = await container.read(sortGamesProvider.future);
      expect(initialValue, const GameSorting());
    });
    test("persists sorting like expected", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      const GameSorting update = GameSorting(
        isAscending: false,
        sortStrategy: SortStrategy.byPlayStatus,
      );

      await container.read(sortGamesProvider.notifier).setSorting(update);

      expect(await container.read(sortGamesProvider.future), update);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SortGames.storageKey),
          '{"isAscending":false,"sortStrategy":"byPlayStatus"}');
    });
  });

  test("applyGameSortingProvider correctly applies sorting strategy", () async {
    SharedPreferences.setMockInitialValues(
      {"sorter": '{"isAscending":false,"sortStrategy":"byName"}'},
    );
    final originalList = [
      gameOuterWilds,
      gamePokemonX,
      gameSsx3,
      gameOriAndTheBlindForest,
    ];

    final sortedList =
        await container.read(applyGameSortingProvider(originalList).future);

    expect(sortedList,
        [gameSsx3, gamePokemonX, gameOuterWilds, gameOriAndTheBlindForest]);
  });
}
