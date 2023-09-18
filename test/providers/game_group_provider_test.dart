import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_group_provider.dart';
import 'package:pile_of_shame/providers/theming/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final Game gameOuterWilds = Game(
    id: 'outer-wilds',
    lastModified: DateTime(2023, 1, 1),
    name: 'Outer Wilds',
    platform: GamePlatform.steam,
    price: 24.99,
    status: PlayStatus.completed,
    dlcs: [],
    usk: USK.usk12,
    notes: "Outer Wilds can sadly only be played once...",
  );
  final Game gamePokemonX = Game(
    id: 'pokemon-x',
    lastModified: DateTime(2023, 1, 2),
    name: 'Pokémon X',
    platform: GamePlatform.steam,
    price: 19.99,
    status: PlayStatus.playing,
    dlcs: [],
    usk: USK.usk12,
  );
  final Game gameSsx3 = Game(
    id: 'ssx-3',
    lastModified: DateTime(2023, 1, 3),
    name: 'SSX 3',
    platform: GamePlatform.unknown,
    price: 39.95,
    status: PlayStatus.completed100Percent,
    dlcs: [],
    usk: USK.usk12,
  );
  final Game gameOriAndTheBlindForest = Game(
    id: 'ori-and-the-blind-forest',
    lastModified: DateTime(2023, 1, 4),
    name: 'Ori and the blind forest',
    platform: GamePlatform.unknown,
    price: 25,
    status: PlayStatus.onPileOfShame,
    dlcs: [],
    usk: USK.usk12,
  );

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
      expect(initialValue,
          const GameGrouping(groupStrategy: GroupStrategy.byPlatform));
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
      expect(prefs.getString(GroupGames.storageKey),
          '{"groupStrategy":"byPlatformFamily"}');
    });
  });
  test("applyGameGroupProvider groups games by platform family as expected",
      () async {
    SharedPreferences.setMockInitialValues(
      {},
    );
    final games = [
      gameOuterWilds,
      gameSsx3,
      gamePokemonX,
      gameOriAndTheBlindForest,
    ];

    await container.read(groupGamesProvider.notifier).setGrouping(
        const GameGrouping(groupStrategy: GroupStrategy.byPlatformFamily));
    await container.read(appThemeSettingsProvider.notifier).setLocale("de");

    final groupedGames =
        await container.read(applyGameGroupProvider(games).future);

    expect(groupedGames, {
      "PC": [gameOuterWilds, gamePokemonX],
      "Sonstige": [gameSsx3, gameOriAndTheBlindForest],
    });
  });
  test(
      "applyGameGroupProvider groups games to empty string for GroupStrategy.byNone",
      () async {
    SharedPreferences.setMockInitialValues(
      {},
    );
    final games = [
      gameOuterWilds,
      gameSsx3,
      gamePokemonX,
      gameOriAndTheBlindForest,
    ];

    await container
        .read(groupGamesProvider.notifier)
        .setGrouping(const GameGrouping(groupStrategy: GroupStrategy.byNone));
    await container.read(appThemeSettingsProvider.notifier).setLocale("de");

    final groupedGames =
        await container.read(applyGameGroupProvider(games).future);

    expect(groupedGames, {
      "": games,
    });
  });
}
