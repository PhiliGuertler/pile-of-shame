import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/database_storage.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';

import '../../test_resources/test_games.dart';
import '../../test_resources/test_hardware.dart';
import '../test_utils/fake_path_provider.dart';
@GenerateNiceMocks([MockSpec<File>()])
import 'game_storage_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePathProviderPlatform mockPathProviderPlatform;
  late ProviderContainer container;
  late MockFile databaseFile;

  final Database testDatabase = Database(
    games: [
      TestGames.gameWitcher3,
    ],
    hardware: {
      GamePlatform.playStation5: [TestHardware.console],
    },
  );
  const String jsonDatabase =
      '{"games":[${TestGames.gameWitcher3Json}],"hardware":{"PS5":[${TestHardware.consoleJson}]}}';

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;

    databaseFile = MockFile();

    container = ProviderContainer(
      overrides: [
        databaseFileProvider.overrideWith((ref) => databaseFile),
      ],
    );
  });

  group("persistGamesList", () {
    test("writes into gameFileProvider's value by default", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);

      verifyNever(databaseFile.writeAsString(jsonDatabase));

      await storage.persistDatabase(
        testDatabase,
      );

      verify(databaseFile.writeAsString(jsonDatabase)).called(1);
    });
    test("writes into the input file if provided", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);
      final MockFile file = MockFile();

      verifyNever(databaseFile.writeAsString(jsonDatabase));
      verifyNever(file.writeAsString(jsonDatabase));

      await storage.persistDatabase(testDatabase, file);

      // Did not write into gameFileProvider's file
      verifyNever(databaseFile.writeAsString(jsonDatabase));
      verify(file.writeAsString(jsonDatabase)).called(1);
    });
  });
  group("readGamesFromFile", () {
    test("reads the game list correctly", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);
      final MockFile file = MockFile();

      when(file.readAsString()).thenAnswer(
        (realInvocation) => Future.value(jsonDatabase),
      );

      verifyNever(file.readAsString());

      final Database result = await storage.readDatabaseFromFile(file);

      verify(file.readAsString()).called(1);

      expect(result, testDatabase);
    });
  });
  group("persistCurrentGames", () {
    test("persists the list of current games correctly", () async {
      final DatabaseStorage storage = container.read(databaseStorageProvider);

      when(databaseFile.readAsString()).thenAnswer(
        (realInvocation) => Future.value(jsonDatabase),
      );

      verifyNever(databaseFile.writeAsString(jsonDatabase));

      await storage.persistCurrentDatabase();

      verify(databaseFile.writeAsString(jsonDatabase)).called(1);
    });
  });
}
