import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });
  group("isAnyFilterActiveProvider", () {
    test("returns false by default if no filter is active", () {
      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, false);
    });
    group("platform filters", () {
      test("returns true if a platform filter is active", () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        await container
            .read(gamePlatformFilterProvider.notifier)
            .setFilter([GamePlatform.epicGames]);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, true);
      });
      test(
          "returns false if a platform filter is active that is filtering inactive platforms",
          () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        final List<GamePlatform> activePlatforms =
            List.from(GamePlatform.values);
        activePlatforms.remove(GamePlatform.epicGames);
        await container
            .read(activeGamePlatformsProvider.notifier)
            .updatePlatforms(activePlatforms);
        await container
            .read(gamePlatformFilterProvider.notifier)
            .setFilter(activePlatforms);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, false);
      });
      test(
          "returns true if a platform filter is active that is filtering an active platform",
          () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        final List<GamePlatform> activePlatforms =
            List.from(GamePlatform.values);
        activePlatforms.remove(GamePlatform.epicGames);
        await container
            .read(activeGamePlatformsProvider.notifier)
            .updatePlatforms(activePlatforms);

        final List<GamePlatform> filterPlatforms =
            List.from(GamePlatform.values);
        filterPlatforms.remove(GamePlatform.nintendoSwitch);
        await container
            .read(gamePlatformFilterProvider.notifier)
            .setFilter(filterPlatforms);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, true);
      });
    });
    group("game platform family filters", () {
      test("returns true if a platform family filter is active", () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        await container
            .read(gamePlatformFamilyFilterProvider.notifier)
            .setFilter([GamePlatformFamily.nintendo]);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, true);
      });
      test(
          "returns false if a platform family filter is active that is filtering an inactive family",
          () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        final List<GamePlatform> activePlatforms =
            List.from(GamePlatform.values);
        activePlatforms.removeWhere(
          (element) => element.family == GamePlatformFamily.microsoft,
        );
        await container
            .read(activeGamePlatformsProvider.notifier)
            .updatePlatforms(activePlatforms);

        final List<GamePlatformFamily> filter =
            List.from(GamePlatformFamily.values);
        filter.remove(GamePlatformFamily.microsoft);
        await container
            .read(gamePlatformFamilyFilterProvider.notifier)
            .setFilter(filter);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, false);
      });
      test(
          "returns true if a platform family filter is active that is filtering an active family",
          () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        final List<GamePlatform> activePlatforms =
            List.from(GamePlatform.values);
        activePlatforms.removeWhere(
          (element) => element.family == GamePlatformFamily.microsoft,
        );
        await container
            .read(activeGamePlatformsProvider.notifier)
            .updatePlatforms(activePlatforms);

        final List<GamePlatformFamily> filter =
            List.from(GamePlatformFamily.values);
        filter.remove(GamePlatformFamily.nintendo);
        await container
            .read(gamePlatformFamilyFilterProvider.notifier)
            .setFilter(filter);

        final isFilterActive = container.read(isAnyFilterActiveProvider);

        expect(isFilterActive, true);
      });
    });
    test("returns true if a play status filter is active", () {
      container
          .read(playStatusFilterProvider.notifier)
          .setFilter([PlayStatus.endlessGame]);

      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, true);
    });
    test("returns true if a age-rating filter is active", () {
      container.read(ageRatingFilterProvider.notifier).setFilter([USK.usk12]);

      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, true);
    });
  });

  group("applyGameFiltersProvider", () {
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
    final Game gameDistance = Game(
      id: 'distance',
      lastModified: DateTime(2023, 1, 2),
      name: 'Distance',
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
    test("correctly applies platform filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.playStation2, GamePlatform.steam]);

      final originalGames = [
        gameOuterWilds,
        gameDistance,
        gameSsx3,
        gameOriAndTheBlindForest
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [gameDistance, gameSsx3]);
    });
    test("correctly applies platform family filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container
          .read(gamePlatformFamilyFilterProvider.notifier)
          .setFilter([GamePlatformFamily.sony, GamePlatformFamily.pc]);

      final originalGames = [
        gameOuterWilds,
        gameDistance,
        gameSsx3,
        gameOriAndTheBlindForest
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [gameDistance, gameSsx3, gameOriAndTheBlindForest]);
    });
    test("correctly applies play status filters", () async {
      container
          .read(playStatusFilterProvider.notifier)
          .setFilter([PlayStatus.completed, PlayStatus.onPileOfShame]);

      final originalGames = [
        gameOuterWilds,
        gameDistance,
        gameSsx3,
        gameOriAndTheBlindForest
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [gameOuterWilds, gameOriAndTheBlindForest]);
    });
    test("correctly applies age rating filters", () {
      container
          .read(ageRatingFilterProvider.notifier)
          .setFilter([USK.usk0, USK.usk6]);

      final originalGames = [
        gameOuterWilds,
        gameDistance,
        gameSsx3,
        gameOriAndTheBlindForest
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [gameDistance, gameSsx3]);
    });
    test("correctly applies multiple filters", () {
      container.read(ageRatingFilterProvider.notifier).setFilter([USK.usk12]);
      container
          .read(gamePlatformFamilyFilterProvider.notifier)
          .setFilter([GamePlatformFamily.sony]);
      container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.playStation4]);
      container
          .read(playStatusFilterProvider.notifier)
          .setFilter([PlayStatus.onPileOfShame]);

      final originalGames = [
        gameOuterWilds,
        gameDistance,
        gameSsx3,
        gameOriAndTheBlindForest
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [gameOriAndTheBlindForest]);
    });
  });
}
