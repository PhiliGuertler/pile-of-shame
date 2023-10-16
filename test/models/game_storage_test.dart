import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/database_storage.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';

import '../../test_resources/test_games.dart';
import '../test_utils/fake_path_provider.dart';
@GenerateNiceMocks([MockSpec<File>()])
import 'game_storage_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePathProviderPlatform mockPathProviderPlatform;
  late ProviderContainer container;
  late MockFile databaseFile;

  final Database testGameList =
      Database(games: [TestGames.gameWitcher3], hardware: {});
  const String jsonGameList = '{"games":[${TestGames.gameWitcher3Json}]}';

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;

    databaseFile = MockFile();

    container = ProviderContainer(
      overrides: [
        databaseFileProvider.overrideWith((ref) => databaseFile),
        gamesProvider.overrideWith((ref) => testGameList.games),
      ],
    );
  });

  group("persistGamesList", () {
    test("writes into gameFileProvider's value by default", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);

      verifyNever(databaseFile.writeAsString(jsonGameList));

      await storage.persistDatabase(
        testGameList,
      );

      verify(databaseFile.writeAsString(jsonGameList)).called(1);
    });
    test("writes into the input file if provided", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);
      final MockFile file = MockFile();

      verifyNever(databaseFile.writeAsString(jsonGameList));
      verifyNever(file.writeAsString(jsonGameList));

      await storage.persistDatabase(testGameList, file);

      // Did not write into gameFileProvider's file
      verifyNever(databaseFile.writeAsString(jsonGameList));
      verify(file.writeAsString(jsonGameList)).called(1);
    });
  });
  group("readGamesFromFile", () {
    test("reads the game list correctly", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);
      final MockFile file = MockFile();

      when(file.readAsString()).thenAnswer(
        (realInvocation) => Future.value(jsonGameList),
      );

      verifyNever(file.readAsString());

      final Database result = await storage.readDatabaseFromFile(file);

      verify(file.readAsString()).called(1);

      expect(result, testGameList);
    });
  });
  group("persistCurrentGames", () {
    test("persists the list of current games correctly", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);

      verifyNever(databaseFile.writeAsString(jsonGameList));

      await storage.persistCurrentDatabase();

      verify(databaseFile.writeAsString(jsonGameList)).called(1);
    });
  });
}
