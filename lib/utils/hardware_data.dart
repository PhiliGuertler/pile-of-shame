import 'package:intl/intl.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';

class HardwareData {
  final List<VideoGameHardware> hardware;
  final AppLocalizations l10n;
  final NumberFormat currencyFormatter;

  const HardwareData({
    required this.hardware,
    required this.l10n,
    required this.currencyFormatter,
  });

  bool get hasData => hardware.isNotEmpty;

  double toTotalPrice() {
    return hardware.fold(
      0.0,
      (previousValue, element) => element.price + previousValue,
    );
  }

  int toCount() {
    return hardware.length;
  }

  double toAveragePrice() {
    if (hardware.isEmpty) return 0.0;

    return toTotalPrice() / toCount();
  }

  double toMedianPrice() {
    if (hardware.isEmpty) return 0.0;

    final List<VideoGameHardware> sortedHardware = List.from(hardware);
    sortedHardware.sort((a, b) => a.price.compareTo(b.price));

    return sortedHardware[sortedHardware.length ~/ 2].price;
  }

  List<ChartData> toPlatformFamilyPriceDistribution() {
    final List<Pair<GamePlatformFamily, double>> platformFamilyPrices = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    final List<Pair<GamePlatformFamily, int>> platformFamilyCount = [
      for (var i = 0; i < GamePlatformFamily.values.length; ++i)
        Pair(GamePlatformFamily.values[i], 0),
    ];

    for (final ware in hardware) {
      platformFamilyPrices[ware.platform.family.index].second += ware.price;
      platformFamilyCount[ware.platform.family.index].second++;
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

  List<ChartData> toPlatformPriceDistribution() {
    final List<Pair<GamePlatform, double>> platformPrices = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    final List<Pair<GamePlatform, int>> platformCount = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];

    for (final ware in hardware) {
      platformPrices[ware.platform.index].second += ware.price;
      platformCount[ware.platform.index].second++;
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

  List<ChartData> toPlatformDistribution() {
    final List<Pair<GamePlatform, int>> platformCounts = [
      for (var i = 0; i < GamePlatform.values.length; ++i)
        Pair(GamePlatform.values[i], 0),
    ];
    for (final ware in hardware) {
      platformCounts[ware.platform.index].second++;
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

  List<ChartData> toPriceDistribution(double interval) {
    assert(interval > 0.0);

    final List<Pair<double, int>> priceDistribution = [];

    int processedHardware = 0;
    double priceCap = 0.001;

    while (processedHardware < hardware.length) {
      int matchingHardware = hardware.fold(
        0,
        (previousValue, element) =>
            element.price < priceCap ? previousValue + 1 : previousValue,
      );
      matchingHardware -= processedHardware;
      priceDistribution.add(Pair(priceCap, matchingHardware));

      processedHardware += matchingHardware;
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
}
