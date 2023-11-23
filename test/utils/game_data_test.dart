import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations_de.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/utils/game_data.dart';

import '../../test_resources/test_games.dart';

void main() {
  final AppLocalizations l10n = AppLocalizationsDe();
  final NumberFormat currencyFormatter =
      NumberFormat.currency(decimalDigits: 2, symbol: '€', locale: 'de-DE');

  group("toCompletedData", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toCompletedData();
      expect(result, []);
    });
    test("returns a ratio of completed to non completed games as expected", () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // replaying -> completed
          TestGames.gameOuterWilds, // completed -> completed
          TestGames.gameWitcher3, // completed -> completed
          TestGames.gameDistance, // playing -> incomplete
          TestGames.gameSsx3, // completed100Percent -> completed
          TestGames.gameOriAndTheBlindForest, // onPileOfShame -> incomplete
          TestGames.gameInscryption, // onWishList -> ignored
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toCompletedData();

      expect(result.length, 2);
      expect(result[0].title, l10n.completed);
      expect(result[0].value, 4.0);

      expect(result[1].title, l10n.incomplete);
      expect(result[1].value, 2.0);
    });
  });
  group("toPlayStatusData", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toPlayStatusData();
      expect(result, []);
    });
    test("returns a sorted list of game-count by play-status as expected", () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // replaying
          TestGames.gameOuterWilds, // completed
          TestGames.gameWitcher3, // completed
          TestGames.gameDistance, // playing
          TestGames.gameSsx3, // completed100Percent
          TestGames.gameOriAndTheBlindForest, // onPileOfShame
          TestGames.gameInscryption, // onWishlist
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toPlayStatusData();

      expect(result.length, 6);
      int index = 0;
      // First, the completed games ordered by their play-status index
      expect(result[index].title, l10n.replaying);
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, l10n.completed);
      expect(result[index].value, 2.0);
      ++index;

      expect(result[index].title, l10n.completed100Percent);
      expect(result[index].value, 1.0);
      ++index;

      // Second, the incomplete games ordered by their play-status index
      expect(result[index].title, l10n.playing);
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, l10n.onPileOfShame);
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, l10n.onWishList);
      expect(result[index].value, 1.0);
    });
  });
  group("toAgeRatingData", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toAgeRatingData();
      expect(result, []);
    });
    test(
        "returns a sorted list of game-count by age-rating as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // usk16
          TestGames.gameOuterWilds, // usk12
          TestGames.gameWitcher3, // usk18
          TestGames.gameSsx3, // usk6
          TestGames.gameOriAndTheBlindForest, // usk12
          TestGames.gameInscryption, // usk16 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toAgeRatingData();

      expect(result.length, 4);
      int index = 0;
      expect(result[index].title, l10n.ratedN("6"));
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, l10n.ratedN("12"));
      expect(result[index].value, 2.0);
      ++index;

      expect(result[index].title, l10n.ratedN("16"));
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, l10n.ratedN("18"));
      expect(result[index].value, 1.0);
    });
  });
  group("toPriceDistribution", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toPriceDistribution(10.0);
      expect(result, []);
    });
    test(
        "returns a distribution of the total prices as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 39.99+9.99 = 49.98
          TestGames.gameOuterWilds, // 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // 19.99
          TestGames.gameSsx3, // 39.95
          TestGames.gameOriAndTheBlindForest, // 25
          TestGames.gameInscryption, // 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toPriceDistribution(10.0);

      expect(result.length, 10);
      int index = 0;
      expect(result[index].title, currencyFormatter.format(0));
      expect(result[index].value, 0.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(0.01)} - ${currencyFormatter.format(10.0)}",
      );
      expect(result[index].value, 0.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(10.01)} - ${currencyFormatter.format(20.0)}",
      );
      expect(result[index].value, 1.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(20.01)} - ${currencyFormatter.format(30.0)}",
      );
      expect(result[index].value, 1.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(30.01)} - ${currencyFormatter.format(40.0)}",
      );
      expect(result[index].value, 1.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(40.01)} - ${currencyFormatter.format(50.0)}",
      );
      expect(result[index].value, 2.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(50.01)} - ${currencyFormatter.format(60.0)}",
      );
      expect(result[index].value, 0.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(60.01)} - ${currencyFormatter.format(70.0)}",
      );
      expect(result[index].value, 0.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(70.01)} - ${currencyFormatter.format(80.0)}",
      );
      expect(result[index].value, 0.0);
      ++index;

      expect(
        result[index].title,
        "${currencyFormatter.format(80.01)} - ${currencyFormatter.format(90.0)}",
      );
      expect(result[index].value, 1.0);
      ++index;
    });
  });
  group("toPlatformDistribution", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toPlatformDistribution();
      expect(result, []);
    });
    test(
        "returns a distribution of the platforms as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // playstation4
          TestGames.gameOuterWilds, // steam
          TestGames.gameWitcher3, // gog
          TestGames.gameDistance, // steam
          TestGames.gameSsx3, // playstation2
          TestGames.gameOriAndTheBlindForest, // playstation4
          TestGames.gameInscryption, // steam (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toPlatformDistribution();

      expect(result.length, 4);
      int index = 0;
      // if the number of elements is the same, the entries are ordered by GamePlatform-index
      expect(
        result[index].title,
        GamePlatform.playStation4.localizedAbbreviation(l10n),
      );
      expect(result[index].value, 2.0);
      ++index;

      expect(
        result[index].title,
        GamePlatform.steam.localizedAbbreviation(l10n),
      );
      expect(result[index].value, 2.0);
      ++index;

      expect(
        result[index].title,
        GamePlatform.playStation2.localizedAbbreviation(l10n),
      );
      expect(result[index].value, 1.0);
      ++index;

      expect(result[index].title, GamePlatform.gog.localizedAbbreviation(l10n));
      expect(result[index].value, 1.0);
      ++index;
    });
  });
  group("toPlatformPriceDistribution", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toPlatformPriceDistribution();
      expect(result, []);
    });
    test(
        "returns a the prices of the platforms as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // playstation4, 39.99+9.99 = 49.98
          TestGames.gameOuterWilds, // steam, 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // gog, 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // steam, 19.99
          TestGames.gameSsx3, // playstation2, 39.95
          TestGames.gameOriAndTheBlindForest, // playstation4, 25
          TestGames.gameInscryption, // steam, 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toPlatformPriceDistribution();

      expect(result.length, 4);
      int index = 0;

      expect(
        result[index].title,
        GamePlatform.gog.localizedAbbreviation(l10n),
      );
      expect(
        (result[index].value - (59.99 + 19.99 + 9.99)).abs() < 0.001,
        true,
      );
      ++index;

      expect(
        result[index].title,
        GamePlatform.playStation4.localizedAbbreviation(l10n),
      );
      expect((result[index].value - (39.99 + 9.99 + 25)).abs() < 0.001, true);
      ++index;

      expect(
        result[index].title,
        GamePlatform.steam.localizedAbbreviation(l10n),
      );
      expect(
        (result[index].value - (24.99 + 19.99 + 19.99)).abs() < 0.001,
        true,
      );
      ++index;

      expect(
        result[index].title,
        GamePlatform.playStation2.localizedAbbreviation(l10n),
      );
      expect((result[index].value - (39.95)).abs() < 0.001, true);
      ++index;
    });
  });
  group("toPlatformFamilyPriceDistribution", () {
    test("returns an empty list if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toPlatformFamilyPriceDistribution();
      expect(result, []);
    });
    test("returns a the prices of the platforms as expected", () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // sony, 39.99+9.99 = 49.98
          TestGames.gameOuterWilds, // pc, 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // pc, 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // pc, 19.99
          TestGames.gameSsx3, // sony, 39.95
          TestGames.gameOriAndTheBlindForest.copyWith(
            platform: GamePlatform.xboxOne,
            price: 0.0,
          ), // microsoft, 0
          TestGames.gameInscryption
              .copyWith(platform: GamePlatform.pcMisc), // pc, 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toPlatformFamilyPriceDistribution();

      expect(result.length, 3);
      int index = 0;

      expect(
        result[index].title,
        GamePlatformFamily.pc.toLocale(l10n),
      );
      expect(
        (result[index].value - (59.99 + 19.99 + 9.99 + 19.99 + 24.99 + 19.99))
                .abs() <
            0.001,
        true,
      );
      ++index;

      expect(
        result[index].title,
        GamePlatformFamily.sony.toLocale(l10n),
      );
      expect(
        (result[index].value - (39.99 + 9.99 + 39.95)).abs() < 0.001,
        true,
      );
      ++index;

      expect(
        result[index].title,
        GamePlatformFamily.microsoft.toLocale(l10n),
      );
      expect(
        (result[index].value - (0.0)).abs() < 0.001,
        true,
      );
      ++index;
    });
  });
  group("toGameCount", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toGameCount();
      expect(result, 0);
    });
    test("returns the game count as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls,
          TestGames.gameOuterWilds,
          TestGames.gameWitcher3,
          TestGames.gameDistance,
          TestGames.gameSsx3,
          TestGames.gameOriAndTheBlindForest,
          TestGames.gameInscryption, // (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toGameCount();

      expect(result, 6);
    });
  });
  group("toDLCCount", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toDLCCount();
      expect(result, 0);
    });
    test("returns the game count as expected while ignoring wishlisted DLCs",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 1 DLC, wishlisted
          TestGames.gameOuterWilds, // 1 DLC
          TestGames.gameWitcher3, // 2 DLCs
          TestGames.gameDistance, // 0
          TestGames.gameSsx3, // 0
          TestGames.gameOriAndTheBlindForest, // 0
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toDLCCount();

      expect(result, 3);
    });
  });
  group("toTotalPrice", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toTotalPrice();
      expect(result, 0);
    });
    test(
        "returns the sum of total prices as expected while ignoring wishlisted dlcs and games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 39.99 (+9.99 wishlisted) = 39.99
          TestGames.gameOuterWilds, // 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // 19.99
          TestGames.gameSsx3, // 39.95
          TestGames.gameOriAndTheBlindForest, // 25
          TestGames.gameInscryption, // 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toTotalPrice();

      expect(
        (result -
                    (39.99 +
                        24.99 +
                        19.99 +
                        59.99 +
                        19.99 +
                        9.99 +
                        19.99 +
                        39.95 +
                        25))
                .abs() <
            0.001,
        true,
      );
    });
  });
  group("toTotalBasePrice", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toTotalBasePrice();
      expect(result, 0);
    });
    test(
        "returns the sum of total prices as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 39.99
          TestGames.gameOuterWilds, // 24.99
          TestGames.gameWitcher3, // 59.99
          TestGames.gameDistance, // 19.99
          TestGames.gameSsx3, // 39.95
          TestGames.gameOriAndTheBlindForest, // 25
          TestGames.gameInscryption, // 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toTotalBasePrice();

      expect(
        (result - (39.99 + 24.99 + 59.99 + 19.99 + 39.95 + 25)).abs() < 0.001,
        true,
      );
    });
  });
  group("toTotalDLCPrice", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toTotalDLCPrice();
      expect(result, 0);
    });
    test(
        "returns the sum of total prices as expected while ignoring wishlisted DLCs",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 9.99, wishlisted
          TestGames.gameOuterWilds, // 19.99
          TestGames.gameWitcher3, // 19.99 + 9.99
          TestGames.gameDistance, // 0
          TestGames.gameSsx3, // 0
          TestGames.gameOriAndTheBlindForest, // 0
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toTotalDLCPrice();

      expect(
        (result - (19.99 + 19.99 + 9.99)).abs() < 0.001,
        true,
      );
    });
  });
  group("toAveragePrice", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toAveragePrice();
      expect(result, 0);
    });
    test(
        "returns the average of the total prices as expected while ignoring wishlisted games and DLCs",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 39.99 (+9.99 wishlisted) = 39.99
          TestGames.gameOuterWilds, // 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // 19.99
          TestGames.gameSsx3, // 39.95
          TestGames.gameOriAndTheBlindForest, // 25
          TestGames.gameInscryption, // 20 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toAveragePrice();

      expect(
        (result -
                    (39.99 +
                            24.99 +
                            19.99 +
                            59.99 +
                            19.99 +
                            9.99 +
                            19.99 +
                            39.95 +
                            25) /
                        6.0)
                .abs() <
            0.001,
        true,
      );
    });
  });
  group("toMedianPrice", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toMedianPrice();
      expect(result, 0);
    });
    test(
        "returns the median of the total prices as expected while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // 39.99 (+9.99 wishlisted) = 39.99 (Median)
          TestGames.gameOuterWilds, // 24.99+19.99 = 44.98
          TestGames.gameWitcher3, // 59.99+19.99+9.99 = 89.97
          TestGames.gameDistance, // 19.99
          TestGames.gameSsx3, // 39.95
          TestGames.gameOriAndTheBlindForest, // 25
          TestGames.gameInscryption, // 20 (Wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toMedianPrice();

      expect(
        (result - 39.99).abs() < 0.001,
        true,
      );
    });
  });
  group("toAverageAgeRating", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toAverageAgeRating();
      expect(result, 0.0);
    });
    test(
        "returns the correct average of age ratings while ignoring wishlisted games",
        () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // usk16
          TestGames.gameOuterWilds, // usk12
          TestGames.gameWitcher3, // usk18
          TestGames.gameSsx3, // usk6
          TestGames.gameOriAndTheBlindForest, // usk12
          TestGames.gameInscryption, // usk16 (wishlisted)
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toAverageAgeRating();

      expect(result, (16 + 12 + 18 + 6 + 12) / 5);
    });
  });
  group("toCompletedPercentage", () {
    test("returns 0 if no games are passed", () {
      final GameData data =
          GameData(games: [], l10n: l10n, currencyFormatter: currencyFormatter);

      final result = data.toCompletedPercentage();
      expect(result, 0.0);
    });
    test("returns the correct percentage of completed games", () {
      final GameData data = GameData(
        games: [
          TestGames.gameDarkSouls, // replaying -> completed
          TestGames.gameOuterWilds, // completed -> completed
          TestGames.gameWitcher3, // completed -> completed
          TestGames.gameDistance, // playing -> incomplete
          TestGames.gameSsx3, // completed100Percent -> completed
          TestGames.gameOriAndTheBlindForest, // onPileOfShame -> incomplete
          TestGames.gameInscryption, // onWishlist -> ignored
        ],
        l10n: l10n,
        currencyFormatter: currencyFormatter,
      );

      final result = data.toCompletedPercentage();

      expect(result, 4 / 6);
    });
  });
}
