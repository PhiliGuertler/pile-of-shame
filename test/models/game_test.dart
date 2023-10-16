import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';

import '../../test_resources/test_games.dart';

void main() {
  group('Game', () {
    test("Correctly accumulates price of game without DLCs", () {
      expect(TestGames.gameSsx3.fullPrice(), 39.95);
    });
    test("Correctly accumulates price of game with DLCs", () {
      expect(TestGames.gameWitcher3.fullPrice(), 59.99 + 19.99 + 9.99);
    });
  });

  group('Database', () {
    group('updateGame', () {
      test(
        'correctly updates an existing game',
        () {
          final Database gamesList = Database(
            games: [
              TestGames.gameOuterWilds,
              TestGames.gameDistance,
              TestGames.gameSsx3,
              TestGames.gameOriAndTheBlindForest,
            ],
            hardware: {},
          );

          final Game updatedGameDistance = TestGames.gameDistance.copyWith(
            name: 'Distance Updated',
          );

          expect(gamesList.games, [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ]);

          final result = gamesList.updateGame(
            TestGames.gameDistance.id,
            updatedGameDistance,
          );

          expect(result.games, [
            TestGames.gameOuterWilds,
            updatedGameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ]);
        },
      );
      test(
        'throws an exception if attempting to update a non existing game',
        () {
          final Database gamesList = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: {},
          );

          final Game updatedGameDistance = TestGames.gameDistance.copyWith(
            name: 'Distance Updated',
          );

          expect(gamesList.games, [
            TestGames.gameOuterWilds,
          ]);

          try {
            gamesList.updateGame(
              TestGames.gameDistance.id,
              updatedGameDistance,
            );
          } catch (error) {
            return;
          }
          fail('No exception thrown');
        },
      );
    });
    group('removeGame', () {
      test('correctly removes an existing Game', () {
        final Database gamesList = Database(
          games: [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ],
          hardware: {},
        );

        expect(gamesList.games, [
          TestGames.gameOuterWilds,
          TestGames.gameDistance,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
        ]);

        final result = gamesList.removeGame(TestGames.gameDistance.id);

        expect(result.games, [
          TestGames.gameOuterWilds,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
        ]);
      });
      test('throws an exception if no game with the given id exists', () {
        final Database gamesList = Database(
          games: [
            TestGames.gameOuterWilds,
          ],
          hardware: {},
        );

        expect(gamesList.games, [
          TestGames.gameOuterWilds,
        ]);

        try {
          gamesList.removeGame(TestGames.gameDistance.id);
        } catch (error) {
          return;
        }

        fail('No exception thrown');
      });
    });
    group('addGame', () {
      test('correctly adds a new Game', () {
        final Database gamesList = Database(
          games: [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
          ],
          hardware: {},
        );

        expect(gamesList.games, [
          TestGames.gameOuterWilds,
          TestGames.gameDistance,
          TestGames.gameSsx3,
        ]);

        final result = gamesList.addGame(TestGames.gameOriAndTheBlindForest);

        expect(result.games, [
          TestGames.gameOuterWilds,
          TestGames.gameDistance,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
        ]);
      });
      test(
          "throws an exception if a game with the new game's id already exists",
          () {
        final Database gamesList = Database(
          games: [
            TestGames.gameOuterWilds,
          ],
          hardware: {},
        );

        expect(gamesList.games, [
          TestGames.gameOuterWilds,
        ]);

        try {
          gamesList.addGame(TestGames.gameOuterWilds);
        } catch (error) {
          return;
        }

        fail('No exception thrown');
      });
    });
    group("updateGamesByLastModified", () {
      test("correctly updates older games only", () {
        final Database original = Database(
          games: [
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ],
          hardware: {},
        );

        final Game updatedDistance = TestGames.gameDistance.copyWith(
          usk: USK.usk18,
          lastModified: DateTime(2024, 9, 12),
        );
        final Game updatedOri = TestGames.gameOriAndTheBlindForest.copyWith(
          price: 999.95,
          lastModified: DateTime(2022),
        );

        final Database update = Database(
          games: [
            updatedOri,
            updatedDistance,
          ],
          hardware: {},
        );

        final Database result = original.updateGamesByLastModified(update);

        expect(result.games, [
          updatedDistance,
          TestGames.gameSsx3,
          // the update-game is older, so this should not have been updated
          TestGames.gameOriAndTheBlindForest,
        ]);
      });
    });
    group("addMissingGames", () {
      test("correctly adds missing games only", () {
        final Database original = Database(
          games: [
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ],
          hardware: {},
        );

        final Database update = Database(
          games: [
            TestGames.gameOuterWilds,
            TestGames.gameSsx3,
          ],
          hardware: {},
        );

        final Database result = original.addMissingGames(update);

        expect(result.games, [
          TestGames.gameDistance,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
          TestGames.gameOuterWilds,
        ]);
      });
    });
  });
}
