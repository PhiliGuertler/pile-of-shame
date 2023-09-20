import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

void main() {
  group("EditableDLC", () {
    test(
        "Converting a DLC to Editable and back changes nothing except lastModified",
        () {
      final DLC testDLC = DLC(
        id: "test-dlc",
        name: "Test DLC",
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 9, 20),
        isFavorite: true,
        notes: "DLC Notes",
        price: 99.59,
      );

      final EditableDLC edit = EditableDLC.fromDLC(testDLC);

      final DLC result = edit.toDLC();

      expect(result.lastModified.compareTo(testDLC.lastModified) > 0, true);
      expect(result.copyWith(lastModified: testDLC.lastModified), testDLC);
    });
    test("Name and notes are trimmed correctly when converting back", () {
      EditableDLC edit = const EditableDLC();

      edit = edit.copyWith(name: "    Spaced DLC Name    ");
      edit = edit.copyWith(notes: "    This should be trimmed    ");

      final DLC result = edit.toDLC();

      expect(result.name, "Spaced DLC Name");
      expect(result.notes, "This should be trimmed");
    });
  });
  group("EditableGame", () {
    test(
        "Converting a Game to Editable and back changes nothing except lastModified",
        () {
      final Game testGame = Game(
        id: "test-game",
        name: "Test Game",
        platform: GamePlatform.gameCube,
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 9, 20),
        isFavorite: true,
        notes: "DLC Notes",
        price: 99.59,
        dlcs: [
          DLC(
            id: "test-dlc",
            name: "Test DLC",
            status: PlayStatus.completed100Percent,
            lastModified: DateTime(2023, 9, 19),
            isFavorite: true,
            notes: "DLC Notes",
            price: 16.40,
          ),
        ],
        usk: USK.usk16,
      );

      final EditableGame edit = EditableGame.fromGame(testGame);

      final Game result = edit.toGame();

      expect(result.lastModified.compareTo(testGame.lastModified) > 0, true);
      expect(result.copyWith(lastModified: testGame.lastModified), testGame);
    });
    test("Name and notes are trimmed correctly when converting back", () {
      EditableGame edit = const EditableGame();

      edit = edit.copyWith(platform: GamePlatform.gameCube);
      edit = edit.copyWith(name: "    Spaced DLC Name    ");
      edit = edit.copyWith(notes: "    This should be trimmed    ");

      final Game result = edit.toGame();

      expect(result.name, "Spaced DLC Name");
      expect(result.notes, "This should be trimmed");
    });
  });
}
