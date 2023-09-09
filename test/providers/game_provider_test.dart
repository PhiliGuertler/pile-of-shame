import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/file_provider.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/file_utils.dart';

@GenerateNiceMocks([MockSpec<FileUtils>(), MockSpec<File>()])
import 'game_provider_test.mocks.dart';

void main() {
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
      Game(
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
            releaseDate: DateTime(2018, 9, 3),
          ),
          DLC(
            id: 'zelda-botw-die-ballade-der-recken',
            name: "Die Ballade der Recken",
            status: PlayStatus.playing,
            lastModified: DateTime(2023, 8, 8),
            price: 23.99,
            releaseDate: DateTime(2019, 3, 13),
          ),
        ],
        releaseDate: DateTime(2017, 4, 20),
        coverArt:
            "https://cdn02.plentymarkets.com/qozbgypaugq8/item/images/1613/full/PSTR-ZELDA005.jpg",
      ),
      Game(
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
      ),
      Game(
        id: 'sekiro',
        name: "Sekiro",
        platform: GamePlatform.playStation4,
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 8, 4),
        price: 60.00,
        usk: USK.usk18,
      ),
    ]);
  });
  test('Successfully writes a list of games to the games file', () async {
    when(mockFileUtils.openFile(gameFileName))
        .thenAnswer((realInvocation) async => mockFile);

    final testGame = Game(
      id: 'dark-souls',
      name: "Dark Souls",
      platform: GamePlatform.steam,
      status: PlayStatus.replaying,
      lastModified: DateTime(2023, 4, 20),
      price: 39.99,
      coverArt: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      releaseDate: DateTime(2012, 9, 23),
      usk: USK.usk16,
      dlcs: [
        DLC(
          id: 'dark-souls-artorias-of-the-abyss',
          name: "Artorias of the Abyss",
          status: PlayStatus.onWishList,
          lastModified: DateTime(2013, 7, 10),
          price: 9.99,
        ),
      ],
    );

    const String stringifiedTestGameList =
        '{"games":[{"id":"dark-souls","name":"Dark Souls","platform":"Steam","status":"replaying","lastModified":"2023-04-20T00:00:00.000","price":39.99,"usk":"usk16","dlcs":[{"id":"dark-souls-artorias-of-the-abyss","name":"Artorias of the Abyss","status":"onWishList","lastModified":"2013-07-10T00:00:00.000","price":9.99,"releaseDate":null}],"releaseDate":"2012-09-23T00:00:00.000","coverArt":"https://www.youtube.com/watch?v=dQw4w9WgXcQ"}]}';

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
          GamesList(games: [testGame]),
        );
    verify(mockFile.writeAsString(stringifiedTestGameList)).called(1);

    // gamesProvider is supposed to be re-computed after the file was written
    final finalValue = await container.read(gamesProvider.future);
    // the game file should have been opened once more
    verify(mockFileUtils.openFile(gameFileName));
    expect(finalValue.games, [testGame]);
  });
}
