import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

void main() {
  group('Game', () {
    test("Correctly accumulates price of game without DLCs", () {
      final testGame = Game(
        id: 'test-game',
        name: "Test",
        platform: GamePlatform.gameCube,
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 8, 8),
        price: 49.99,
      );
      expect(testGame.fullPrice(), 49.99);
    });
    test("Correctly accumulates price of game with DLCs", () {
      final testGame = Game(
        id: 'test-game',
        name: "DLC heavy game",
        platform: GamePlatform.gog,
        status: PlayStatus.onPileOfShame,
        lastModified: DateTime(2023, 8, 8),
        price: 79.99,
        dlcs: [
          DLC(
            id: 'test-game-dlc1',
            name: "DLC 1",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 8, 8),
            price: 9.99,
          ),
          DLC(
            id: 'test-game-dlc2',
            name: "DLC 2",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 8, 8),
            price: 14.49,
          ),
        ],
      );
      expect(testGame.fullPrice(), 79.99 + 9.99 + 14.49);
    });
  });

  group('GamesList', () {
    final Game gameOuterWilds = Game(
      id: 'outer-wilds',
      lastModified: DateTime(2023, 1, 1),
      name: 'Outer Wilds',
      platform: GamePlatform.steam,
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
      usk: USK.usk12,
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

    test(
      'correctly updates an existing game',
      () {
        final GamesList gamesList = GamesList(
          games: [
            gameOuterWilds,
            gameDistance,
            gameSsx3,
            gameOriAndTheBlindForest,
          ],
        );

        final Game updatedGameDistance = gameDistance.copyWith(
          name: 'Distance Updated',
        );

        expect(gamesList.games, [
          gameOuterWilds,
          gameDistance,
          gameSsx3,
          gameOriAndTheBlindForest,
        ]);

        gamesList.updateGame(gameDistance.id, updatedGameDistance);

        expect(gamesList.games, [
          gameOuterWilds,
          updatedGameDistance,
          gameSsx3,
          gameOriAndTheBlindForest,
        ]);
      },
    );
    test(
      'throws an exception if attempting to update a non existing game',
      () {
        final GamesList gamesList = GamesList(
          games: [
            gameOuterWilds,
          ],
        );

        final Game updatedGameDistance = gameDistance.copyWith(
          name: 'Distance Updated',
        );

        expect(gamesList.games, [
          gameOuterWilds,
        ]);

        try {
          gamesList.updateGame(gameDistance.id, updatedGameDistance);
        } catch (error) {
          return;
        }
        fail('No exception thrown');
      },
    );
  });
}
