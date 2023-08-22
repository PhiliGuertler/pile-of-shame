import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

void main() {
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
          name: "DLC 1",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 8, 8),
          price: 9.99,
        ),
        DLC(
          name: "DLC 2",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 8, 8),
          price: 14.49,
        ),
      ],
    );
    expect(testGame.fullPrice(), 79.99 + 9.99 + 14.49);
  });
}
