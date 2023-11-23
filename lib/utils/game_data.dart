import 'package:intl/intl.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_variant_dropdown.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class GameData {
  final List<Game> games;
  final AppLocalizations l10n;
  final NumberFormat currencyFormatter;

  const GameData({
    required this.games,
    required this.l10n,
    required this.currencyFormatter,
  });

  bool get hasData => games.isNotEmpty;

  Iterable<Game> get _nonWishlistGames =>
      games.where((element) => element.status != PlayStatus.onWishList);

  int get relevantGamesCount => _nonWishlistGames.length;
  bool get hasNonWishlistedGames => relevantGamesCount > 0;

  List<ChartData> toCompletedData() {
    final relevantGames = _nonWishlistGames;

    final completedGamesCount = relevantGames.fold(
      0,
      (previousValue, element) =>
          element.status.isCompleted ? previousValue + 1 : previousValue,
    );
    return [
      if (completedGamesCount > 0)
        ChartData(
          title: l10n.completed,
          value: completedGamesCount.toDouble(),
          color: PlayStatus.completed.backgroundColor,
          alternativeTitle: const PlayStatusIcon(
            playStatus: PlayStatus.completed,
          ),
        ),
      if (completedGamesCount < relevantGames.length)
        ChartData(
          title: l10n.incomplete,
          value: (relevantGames.length - completedGamesCount).toDouble(),
          color: PlayStatus.cancelled.backgroundColor,
          alternativeTitle: const PlayStatusIcon(
            playStatus: PlayStatus.cancelled,
          ),
        ),
    ];
  }

  List<ChartData> toPlayStatusData() {
    final relevantGames = games;

    final List<Pair<PlayStatus, int>> statusCount = [
      for (var i = 0; i < PlayStatus.values.length; ++i)
        Pair(PlayStatus.values[i], 0),
    ];

    for (final game in relevantGames) {
      statusCount[game.status.index].second++;
    }

    // sort completed and not completed together
    statusCount.sort(
      (a, b) => a.first.isCompleted == b.first.isCompleted
          ? 0
          : a.first.isCompleted
              ? -1
              : 1,
    );

    final List<ChartData> result = [];
    for (var i = 0; i < PlayStatus.values.length; ++i) {
      final status = statusCount[i].first;
      final count = statusCount[i].second;
      result.add(
        ChartData(
          title: status.toLocaleString(l10n),
          value: count.toDouble(),
          color: status.backgroundColor,
          alternativeTitle: PlayStatusIcon(
            playStatus: status,
          ),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }

  List<ChartData> toPriceVariantData() {
    final List<Pair<PriceVariant, int>> priceVariantCount = [
      for (var i = 0; i < PriceVariant.values.length; ++i)
        Pair(PriceVariant.values[i], 0),
    ];

    for (final game in games) {
      priceVariantCount[game.priceVariant.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < PriceVariant.values.length; ++i) {
      final priceVariant = priceVariantCount[i].first;
      final count = priceVariantCount[i].second;
      result.add(
        ChartData(
          title: priceVariant.toLocaleString(l10n),
          value: count.toDouble(),
          color: priceVariant.backgroundColor,
          alternativeTitle: PriceVariantIcon(
            priceVariant: priceVariant,
          ),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }

  List<ChartData> toAgeRatingData() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<USK, int>> ageRatings = [
      for (var i = 0; i < USK.values.length; ++i) Pair(USK.values[i], 0),
    ];

    for (final game in relevantGames) {
      ageRatings[game.usk.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < USK.values.length; ++i) {
      final usk = ageRatings[i].first;
      final count = ageRatings[i].second;
      result.add(
        ChartData(
          title: usk.toRatedString(l10n),
          value: count.toDouble(),
          secondaryValue: usk.age.toDouble(),
          color: usk.toBackgroundColor(),
          alternativeTitle: USKLogo(
            ageRestriction: usk,
          ),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }

  List<ChartData> toPriceDistribution(double interval) {
    assert(interval > 0.0);

    final relevantGames = _nonWishlistGames;

    final List<Pair<double, int>> priceDistribution = [];

    int processedGames = 0;
    double priceCap = 0.001;

    while (processedGames < relevantGames.length) {
      int matchingGames = relevantGames.fold(
        0,
        (previousValue, element) =>
            element.fullPrice() < priceCap ? previousValue + 1 : previousValue,
      );
      matchingGames -= processedGames;
      priceDistribution.add(Pair(priceCap, matchingGames));

      processedGames += matchingGames;
      priceCap += interval;
    }

    return priceDistribution.map((e) {
      String title = "";
      final previousInterval = e.first - interval + 0.01;
      if (previousInterval >= 0) {
        title = "${currencyFormatter.format(previousInterval)} - ";
      }
      title = "$title${currencyFormatter.format(e.first)}";

      return ChartData(
        title: title,
        value: e.second.toDouble(),
        secondaryValue: e.first,
      );
    }).toList();
  }

  List<ChartData> toPlatformDistribution() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<GamePlatform, int>> platformCounts = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];
    for (final game in relevantGames) {
      platformCounts[game.platform.index].second++;
    }

    platformCounts.sort(
      (a, b) => b.second.compareTo(a.second) == 0
          ? a.first.index.compareTo(b.first.index)
          : b.second.compareTo(a.second),
    );

    final List<ChartData> result = [];
    for (var i = 0; i < GamePlatform.values.length; ++i) {
      final platform = platformCounts[i].first;
      final count = platformCounts[i].second;
      result.add(
        ChartData(
          title: platform.localizedAbbreviation(l10n),
          value: count.toDouble(),
        ),
      );
    }

    result.removeWhere((element) => element.value < 0.01);

    return result;
  }

  List<ChartData> toPlatformPriceDistribution() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<GamePlatform, double>> platformPrices = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    final List<Pair<GamePlatform, int>> platformCount = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    for (final game in relevantGames) {
      platformPrices[game.platform.index].second += game.fullPrice();
      platformCount[game.platform.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < GamePlatform.values.length; ++i) {
      final platform = platformPrices[i].first;
      final price = platformPrices[i].second;
      final count = platformCount[i].second;
      if (count > 0) {
        result.add(
          ChartData(
            title: platform.localizedAbbreviation(l10n),
            value: price,
          ),
        );
      }
    }

    result.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return result;
  }

  List<ChartData> toPlatformFamilyPriceDistribution() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<GamePlatformFamily, double>> platformFamilyPrices = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    final List<Pair<GamePlatformFamily, int>> platformFamilyCount = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    for (final game in relevantGames) {
      platformFamilyPrices[game.platform.family.index].second +=
          game.fullPrice();
      platformFamilyCount[game.platform.family.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < GamePlatformFamily.values.length; ++i) {
      final family = platformFamilyPrices[i].first;
      final price = platformFamilyPrices[i].second;
      final count = platformFamilyCount[i].second;
      if (count > 0) {
        result.add(
          ChartData(
            title: family.toLocale(l10n),
            value: price,
          ),
        );
      }
    }

    result.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return result;
  }

  int toGameCount() {
    final relevantGames = _nonWishlistGames;

    return relevantGames.length;
  }

  int toDLCCount() {
    final relevantGames = _nonWishlistGames;

    return relevantGames.fold(
      0,
      (previousValue, element) =>
          element.dlcs
              .where((element) => element.status != PlayStatus.onWishList)
              .length +
          previousValue,
    );
  }

  double toTotalPrice() {
    final relevantGames = _nonWishlistGames;

    return relevantGames.fold(
      0.0,
      (previousValue, element) =>
          element.fullPriceNonWishlist() + previousValue,
    );
  }

  double toTotalBasePrice() {
    final relevantGames = _nonWishlistGames;

    return relevantGames.fold(
      0.0,
      (previousValue, element) => element.price + previousValue,
    );
  }

  double toTotalDLCPrice() {
    final relevantGames = _nonWishlistGames;

    return relevantGames.fold(
      0.0,
      (previousValue, element) =>
          element.dlcs.fold(
            0.0,
            (previousValue, element) =>
                (element.status != PlayStatus.onWishList
                    ? element.price
                    : 0.0) +
                previousValue,
          ) +
          previousValue,
    );
  }

  double toAveragePrice() {
    final relevantGames = _nonWishlistGames;

    if (relevantGames.isEmpty) return 0.0;

    return toTotalPrice() / toGameCount();
  }

  double toMedianPrice() {
    final relevantGames = _nonWishlistGames;

    if (relevantGames.isEmpty) return 0.0;

    final List<Game> sortedGames = List.from(games);
    sortedGames.sort((a, b) => a.fullPrice().compareTo(b.fullPrice()));

    return sortedGames[sortedGames.length ~/ 2].fullPrice();
  }

  double toAverageAgeRating() {
    final relevantGames = _nonWishlistGames;

    if (relevantGames.isEmpty) return 0.0;

    final ageRatings = toAgeRatingData();
    final totalData = ageRatings.fold(
      0.0,
      (previousValue, element) => element.value + previousValue,
    );

    // compute the sum of all age ratings
    final ageRatingSum = ageRatings.fold(
      0.0,
      (previousValue, element) =>
          element.value * element.secondaryValue! + previousValue,
    );

    return ageRatingSum / totalData;
  }

  double toCompletedPercentage() {
    final completedData = toCompletedData();

    final totalData = completedData.fold(
      0.0,
      (previousValue, element) => element.value + previousValue,
    );

    try {
      final completed = completedData
          .firstWhere((element) => element.title == l10n.completed);
      return completed.value / totalData;
    } catch (error) {
      // ignore error
    }
    return 0.0;
  }
}
