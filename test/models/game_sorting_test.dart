import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';

import '../test_utils/test_utils.dart';

void main() {
  final Game a = Game(
    id: "a",
    name: "aaaa",
    platform: GamePlatform.nintendo3DS,
    status: PlayStatus.onPileOfShame,
    lastModified: DateTime(2023, 9, 12),
    createdAt: DateTime(2022, 7, 10),
    price: 15,
    usk: USK.usk12,
    isFavorite: true,
    dlcs: [
      DLC(
        id: "a-dlc",
        name: "a-dlc",
        status: PlayStatus.completed,
        lastModified: DateTime(2023, 9, 12),
        createdAt: DateTime(2022, 7, 10),
        price: 25,
      ),
    ],
  );
  final Game b = Game(
    id: "b",
    name: "bbbb",
    platform: GamePlatform.epicGames,
    status: PlayStatus.playing,
    lastModified: DateTime(2023, 9, 11),
    createdAt: DateTime(2022, 7, 10),
    price: 19,
    usk: USK.usk6,
    notes: "These are some notes",
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
      // 15 + 25 > 19
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
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
  group("GameSorterByBasePrice", () {
    const sorter = GameSorterByBasePrice();
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
  group("GameSorterByBasePrice", () {
    const sorter = GameSorterByTotalDLCPrice();
    test("compares two games ascending correctly", () {
      // 25 > 0
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same price", () {
      final result1 = sorter.compareGames(
        a.copyWith(name: 'bbbb'),
        a.copyWith(),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(),
        a.copyWith(name: 'bbbb'),
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
  group("GameSorterByFavorites", () {
    const sorter = GameSorterByFavorites();

    test("compares two games ascending correctly", () {
      // isFavorite < !isFavorite
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), true);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), false);
    });
    test("sorts by name if both games have the same lastModified date", () {
      final result1 = sorter.compareGames(
        a.copyWith(isFavorite: true, name: 'bbbb'),
        a.copyWith(isFavorite: true),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(isFavorite: true),
        a.copyWith(isFavorite: true, name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByHasNotes", () {
    const sorter = GameSorterByHasNotes();

    test("compares two games ascending correctly", () {
      // null > "These are some notes"
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same lastModified date", () {
      final result1 = sorter.compareGames(
        a.copyWith(notes: "true", name: 'bbbb'),
        a.copyWith(notes: "true"),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(notes: "true"),
        a.copyWith(notes: "true", name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });
  group("GameSorterByDLCCount", () {
    const sorter = GameSorterByDLCCount();

    test("compares two games ascending correctly", () {
      // 1 > 0
      final result = sorter.compareGames(a, b, true);
      expect(isABeforeB(result), false);
    });
    test("compares two games descending correctly", () {
      final result = sorter.compareGames(a, b, false);
      expect(isABeforeB(result), true);
    });
    test("sorts by name if both games have the same lastModified date", () {
      final result1 = sorter.compareGames(
        a.copyWith(name: 'bbbb'),
        a.copyWith(),
        true,
      );
      expect(isABeforeB(result1), false);
      final result2 = sorter.compareGames(
        a.copyWith(),
        a.copyWith(name: 'bbbb'),
        true,
      );
      expect(isABeforeB(result2), true);
    });
  });

  group("SortStrategy", () {
    group("byName", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(SortStrategy.byName.toLocaleString(context), "nach Name");
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(SortStrategy.byName.toLocaleString(context), "by name");
        },
      );
    });
    group("byPlayStatus", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(
            SortStrategy.byPlayStatus.toLocaleString(context),
            "nach Status",
          );
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(
            SortStrategy.byPlayStatus.toLocaleString(context),
            "by status",
          );
        },
      );
    });
    group("byPrice", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(SortStrategy.byPrice.toLocaleString(context), "nach Preis");
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(SortStrategy.byPrice.toLocaleString(context), "by price");
        },
      );
    });
    group("byAgeRating", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(
            SortStrategy.byAgeRating.toLocaleString(context),
            "nach Altersfreigabe",
          );
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(
            SortStrategy.byAgeRating.toLocaleString(context),
            "by age rating",
          );
        },
      );
    });
    group("byPlatform", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(
            SortStrategy.byPlatform.toLocaleString(context),
            "nach Plattform",
          );
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(
            SortStrategy.byPlatform.toLocaleString(context),
            "by platform",
          );
        },
      );
    });
    group("byLastModified", () {
      testWidgets(
        "returns correct localeString for 'de'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "de");

          expect(
            SortStrategy.byLastModified.toLocaleString(context),
            "nach Änderungsdatum",
          );
        },
      );
      testWidgets(
        "returns correct localeString for 'en'",
        (widgetTester) async {
          final BuildContext context =
              await TestUtils.setupBuildContextForLocale(widgetTester, "en");

          expect(
            SortStrategy.byLastModified.toLocaleString(context),
            "by modification date",
          );
        },
      );
    });
  });

  group("GameSorting", () {
    test("toJson is readable", () {
      const GameSorting sorting = GameSorting(
        sortStrategy: SortStrategy.byLastModified,
      );
      final String json = jsonEncode(sorting.toJson());

      expect(json, '{"isAscending":true,"sortStrategy":"byLastModified"}');
    });
    test("fromJson works as expected", () {
      const String jsonString =
          '{"isAscending":true,"sortStrategy":"byLastModified"}';

      final GameSorting sorting =
          GameSorting.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);

      expect(sorting.isAscending, true);
      expect(sorting.sortStrategy, SortStrategy.byLastModified);
    });
  });
}
