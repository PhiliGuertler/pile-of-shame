import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/providers/games/game_group_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theming/theming.dart';

import '../../test_resources/test_games.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });

  group("groupGamesProvider", () {
    test("loads persisted GameGrouping correctly", () async {
      SharedPreferences.setMockInitialValues(
        {"grouper": '{"groupStrategy":"byPlatform"}'},
      );
      final initialValue = await container.read(groupGamesProvider.future);
      expect(
        initialValue,
        const GameGrouping(groupStrategy: GroupStrategy.byPlatform),
      );
    });
    test("falls back to default GameGrouping if no persisted entry is found",
        () async {
      SharedPreferences.setMockInitialValues(
        {},
      );
      final initialValue = await container.read(groupGamesProvider.future);
      expect(initialValue, const GameGrouping());
    });
    test("persists grouping like expected", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      const GameGrouping update = GameGrouping(
        groupStrategy: GroupStrategy.byPlatformFamily,
      );

      await container.read(groupGamesProvider.notifier).setGrouping(update);

      expect(await container.read(groupGamesProvider.future), update);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(GroupGames.storageKey),
        '{"groupStrategy":"byPlatformFamily"}',
      );
    });
  });
  test("applyGameGroupProvider groups games by platform family as expected",
      () async {
    SharedPreferences.setMockInitialValues(
      {},
    );
    final games = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    await container.read(groupGamesProvider.notifier).setGrouping(
          const GameGrouping(groupStrategy: GroupStrategy.byPlatformFamily),
        );
    await container.read(themeSettingsProvider.notifier).setLocale("de");

    final groupedGames =
        await container.read(applyGameGroupProvider(games).future);

    expect(groupedGames, {
      "PC": [TestGames.gameOuterWilds, TestGames.gameWitcher3],
      "Sony": [TestGames.gameSsx3, TestGames.gameOriAndTheBlindForest],
    });
  });
  test(
      "applyGameGroupProvider groups games to empty string for GroupStrategy.byNone",
      () async {
    SharedPreferences.setMockInitialValues(
      {},
    );
    final games = [
      TestGames.gameOuterWilds,
      TestGames.gameWitcher3,
      TestGames.gameSsx3,
      TestGames.gameOriAndTheBlindForest,
    ];

    await container
        .read(groupGamesProvider.notifier)
        .setGrouping(const GameGrouping());
    await container.read(themeSettingsProvider.notifier).setLocale("de");

    final groupedGames =
        await container.read(applyGameGroupProvider(games).future);

    expect(groupedGames, {
      "": games,
    });
  });
}
