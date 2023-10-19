import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_filters.dart';
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
    test("returns false by default if no filter is active", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );
      final isFilterActive =
          await container.read(isAnyFilterActiveProvider.future);

      expect(isFilterActive, false);
    });
    group("platform filters", () {
      test("returns true if a platform filter is active", () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        await container
            .read(gameFilterProvider.notifier)
            .setFilters(const GameFilters(platforms: [GamePlatform.epicGames]));

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

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
            .read(gameFilterProvider.notifier)
            .setFilters(GameFilters(platforms: activePlatforms));

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

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
            .read(gameFilterProvider.notifier)
            .setFilters(GameFilters(platforms: filterPlatforms));

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

        expect(isFilterActive, true);
      });
    });
    group("game platform family filters", () {
      test("returns true if a platform family filter is active", () async {
        SharedPreferences.setMockInitialValues(
          {},
        );
        await container.read(gameFilterProvider.notifier).setFilters(
              const GameFilters(
                platformFamilies: [GamePlatformFamily.nintendo],
              ),
            );

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

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
            .read(gameFilterProvider.notifier)
            .setFilters(GameFilters(platformFamilies: filter));

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

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
            .read(gameFilterProvider.notifier)
            .setFilters(GameFilters(platformFamilies: filter));

        final isFilterActive =
            await container.read(isAnyFilterActiveProvider.future);

        expect(isFilterActive, true);
      });
    });
    test("returns true if a play status filter is active", () async {
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(playstatuses: [PlayStatus.endlessGame]),
          );

      final isFilterActive =
          await container.read(isAnyFilterActiveProvider.future);

      expect(isFilterActive, true);
    });
    test("returns true if a age-rating filter is active", () async {
      await container
          .read(gameFilterProvider.notifier)
          .setFilters(const GameFilters(ageRatings: [USK.usk12]));

      final isFilterActive =
          await container.read(isAnyFilterActiveProvider.future);

      expect(isFilterActive, true);
    });
  });

  group("applyGameFiltersProvider", () {
    test("correctly applies platform filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(
              platforms: [GamePlatform.playStation2, GamePlatform.steam],
            ),
          );

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result =
          await container.read(applyGameFiltersProvider(originalGames).future);

      expect(result, [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
      ]);
    });
    test("correctly applies platform family filters", () async {
      SharedPreferences.setMockInitialValues({});
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(platformFamilies: [GamePlatformFamily.sony]),
          );

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result =
          await container.read(applyGameFiltersProvider(originalGames).future);

      expect(result, [
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ]);
    });
    test("correctly applies play status filters", () async {
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(
              playstatuses: [PlayStatus.completed, PlayStatus.onPileOfShame],
            ),
          );

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result =
          await container.read(applyGameFiltersProvider(originalGames).future);

      expect(
        result,
        [TestGames.gameOuterWilds, TestGames.gameOriAndTheBlindForest],
      );
    });
    test("correctly applies age rating filters", () async {
      await container
          .read(gameFilterProvider.notifier)
          .setFilters(const GameFilters(ageRatings: [USK.usk0, USK.usk6]));

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result =
          await container.read(applyGameFiltersProvider(originalGames).future);

      expect(result, [TestGames.gameDistance, TestGames.gameSsx3]);
    });
    test("correctly applies multiple filters", () async {
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(
              ageRatings: [USK.usk12],
              platformFamilies: [GamePlatformFamily.sony],
              platforms: [GamePlatform.playStation4],
              playstatuses: [PlayStatus.onPileOfShame],
            ),
          );

      final originalGames = [
        TestGames.gameOuterWilds,
        TestGames.gameDistance,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ];

      final result =
          await container.read(applyGameFiltersProvider(originalGames).future);

      expect(result, [TestGames.gameOriAndTheBlindForest]);
    });
  });
}
