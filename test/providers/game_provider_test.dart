import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_filters.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_resources/test_games.dart';
@GenerateNiceMocks([MockSpec<FileUtils>(), MockSpec<File>()])
import 'game_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFileUtils mockFileUtils;
  late MockFile mockFile;
  late ProviderContainer container;

  setUp(() {
    mockFileUtils = MockFileUtils();
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [
        fileUtilsProvider.overrideWithValue(mockFileUtils),
      ],
    );
    mockFile = MockFile();
  });

  group("gamesProvider", () {
    test('returns an empty list if the file is empty', () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/games_empty.json'),
      );

      final result = await container.read(gamesProvider.future);
      expect(result, []);
    });
    test('returns a list of games if the file is not empty', () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );

      final result = await container.read(gamesProvider.future);
      expect(result, [
        TestGames.gameWitcher3,
        TestGames.gameSsx3,
        TestGames.gameOriAndTheBlindForest,
      ]);
    });
    test('migrates a list of games from v1 if the file is not empty', () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store-v1.json'),
      );

      final result = await container.read(gamesProvider.future);
      expect(result, [
        TestGames.gameWitcher3.copyWith(
          createdAt: TestGames.gameWitcher3.lastModified,
          dlcs: TestGames.gameWitcher3.dlcs
              .map((e) => e.copyWith(createdAt: e.lastModified))
              .toList(),
        ),
        TestGames.gameSsx3.copyWith(createdAt: TestGames.gameSsx3.lastModified),
        TestGames.gameOriAndTheBlindForest.copyWith(
          createdAt: TestGames.gameOriAndTheBlindForest.lastModified,
        ),
      ]);
    });
    test('Successfully writes a list of games to the games file', () async {
      when(mockFile.readAsString()).thenAnswer((realInvocation) async => "");
      when(mockFileUtils.openFile(gameFileName))
          .thenAnswer((realInvocation) async => mockFile);

      const String stringifiedTestGameList =
          '{"games":[${TestGames.gameWitcher3Json}],"hardware":[]}';

      // starts with an empty list as the mockfile returns an empty string
      final initialValue = await container.read(gamesProvider.future);
      when(mockFile.readAsString()).thenAnswer((realInvocation) async => "");
      // the game file should have been opened exactly once
      verify(mockFileUtils.openFile(gameFileName)).called(1);
      expect(initialValue, []);

      // returns the stringified test games at the next invocation of readAsString() on mockFile
      // to stub the process of writing the list to a file
      when(mockFile.readAsString())
          .thenAnswer((realInvocation) async => stringifiedTestGameList);
      await container.read(databaseStorageProvider).persistDatabase(
            Database(games: [TestGames.gameWitcher3], hardware: []),
          );
      verify(mockFile.writeAsString(stringifiedTestGameList)).called(1);

      // gamesProvider is supposed to be re-computed after the file was written
      final finalValue = await container.read(gamesProvider.future);
      // the game file should have been opened once more
      verify(mockFileUtils.openFile(gameFileName));
      expect(finalValue, [TestGames.gameWitcher3]);
    });
  });

  group("hasGamesProvider", () {
    test("returns false if there are no games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/games_empty.json'),
      );

      final hasGames = await container.read(hasGamesProvider.future);

      expect(hasGames, false);
    });
    test("returns true if there are games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );

      final hasGames = await container.read(hasGamesProvider.future);

      expect(hasGames, true);
    });
  });

  group("gameByIdProvider", () {
    test("throws an exception if no game with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      try {
        await container.read(gameByIdProvider("unknown-game-id").future);
      } catch (error) {
        expect(
          error.toString(),
          "Exception: No game with id 'unknown-game-id' found",
        );
        return;
      }
      fail("No exception thrown");
    });
    test("returns the game with the given id", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      final Game game = await container
          .read(gameByIdProvider(TestGames.gameWitcher3.id).future);
      expect(game, TestGames.gameWitcher3);
    });
  });
  group("dlcByGameAndIdProvider", () {
    test("throws an exception if no game with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      try {
        await container.read(
          dlcByGameAndIdProvider("unknown-game-id", "unknown-dlc-id").future,
        );
      } catch (error) {
        expect(
          error.toString(),
          "Exception: No game with id 'unknown-game-id' found",
        );
        return;
      }
      fail("No exception thrown");
    });
    test("throws an exception if no dlc with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      try {
        await container.read(
          dlcByGameAndIdProvider(TestGames.gameWitcher3.id, "unknown-dlc-id")
              .future,
        );
      } catch (error) {
        expect(
          error.toString(),
          "Exception: No dlc with id 'unknown-dlc-id' found",
        );
        return;
      }
      fail("No exception thrown");
    });
    test("returns the dlc with the given id", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      final DLC game = await container.read(
        dlcByGameAndIdProvider(
          TestGames.gameWitcher3.id,
          TestGames.dlcWitcher3BloodAndWine.id,
        ).future,
      );
      expect(game, TestGames.gameWitcher3.dlcs[1]);
    });
  });
  group("gamesFilteredProvider", () {
    test("returns all games by default, sorted by name", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      final List<Game> games =
          await container.read(gamesFilteredProvider.future);

      expect(games, [
        TestGames.gameOriAndTheBlindForest,
        TestGames.gameSsx3,
        TestGames.gameWitcher3,
      ]);
    });
    test("returns filtered games only, sorted by name", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(
              platforms: [GamePlatform.gog, GamePlatform.playStation4],
            ),
          );

      final List<Game> games =
          await container.read(gamesFilteredProvider.future);

      expect(games, [
        TestGames.gameOriAndTheBlindForest,
        TestGames.gameWitcher3,
      ]);
    });
    test("returns filtered games with active search, sorted by price",
        () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      container.read(gameSearchProvider.notifier).setSearch("witcher");
      container.read(sortGamesProvider.notifier).setSorting(
            const GameSorting(
              sortStrategy: SortStrategy.byPrice,
            ),
          );
      await container.read(gameFilterProvider.notifier).setFilters(
            const GameFilters(
              platforms: [GamePlatform.gog, GamePlatform.playStation4],
            ),
          );

      final List<Game> games =
          await container.read(gamesFilteredProvider.future);

      expect(games, [
        TestGames.gameWitcher3,
      ]);
    });
  });
  group("gamesFilteredProvider", () {
    test("returns the sum of prices of all games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      final double totalPrice =
          await container.read(gamesFilteredTotalPriceProvider.future);

      expect(
        totalPrice,
        TestGames.gameWitcher3.fullPrice() +
            TestGames.gameSsx3.fullPrice() +
            TestGames.gameOriAndTheBlindForest.fullPrice(),
      );
    });
    test("returns the sum prices of filtered games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(gameFilterProvider.notifier)
          .setFilters(const GameFilters(platforms: [GamePlatform.gog]));

      final double totalPrice =
          await container.read(gamesFilteredTotalPriceProvider.future);

      expect(totalPrice, TestGames.gameWitcher3.fullPrice());
    });
  });
  group("gamesFilteredTotalAmountProvider", () {
    test("returns the amount of all games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      final int amount =
          await container.read(gamesFilteredTotalAmountProvider.future);

      expect(amount, 3);
    });
    test("returns the amount of filtered games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/game-store.json'),
      );
      SharedPreferences.setMockInitialValues(
        {},
      );

      container
          .read(gameFilterProvider.notifier)
          .setFilters(const GameFilters(platforms: [GamePlatform.gog]));

      final int totalPrice =
          await container.read(gamesFilteredTotalAmountProvider.future);

      expect(totalPrice, 1);
    });
  });
}
