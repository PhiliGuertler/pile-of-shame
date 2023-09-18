import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';
import 'package:pile_of_shame/providers/games/game_sorter_provider.dart';
import 'package:pile_of_shame/utils/file_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<FileUtils>(), MockSpec<File>()])
import 'game_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final gameZeldaBotw = Game(
    id: 'zelda-botw',
    name: "The Legend of Zelda: Breath of the Wild",
    platform: GamePlatform.nintendoSwitch,
    status: PlayStatus.playing,
    lastModified: DateTime(2023, 8, 8),
    price: 59.99,
    usk: USK.usk12,
    dlcs: [
      DLC(
        id: 'zelda-botw-die-legendaeren-pruefungen',
        name: "Die legendären Prüfungen",
        status: PlayStatus.playing,
        lastModified: DateTime(2023, 8, 8),
        price: 23.99,
      ),
      DLC(
        id: 'zelda-botw-die-ballade-der-recken',
        name: "Die Ballade der Recken",
        status: PlayStatus.playing,
        lastModified: DateTime(2023, 8, 8),
        price: 23.99,
      ),
    ],
  );
  final gameOuterWilds = Game(
    id: 'outer-wilds',
    name: "Outer Wilds",
    platform: GamePlatform.steam,
    status: PlayStatus.completed100Percent,
    lastModified: DateTime(2023, 8, 4),
    price: 29.95,
    usk: USK.usk12,
    dlcs: [
      DLC(
        id: 'outer-wilds-echoes-of-the-eye',
        name: "Echoes of the Eye",
        status: PlayStatus.completed100Percent,
        lastModified: DateTime(2023, 8, 8),
        price: 16.99,
      ),
    ],
  );
  final gameSekiro = Game(
    id: 'sekiro',
    name: "Sekiro",
    platform: GamePlatform.playStation4,
    status: PlayStatus.completed,
    lastModified: DateTime(2023, 8, 4),
    price: 60.00,
    usk: USK.usk18,
  );
  final gameDarkSouls = Game(
    id: 'dark-souls',
    name: "Dark Souls",
    platform: GamePlatform.steam,
    status: PlayStatus.replaying,
    lastModified: DateTime(2023, 4, 20),
    price: 39.99,
    usk: USK.usk16,
    dlcs: [
      DLC(
        id: 'dark-souls-artorias-of-the-abyss',
        name: "Artorias of the Abyss",
        status: PlayStatus.onWishList,
        lastModified: DateTime(2013, 7, 10),
        price: 9.99,
        notes: "DLC Notes",
      ),
    ],
    notes: "Game Notes",
  );

  late MockFileUtils mockFileUtils;
  late MockFile mockFile;
  late ProviderContainer container;

  setUp(() {
    mockFileUtils = MockFileUtils();
    container = ProviderContainer(overrides: [
      fileUtilsProvider.overrideWithValue(mockFileUtils),
    ]);
    mockFile = MockFile();
  });

  group("gamesProvider", () {
    test('returns an empty list if the file is empty', () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_empty.json'));

      final result = await container.read(gamesProvider.future);
      expect(result.games, []);
    });
    test('returns a list of games if the file is not empty', () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));

      final result = await container.read(gamesProvider.future);
      expect(result.games, [
        gameZeldaBotw,
        gameOuterWilds,
        gameSekiro,
      ]);
    });
    test('Successfully writes a list of games to the games file', () async {
      when(mockFileUtils.openFile(gameFileName))
          .thenAnswer((realInvocation) async => mockFile);

      const String stringifiedTestGameList =
          '{"games":[{"id":"dark-souls","name":"Dark Souls","platform":"Steam","status":"replaying","lastModified":"2023-04-20T00:00:00.000","price":39.99,"usk":"usk16","dlcs":[{"id":"dark-souls-artorias-of-the-abyss","name":"Artorias of the Abyss","status":"onWishList","lastModified":"2013-07-10T00:00:00.000","price":9.99,"notes":"DLC Notes"}],"notes":"Game Notes"}]}';

      // starts with an empty list as the mockfile returns an empty string
      final initialValue = await container.read(gamesProvider.future);
      when(mockFile.readAsString()).thenAnswer((realInvocation) async => "");
      // the game file should have been opened exactly once
      verify(mockFileUtils.openFile(gameFileName)).called(1);
      expect(initialValue.games, []);

      // returns the stringified test games at the next invocation of readAsString() on mockFile
      // to stub the process of writing the list to a file
      when(mockFile.readAsString())
          .thenAnswer((realInvocation) async => stringifiedTestGameList);
      await container.read(gameStorageProvider).persistGamesList(
            GamesList(games: [gameDarkSouls]),
          );
      verify(mockFile.writeAsString(stringifiedTestGameList)).called(1);

      // gamesProvider is supposed to be re-computed after the file was written
      final finalValue = await container.read(gamesProvider.future);
      // the game file should have been opened once more
      verify(mockFileUtils.openFile(gameFileName));
      expect(finalValue.games, [gameDarkSouls]);
    });
  });

  group("hasGamesProvider", () {
    test("returns false if there are no games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_empty.json'));

      final hasGames = await container.read(hasGamesProvider.future);

      expect(hasGames, false);
    });
    test("returns true if there are games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));

      final hasGames = await container.read(hasGamesProvider.future);

      expect(hasGames, true);
    });
  });

  group("gameByIdProvider", () {
    test("throws an exception if no game with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      try {
        await container.read(gameByIdProvider("unknown-game-id").future);
      } catch (error) {
        expect(error.toString(),
            "Exception: No game with id 'unknown-game-id' found");
        return;
      }
      fail("No exception thrown");
    });
    test("returns the game with the given id", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      final Game game =
          await container.read(gameByIdProvider(gameZeldaBotw.id).future);
      expect(game, gameZeldaBotw);
    });
  });
  group("dlcByGameAndIdProvider", () {
    test("throws an exception if no game with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      try {
        await container.read(
            dlcByGameAndIdProvider("unknown-game-id", "unknown-dlc-id").future);
      } catch (error) {
        expect(error.toString(),
            "Exception: No game with id 'unknown-game-id' found");
        return;
      }
      fail("No exception thrown");
    });
    test("throws an exception if no dlc with the given id exists", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      try {
        await container.read(
            dlcByGameAndIdProvider(gameZeldaBotw.id, "unknown-dlc-id").future);
      } catch (error) {
        expect(error.toString(),
            "Exception: No dlc with id 'unknown-dlc-id' found");
        return;
      }
      fail("No exception thrown");
    });
    test("returns the dlc with the given id", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      final DLC game = await container.read(
          dlcByGameAndIdProvider(gameZeldaBotw.id, gameZeldaBotw.dlcs[0].id)
              .future);
      expect(game, gameZeldaBotw.dlcs[0]);
    });
  });
  group("gamesFilteredProvider", () {
    test("returns all games by default, sorted by name", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      final GamesList games =
          await container.read(gamesFilteredProvider.future);

      expect(games.games, [
        gameOuterWilds,
        gameSekiro,
        gameZeldaBotw,
      ]);
    });
    test("returns filtered games only, sorted by name", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.nintendoSwitch, GamePlatform.playStation4]);

      final GamesList games =
          await container.read(gamesFilteredProvider.future);

      expect(games.games, [
        gameSekiro,
        gameZeldaBotw,
      ]);
    });
    test("returns filtered games with active search, sorted by price",
        () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      container.read(gameSearchProvider.notifier).setSearch("zelda");
      container.read(sortGamesProvider.notifier).setSorting(
            const GameSorting(
              isAscending: true,
              sortStrategy: SortStrategy.byPrice,
            ),
          );
      container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.nintendoSwitch, GamePlatform.playStation4]);

      final GamesList games =
          await container.read(gamesFilteredProvider.future);

      expect(games.games, [
        gameZeldaBotw,
      ]);
    });
  });
  group("gamesFilteredProvider", () {
    test("returns the sum of prices of all games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      final double totalPrice =
          await container.read(gamesFilteredTotalPriceProvider.future);

      expect(totalPrice, 59.99 + 23.99 + 23.99 + 29.95 + 16.99 + 60.00);
    });
    test("returns the sum prices of filtered games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.nintendoSwitch]);

      final double totalPrice =
          await container.read(gamesFilteredTotalPriceProvider.future);

      expect(totalPrice, 59.99 + 23.99 + 23.99);
    });
  });
  group("gamesFilteredTotalAmountProvider", () {
    test("returns the amount of all games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      final int amount =
          await container.read(gamesFilteredTotalAmountProvider.future);

      expect(amount, 3);
    });
    test("returns the amount of filtered games", () async {
      when(mockFileUtils.openFile(gameFileName)).thenAnswer(
          (realInvocation) async => File('test_resources/games_filled.json'));
      SharedPreferences.setMockInitialValues(
        {},
      );

      container
          .read(gamePlatformFilterProvider.notifier)
          .setFilter([GamePlatform.nintendoSwitch]);

      final int totalPrice =
          await container.read(gamesFilteredTotalAmountProvider.future);

      expect(totalPrice, 1);
    });
  });
}
