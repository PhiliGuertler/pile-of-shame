import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';

import '../../test_resources/test_games.dart';
import '../../test_resources/test_hardware.dart';

void main() {
  group('Database', () {
    group("Game manipulation", () {
      group('updateGame', () {
        test(
          'correctly updates an existing game without modifying the hardware',
          () {
            final List<VideoGameHardware> hardware = [
              TestHardware.console,
              TestHardware.controllerRed,
            ];

            final Database database = Database(
              games: [
                TestGames.gameOuterWilds,
                TestGames.gameDistance,
                TestGames.gameSsx3,
                TestGames.gameOriAndTheBlindForest,
              ],
              hardware: hardware,
            );

            final Game updatedGameDistance = TestGames.gameDistance.copyWith(
              name: 'Distance Updated',
            );

            expect(database.games, [
              TestGames.gameOuterWilds,
              TestGames.gameDistance,
              TestGames.gameSsx3,
              TestGames.gameOriAndTheBlindForest,
            ]);
            expect(database.hardware, hardware);

            final result = database.updateGame(
              TestGames.gameDistance.id,
              updatedGameDistance,
            );

            expect(result.games, [
              TestGames.gameOuterWilds,
              updatedGameDistance,
              TestGames.gameSsx3,
              TestGames.gameOriAndTheBlindForest,
            ]);
            expect(result.hardware, hardware);
          },
        );
        test(
          'throws an exception if attempting to update a non existing game',
          () {
            final Database gamesList = Database(
              games: [
                TestGames.gameOuterWilds,
              ],
              hardware: [],
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
        test(
            'correctly removes an existing Game without modifying the hardware',
            () {
          final List<VideoGameHardware> hardware = [
            TestHardware.console,
            TestHardware.controllerRed,
          ];

          final Database database = Database(
            games: [
              TestGames.gameOuterWilds,
              TestGames.gameDistance,
              TestGames.gameSsx3,
              TestGames.gameOriAndTheBlindForest,
            ],
            hardware: hardware,
          );

          expect(database.games, [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ]);
          expect(database.hardware, hardware);

          final result = database.removeGame(TestGames.gameDistance.id);

          expect(result.games, [
            TestGames.gameOuterWilds,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ]);
          expect(database.hardware, hardware);
        });
        test('throws an exception if no game with the given id exists', () {
          final Database gamesList = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: [],
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
        test('correctly adds a new Game without modifying the hardware', () {
          final List<VideoGameHardware> hardware = [
            TestHardware.console,
            TestHardware.controllerRed,
          ];

          final Database gamesList = Database(
            games: [
              TestGames.gameOuterWilds,
              TestGames.gameDistance,
              TestGames.gameSsx3,
            ],
            hardware: hardware,
          );

          expect(gamesList.games, [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
          ]);
          expect(gamesList.hardware, hardware);

          final result = gamesList.addGame(TestGames.gameOriAndTheBlindForest);

          expect(result.games, [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ]);
          expect(gamesList.hardware, hardware);
        });
        test(
            "throws an exception if a game with the new game's id already exists",
            () {
          final Database gamesList = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: [],
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
    });
    group("Hardware manipulation", () {
      group("updateHardware", () {
        test("correctly updates hardware without modifying games", () {
          final gamesList = [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ];

          final Database database = Database(
            games: gamesList,
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          final VideoGameHardware updatedHardware =
              TestHardware.console.copyWith(price: 999.5);

          expect(database.games, gamesList);
          expect(
            database.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          final result = database.updateHardware(
            updatedHardware,
            GamePlatform.playStation5,
          );

          expect(result.games, gamesList);
          expect(
            result.hardware,
            [
              updatedHardware,
              TestHardware.controllerRed,
            ],
          );
        });
        test("throws an exception if no hardware with the update id exists",
            () {
          final Database database = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          try {
            database.updateHardware(
              TestHardware.controllerBlue,
              GamePlatform.playStation5,
            );
          } catch (error) {
            return;
          }
          fail('No exception thrown');
        });
      });
      group("removeHardware", () {
        test("correctly removes existing Hardware without modifying games", () {
          final gamesList = [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ];

          final Database database = Database(
            games: gamesList,
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          expect(database.games, gamesList);
          expect(
            database.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          final result = database.removeHardware(
            TestHardware.console.id,
            GamePlatform.playStation5,
          );

          expect(result.games, gamesList);
          expect(
            result.hardware,
            [
              TestHardware.controllerRed,
            ],
          );
        });
        test("throws an exception if no hardware with the remove id exists",
            () {
          final Database database = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          try {
            database.removeHardware(
              TestHardware.controllerBlue.id,
              GamePlatform.playStation5,
            );
          } catch (error) {
            return;
          }
          fail('No exception thrown');
        });
      });
      group("addHardware", () {
        test(
            "correctly adds new Hardware to an existing platform without modifying games",
            () {
          final gamesList = [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ];

          final Database database = Database(
            games: gamesList,
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          expect(database.games, gamesList);
          expect(
            database.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          final result = database.addHardware(
            TestHardware.controllerBlue,
          );

          expect(result.games, gamesList);
          expect(
            result.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
              TestHardware.controllerBlue,
            ],
          );
        });
        test(
            "correctly adds new Hardware to an non-existing platform without modifying games",
            () {
          final gamesList = [
            TestGames.gameOuterWilds,
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ];

          final Database database = Database(
            games: gamesList,
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          expect(database.games, gamesList);
          expect(
            database.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          final result = database.addHardware(
            TestHardware.controllerBlue
                .copyWith(platform: GamePlatform.nintendoSwitch),
          );

          expect(result.games, gamesList);
          expect(
            result.hardware,
            [
              TestHardware.console,
              TestHardware.controllerRed,
              TestHardware.controllerBlue
                  .copyWith(platform: GamePlatform.nintendoSwitch),
            ],
          );
        });
        test("throws an exception if hardware with the add id exists", () {
          final Database database = Database(
            games: [
              TestGames.gameOuterWilds,
            ],
            hardware: [
              TestHardware.console,
              TestHardware.controllerRed,
            ],
          );

          try {
            database.addHardware(
              TestHardware.console,
            );
          } catch (error) {
            return;
          }
          fail('No exception thrown');
        });
      });
    });
    group("updateDatabaseByLastModified", () {
      test("correctly updates older games only", () {
        final Database original = Database(
          games: [
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ],
          hardware: [
            TestHardware.console,
            TestHardware.controllerRed,
          ],
        );

        final Game updatedDistance = TestGames.gameDistance.copyWith(
          usk: USK.usk18,
          lastModified: DateTime(2024, 9, 12),
        );
        final Game updatedOri = TestGames.gameOriAndTheBlindForest.copyWith(
          price: 999.95,
          lastModified: DateTime(2022),
        );

        final VideoGameHardware updatedConsole = TestHardware.console.copyWith(
          price: 360.0,
          lastModified: DateTime(2024, 4, 20),
        );
        final VideoGameHardware updatedControllerRed =
            TestHardware.controllerRed.copyWith(
          price: 999.0,
          lastModified: DateTime(2022),
        );

        final Database update = Database(
          games: [
            updatedOri,
            updatedDistance,
          ],
          hardware: [
            updatedConsole,
            updatedControllerRed,
          ],
        );

        final Database result = original.updateDatabaseByLastModified(update);

        expect(result.games, [
          updatedDistance,
          TestGames.gameSsx3,
          // the update-game is older, so this should not have been updated
          TestGames.gameOriAndTheBlindForest,
        ]);
        expect(
          result.hardware,
          [
            updatedConsole,
            TestHardware.controllerRed,
          ],
        );
      });
    });
    group("addMissingDatabaseEntries", () {
      test("correctly adds missing games only", () {
        final Database original = Database(
          games: [
            TestGames.gameDistance,
            TestGames.gameSsx3,
            TestGames.gameOriAndTheBlindForest,
          ],
          hardware: [
            TestHardware.console,
            TestHardware.controllerBlue,
            TestHardware.controllerRed,
          ],
        );

        final Database update = Database(
          games: [
            TestGames.gameOuterWilds,
            TestGames.gameSsx3,
          ],
          hardware: [
            TestHardware.console,
            TestHardware.giftedConsole,
          ],
        );

        final Database result = original.addMissingDatabaseEntries(update);

        expect(result.games, [
          TestGames.gameDistance,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
          TestGames.gameOuterWilds,
        ]);
        expect(
          result.hardware,
          [
            TestHardware.console,
            TestHardware.controllerBlue,
            TestHardware.controllerRed,
            TestHardware.giftedConsole,
          ],
        );
      });
    });
  });
}
