import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';

void main() {
  final Game a = Game(
    id: "a",
    name: "aaaa",
    platform: GamePlatform.nintendo3DS,
    status: PlayStatus.onPileOfShame,
    lastModified: DateTime(2023, 9, 12),
    price: 15,
    usk: USK.usk12,
  );
  final Game b = Game(
    id: "b",
    name: "bbbb",
    platform: GamePlatform.epicGames,
    status: PlayStatus.playing,
    lastModified: DateTime(2023, 9, 11),
    price: 19,
    usk: USK.usk6,
  );

  bool isABeforeB(int comparison) {
    return comparison < 0;
  }

  group("GameSorterByName", () {
    const sorter = GameSorterByName();
    test("compares two games ascending correctly", () {
      // "aaaa" < "bbbb"
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), true);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), false);
    });
  });
  group("GameSorterByPlayStatus", () {
    const sorter = GameSorterByPlayStatus();
    test("compares two games ascending correctly", () {
      // onPileOfShame > playing
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same status", () {
      final result1 = sorter.compareGames(
        a.copyWith(status: PlayStatus.playing, name: 'bbbb'),
        a.copyWith(status: PlayStatus.playing),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(status: PlayStatus.playing),
        a.copyWith(status: PlayStatus.playing, name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByPrice", () {
    const sorter = GameSorterByPrice();
    test("compares two games ascending correctly", () {
      // 15 < 19
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), true);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), false);
    });
    test("sorts by name if both games have the same price", () {
      final result1 = sorter.compareGames(
        a.copyWith(price: 15, name: 'bbbb'),
        a.copyWith(price: 15),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(price: 15),
        a.copyWith(price: 15, name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByAgeRating", () {
    const sorter = GameSorterByAgeRating();
    test("compares two games ascending correctly", () {
      // usk12 > usk6
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same age rating", () {
      final result1 = sorter.compareGames(
        a.copyWith(usk: USK.usk12, name: 'bbbb'),
        a.copyWith(usk: USK.usk12),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(usk: USK.usk12),
        a.copyWith(usk: USK.usk12, name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByPlatform", () {
    const sorter = GameSorterByPlatform();

    test("compares two games ascending correctly", () {
      // nintendo3DS < epicGames
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), true);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), false);
    });
    test("sorts by name if both games have the same platform", () {
      final result1 = sorter.compareGames(
        a.copyWith(platform: GamePlatform.gameBoy, name: 'bbbb'),
        a.copyWith(platform: GamePlatform.gameBoy),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(platform: GamePlatform.gameBoy),
        a.copyWith(platform: GamePlatform.gameBoy, name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByLastModified", () {
    const sorter = GameSorterByLastModified();

    test("compares two games ascending correctly", () {
      // 2023-09-12 > 2023-09-11
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same lastModified date", () {
      final result1 = sorter.compareGames(
        a.copyWith(lastModified: DateTime(2023, 4, 4), name: 'bbbb'),
        a.copyWith(lastModified: DateTime(2023, 4, 4)),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(lastModified: DateTime(2023, 4, 4)),
        a.copyWith(lastModified: DateTime(2023, 4, 4), name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
}
