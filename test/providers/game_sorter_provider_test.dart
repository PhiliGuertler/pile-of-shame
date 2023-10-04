import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_resources/test_games.dart';

void main() {
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
        ),
      );
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
      expect(
        prefs.getString(SortGames.storageKey),
        '{"isAscending":false,"sortStrategy":"byPlayStatus"}',
      );
    });
  });

  test("applyGameSortingProvider correctly applies sorting strategy", () async {
    SharedPreferences.setMockInitialValues(
      {"sorter": '{"isAscending":false,"sortStrategy":"byName"}'},
    );
    final originalList = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    final sortedList =
        await container.read(applyGameSortingProvider(originalList).future);

    expect(
      sortedList,
      [
        TestGames.gameWitcher3,
        TestGames.gameSsx3,
        TestGames.gameOuterWilds,
        TestGames.gameOriAndTheBlindForest,
      ],
    );
  });
}
