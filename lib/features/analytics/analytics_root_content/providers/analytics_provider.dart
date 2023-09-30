import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

@riverpod
FutureOr<List<ChartData>> createGameAmountDataByGrouper(
  CreateGameAmountDataByGrouperRef ref,
  GameGrouper grouper,
) async {
  final games = await ref.watch(gamesProvider.future);
  final l10n = ref.watch(l10nProvider);

  final groupValues = grouper.values();
  final Map<String, List<Game>> grouped = Map.fromEntries(
    groupValues.map(
      (e) => MapEntry(grouper.groupToLocaleString(l10n, e), []),
    ),
  );
  for (final game in games) {
    for (final group in groupValues) {
      if (grouper.matchesGroup(group, game)) {
        grouped[grouper.groupToLocaleString(l10n, group)]!.add(game);
      }
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);

  final List<ChartData> result = [];
  for (var i = 0; i < grouped.length; ++i) {
    final entry = grouped.entries.elementAt(i);
    result.add(
      ChartData(
        value: entry.value.length.toDouble(),
        title: entry.key,
      ),
    );
  }

  result.sort(
    (a, b) => a.value.compareTo(b.value),
  );

  return result;
}

@riverpod
FutureOr<List<ChartData>> createPriceDataByGrouper(
  CreatePriceDataByGrouperRef ref,
  GameGrouper grouper,
) async {
  final games = await ref.watch(gamesProvider.future);
  final l10n = ref.watch(l10nProvider);

  final groupValues = grouper.values();
  final Map<String, List<Game>> grouped = Map.fromEntries(
    groupValues.map(
      (e) => MapEntry(grouper.groupToLocaleString(l10n, e), []),
    ),
  );
  for (final game in games) {
    for (final group in groupValues) {
      if (grouper.matchesGroup(group, game)) {
        grouped[grouper.groupToLocaleString(l10n, group)]!.add(game);
      }
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);

  final List<ChartData> result = [];
  for (var i = 0; i < grouped.length; ++i) {
    final entry = grouped.entries.elementAt(i);
    final sum = entry.value.fold(
      0.0,
      (previousValue, element) => previousValue + element.fullPrice(),
    );
    if (sum > 0) {
      result.add(
        ChartData(
          value: sum,
          title: entry.key,
        ),
      );
    }
  }

  result.sort(
    (a, b) => a.value.compareTo(b.value),
  );

  return result;
}

@riverpod
FutureOr<List<ChartData>> createAveragePriceDataByGrouper(
  CreateAveragePriceDataByGrouperRef ref,
  GameGrouper grouper,
) async {
  final games = await ref.watch(gamesProvider.future);
  final l10n = ref.watch(l10nProvider);

  final groupValues = grouper.values();
  final Map<String, List<Game>> grouped = Map.fromEntries(
    groupValues.map(
      (e) => MapEntry(grouper.groupToLocaleString(l10n, e), []),
    ),
  );
  for (final game in games) {
    for (final group in groupValues) {
      if (grouper.matchesGroup(group, game)) {
        grouped[grouper.groupToLocaleString(l10n, group)]!.add(game);
      }
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);

  final List<ChartData> result = [];
  for (var i = 0; i < grouped.length; ++i) {
    final entry = grouped.entries.elementAt(i);
    final sum = entry.value.fold(
      0.0,
      (previousValue, element) => previousValue + element.fullPrice(),
    );
    if (sum > 0) {
      result.add(
        ChartData(
          value: sum / entry.value.length,
          title: entry.key,
        ),
      );
    }
  }

  result.sort(
    (a, b) => a.value.compareTo(b.value),
  );

  return result;
}

// ### Platform-Family Analytics ############################################ //

@riverpod
FutureOr<List<ChartData>> platformFamilyLegend(
  PlatformFamilyLegendRef ref,
) async {
  final l10n = ref.watch(l10nProvider);
  final activePlatformFamilies =
      await ref.watch(activeGamePlatformFamiliesProvider.future);

  final validGameAmounts =
      await ref.watch(gameAmountByPlatformFamilyProvider.future);
  final validGamePrices = await ref.watch(priceByPlatformFamilyProvider.future);

  return activePlatformFamilies
      .where(
        (element) =>
            validGameAmounts.any((v) => v.title == element.toLocale(l10n)) ||
            validGamePrices.any((v) => v.title == element.toLocale(l10n)),
      )
      .map((e) => ChartData(title: e.toLocale(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlatformFamily(
  GameAmountByPlatformFamilyRef ref,
) async {
  return await ref.watch(
    createGameAmountDataByGrouperProvider(
      const GameGrouperByPlatformFamily(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> priceByPlatformFamily(
  PriceByPlatformFamilyRef ref,
) async {
  return await ref.watch(
    createPriceDataByGrouperProvider(
      const GameGrouperByPlatformFamily(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> averagePriceByPlatformFamily(
  AveragePriceByPlatformFamilyRef ref,
) async {
  return await ref.watch(
    createAveragePriceDataByGrouperProvider(
      const GameGrouperByPlatformFamily(),
    ).future,
  );
}

// ### Platform Analytics ################################################### //

@riverpod
FutureOr<List<ChartData>> platformLegend(PlatformLegendRef ref) async {
  final l10n = ref.watch(l10nProvider);
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);

  final validGameAmounts = await ref.watch(gameAmountByPlatformProvider.future);
  final validGamePrices = await ref.watch(priceByPlatformProvider.future);

  return activePlatforms
      .where(
        (element) =>
            validGameAmounts
                .any((v) => v.title == element.localizedAbbreviation(l10n)) ||
            validGamePrices
                .any((v) => v.title == element.localizedAbbreviation(l10n)),
      )
      .map((e) => ChartData(title: e.localizedAbbreviation(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlatform(
  GameAmountByPlatformRef ref,
) async {
  return await ref.watch(
    createGameAmountDataByGrouperProvider(
      const GameGrouperByPlatform(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> priceByPlatform(PriceByPlatformRef ref) async {
  return await ref.watch(
    createPriceDataByGrouperProvider(
      const GameGrouperByPlatform(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> averagePriceByPlatform(
  AveragePriceByPlatformRef ref,
) async {
  return await ref.watch(
    createAveragePriceDataByGrouperProvider(
      const GameGrouperByPlatform(),
    ).future,
  );
}

// ### PlayStatus Analytics ################################################# //

@riverpod
FutureOr<List<ChartData>> playStatusLegend(PlayStatusLegendRef ref) async {
  final l10n = ref.watch(l10nProvider);

  final validGameAmounts =
      await ref.watch(gameAmountByPlayStatusProvider.future);
  final validGamePrices = await ref.watch(priceByPlayStatusProvider.future);

  return PlayStatus.values
      .where(
        (element) =>
            validGameAmounts
                .any((v) => v.title == element.toLocaleString(l10n)) ||
            validGamePrices.any((v) => v.title == element.toLocaleString(l10n)),
      )
      .map((e) => ChartData(title: e.toLocaleString(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlayStatus(
  GameAmountByPlayStatusRef ref,
) async {
  return await ref.watch(
    createGameAmountDataByGrouperProvider(
      const GameGrouperByPlayStatus(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> priceByPlayStatus(PriceByPlayStatusRef ref) async {
  return await ref.watch(
    createPriceDataByGrouperProvider(
      const GameGrouperByPlayStatus(),
    ).future,
  );
}

@riverpod
FutureOr<List<ChartData>> averagePriceByPlayStatus(
  AveragePriceByPlayStatusRef ref,
) async {
  return await ref.watch(
    createAveragePriceDataByGrouperProvider(
      const GameGrouperByPlayStatus(),
    ).future,
  );
}
