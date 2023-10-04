import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

import '../../../../../test_resources/test_games.dart';

void main() {
  group("EditableDLC", () {
    test(
        "Converting a DLC to Editable and back changes nothing except lastModified",
        () {
      final EditableDLC edit =
          EditableDLC.fromDLC(TestGames.dlcWitcher3BloodAndWine);

      final DLC result = edit.toDLC();

      expect(
        result.lastModified
                .compareTo(TestGames.dlcWitcher3BloodAndWine.lastModified) >
            0,
        true,
      );
      expect(
        result.copyWith(
          lastModified: TestGames.dlcWitcher3BloodAndWine.lastModified,
        ),
        TestGames.dlcWitcher3BloodAndWine,
      );
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
      final EditableGame edit = EditableGame.fromGame(TestGames.gameWitcher3);

      final Game result = edit.toGame();

      expect(
        result.lastModified.compareTo(TestGames.gameWitcher3.lastModified) > 0,
        true,
      );
      expect(
        result.copyWith(lastModified: TestGames.gameWitcher3.lastModified),
        TestGames.gameWitcher3,
      );
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
