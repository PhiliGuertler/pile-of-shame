import 'package:intl/intl.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/play_status.dart';

class GameAndHardwareData {
  final List<Game> games;
  final List<VideoGameHardware> hardware;
  final AppLocalizations l10n;
  final NumberFormat currencyFormatter;

  const GameAndHardwareData({
    required this.games,
    required this.hardware,
    required this.l10n,
    required this.currencyFormatter,
  });

  Iterable<Game> get _nonWishlistGames =>
      games.where((element) => element.status != PlayStatus.onWishList);

  int get relevantGamesCount => _nonWishlistGames.length;
  bool get hasNonWishlistedGames => relevantGamesCount > 0;

  List<ChartData> toPlatformFamilyPriceDistribution() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<GamePlatformFamily, double>> platformFamilyHardwarePrices =
        [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    final List<Pair<GamePlatformFamily, double>> platformFamilyGamePrices = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    final List<Pair<GamePlatformFamily, int>> platformFamilyCount = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    for (final ware in hardware) {
      platformFamilyHardwarePrices[ware.platform.family.index].second +=
          ware.price;
      platformFamilyCount[ware.platform.family.index].second++;
    }

    for (final game in relevantGames) {
      platformFamilyGamePrices[game.platform.family.index].second +=
          game.fullPrice();
      platformFamilyCount[game.platform.family.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < GamePlatformFamily.values.length; ++i) {
      final family = GamePlatformFamily.values[i];
      final hardwarePrice = platformFamilyHardwarePrices[i].second;
      final gamePrice = platformFamilyGamePrices[i].second;
      final count = platformFamilyCount[i].second;
      if (count > 0) {
        result.add(
          ChartData(
            title: family.toLocale(l10n),
            value: gamePrice,
            secondaryValue: hardwarePrice,
          ),
        );
      }
    }

    result.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return result;
  }

  List<ChartData> toPlatformPriceDistribution() {
    final relevantGames = _nonWishlistGames;

    final List<Pair<GamePlatform, double>> platformHardwarePrices = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    final List<Pair<GamePlatform, double>> platformGamePrices = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    final List<Pair<GamePlatform, int>> platformCount = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    for (final ware in hardware) {
      platformHardwarePrices[ware.platform.index].second += ware.price;
      platformCount[ware.platform.index].second++;
    }

    for (final game in relevantGames) {
      platformGamePrices[game.platform.index].second += game.fullPrice();
      platformCount[game.platform.index].second++;
    }

    final List<ChartData> result = [];
    for (var i = 0; i < GamePlatform.values.length; ++i) {
      final platform = GamePlatform.values[i];
      final gamePrice = platformGamePrices[i].second;
      final hardwarePrice = platformHardwarePrices[i].second;
      final count = platformCount[i].second;
      if (count > 0) {
        result.add(
          ChartData(
            title: platform.localizedAbbreviation(l10n),
            value: gamePrice,
            secondaryValue: hardwarePrice,
          ),
        );
      }
    }

    result.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return result;
  }
}
