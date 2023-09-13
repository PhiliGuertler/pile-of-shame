import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });
  group("isAnyFilterActiveProvider", () {
    test("returns false by default if no filter is active", () {
      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, false);
    });
    test("returns true if a platform filter is active", () {
      container.read(gamePlatformFilterProvider.notifier).setFilter([]);

      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, true);
    });
    test("returns true if a platform family filter is active", () {
      container
          .read(gamePlatformFamilyFilterProvider.notifier)
          .setFilter([GamePlatformFamily.nintendo]);

      final isFilterActive = container.read(isAnyFilterActiveProvider);

      expect(isFilterActive, true);
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
    test("correctly applies platform filters", () {
      container
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
    test("correctly applies platform family filters", () {
      container
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
    test("correctly applies play status filters", () {
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
