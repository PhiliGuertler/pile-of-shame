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
import 'package:pile_of_shame/providers/game_file_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/utils/file_utils.dart';

@GenerateNiceMocks([MockSpec<FileUtils>()])
import 'game_provider_test.mocks.dart';

void main() {
  late MockFileUtils mockFileUtils;
  late ProviderContainer container;

  setUp(() {
    mockFileUtils = MockFileUtils();
    container = ProviderContainer(overrides: [
      fileUtilsProvider.overrideWithValue(mockFileUtils),
    ]);
  });

  test('returns an empty list if the file is empty', () async {
    when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/games_empty.json'));

    final result = await container.read(gamesProvider.future);
    expect(result, []);
  });
  test('returns a list of games if the file is not empty', () async {
    when(mockFileUtils.openFile(gameFileName)).thenAnswer(
        (realInvocation) async => File('test_resources/games_filled.json'));

    final result = await container.read(gamesProvider.future);
    expect(result, [
      Game(
        name: "The Legend of Zelda: Breath of the Wild",
        platform: GamePlatform.nintendoSwitch,
        status: PlayStatus.playing,
        lastModified: DateTime(2023, 8, 8),
        price: 59.99,
        usk: USK.usk12,
        dlcs: [
          DLC(
            name: "Die legendären Prüfungen",
            status: PlayStatus.playing,
            lastModified: DateTime(2023, 8, 8),
            price: 23.99,
            releaseDate: DateTime(2018, 9, 3),
          ),
          DLC(
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
        name: "Outer Wilds",
        platform: GamePlatform.steam,
        status: PlayStatus.completed100Percent,
        lastModified: DateTime(2023, 8, 4),
        price: 29.95,
        usk: USK.usk12,
        dlcs: [
          DLC(
            name: "Echoes of the Eye",
            status: PlayStatus.completed100Percent,
            lastModified: DateTime(2023, 8, 8),
            price: 16.99,
          ),
        ],
      ),
      Game(
        name: "Sekiro",
        platform: GamePlatform.playStation4,
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 8, 4),
        price: 60.00,
        usk: USK.usk18,
      ),
    ]);
  });
}
