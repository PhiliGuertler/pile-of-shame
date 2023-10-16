import 'package:flutter_test/flutter_test.dart';

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
}
