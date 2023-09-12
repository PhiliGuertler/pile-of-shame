import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_storage.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';

import '../test_utils/fake_path_provider.dart';
@GenerateNiceMocks([MockSpec<File>()])
import 'game_storage_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePathProviderPlatform mockPathProviderPlatform;
  late ProviderContainer container;
  late MockFile gameFile;

  final Game testGame = Game(
    id: "testGame",
    name: "Test Game",
    platform: GamePlatform.gameBoy,
    status: PlayStatus.completed,
    lastModified: DateTime(2023, 9, 12),
    price: 19.99,
  );
  final GamesList testGameList = GamesList(games: [testGame]);
  const String jsonGameList =
      '{"games":[{"id":"testGame","name":"Test Game","platform":"GB","status":"completed","lastModified":"2023-09-12T00:00:00.000","price":19.99,"usk":"usk0","dlcs":[],"releaseDate":null,"coverArt":null}]}';

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;

    gameFile = MockFile();

    container = ProviderContainer(overrides: [
      gameFileProvider.overrideWith((ref) => gameFile),
      gamesProvider.overrideWith((ref) => testGameList)
    ]);
  });

  group("persistGamesList", () {
    test("writes into gameFileProvider's value by default", () async {
      final GameStorage storage = container.read(gameStorageProvider);

      verifyNever(gameFile.writeAsString(jsonGameList));

      await storage.persistGamesList(
        testGameList,
      );

      verify(gameFile.writeAsString(jsonGameList)).called(1);
    });
    test("writes into the input file if provided", () async {
      final GameStorage storage = container.read(gameStorageProvider);
      final MockFile file = MockFile();

      verifyNever(gameFile.writeAsString(jsonGameList));
      verifyNever(file.writeAsString(jsonGameList));

      await storage.persistGamesList(testGameList, file);

      // Did not write into gameFileProvider's file
      verifyNever(gameFile.writeAsString(jsonGameList));
      verify(file.writeAsString(jsonGameList)).called(1);
    });
  });
  group("readGamesFromFile", () {
    test("reads the game list correctly", () async {
      final GameStorage storage = container.read(gameStorageProvider);
      final MockFile file = MockFile();

      when(file.readAsString()).thenAnswer(
        (realInvocation) => Future.value(jsonGameList),
      );

      verifyNever(file.readAsString());

      final GamesList result = await storage.readGamesFromFile(file);

      verify(file.readAsString()).called(1);

      expect(result, testGameList);
    });
  });
  group("persistCurrentGames", () {
    test("persists the list of current games correctly", () async {
      final GameStorage storage = container.read(gameStorageProvider);

      verifyNever(gameFile.writeAsString(jsonGameList));

      await storage.persistCurrentGames();

      verify(gameFile.writeAsString(jsonGameList)).called(1);
    });
  });
}
