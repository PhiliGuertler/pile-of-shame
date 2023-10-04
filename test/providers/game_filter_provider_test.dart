import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_resources/test_games.dart';

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
    test("correctly applies platform filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.playStation2, GamePlatform.steam]);

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
      ]);
    });
    test("correctly applies platform family filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container
          .read(gamePlatformFamilyFilterProvider.notifier)
          .setFilter([GamePlatformFamily.sony]);

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ]);
    });
    test("correctly applies play status filters", () async {
      container
          .read(playStatusFilterProvider.notifier)
          .setFilter([PlayStatus.completed, PlayStatus.onPileOfShame]);

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(
        result,
        [TestGames.gameOuterWilds, TestGames.gameOriAndTheBlindForest],
      );
    });
    test("correctly applies age rating filters", () {
      container
          .read(ageRatingFilterProvider.notifier)
          .setFilter([USK.usk0, USK.usk6]);

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [TestGames.gameDistance, TestGames.gameSsx3]);
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
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result = container.read(applyGameFiltersProvider(originalGames));

      expect(result, [TestGames.gameOriAndTheBlindForest]);
    });
  });
}
