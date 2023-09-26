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
    CreateGameAmountDataByGrouperRef ref, GameGrouper grouper) async {
  final games = await ref.watch(gamesProvider.future);
  final l10n = ref.watch(l10nProvider);

  final groupValues = grouper.values();
  Map<String, List<Game>> grouped = Map.fromEntries(
    groupValues.map(
      (e) => MapEntry(grouper.groupToLocaleString(l10n, e), []),
    ),
  );
  for (var game in games.games) {
    for (var group in groupValues) {
      if (grouper.matchesGroup(group, game)) {
        grouped[grouper.groupToLocaleString(l10n, group)]!.add(game);
      }
    }
  }

  grouped.removeWhere((key, value) => value.isEmpty);

  final List<ChartData> result = [];
  for (var i = 0; i < grouped.length; ++i) {
    final entry = grouped.entries.elementAt(i);
    result.add(ChartData(
      value: entry.value.length.toDouble(),
      title: entry.key,
    ));
  }

  result.sort(
    (a, b) => a.value.compareTo(b.value),
  );

  return result;
}

@riverpod
FutureOr<List<ChartData>> createPriceDataByGrouper(
    CreatePriceDataByGrouperRef ref, GameGrouper grouper) async {
  final games = await ref.watch(gamesProvider.future);
  final l10n = ref.watch(l10nProvider);

  final groupValues = grouper.values();
  Map<String, List<Game>> grouped = Map.fromEntries(
    groupValues.map(
      (e) => MapEntry(grouper.groupToLocaleString(l10n, e), []),
    ),
  );
  for (var game in games.games) {
    for (var group in groupValues) {
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
        0.0, (previousValue, element) => previousValue + element.fullPrice());
    if (sum > 0) {
      result.add(ChartData(
        value: sum,
        title: entry.key,
      ));
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
    PlatformFamilyLegendRef ref) async {
  final l10n = ref.watch(l10nProvider);
  final activePlatformFamilies =
      await ref.watch(activeGamePlatformFamiliesProvider.future);

  return activePlatformFamilies
      .map((e) => ChartData(title: e.toLocale(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlatformFamily(
    GameAmountByPlatformFamilyRef ref) async {
  return await ref.watch(createGameAmountDataByGrouperProvider(
    const GameGrouperByPlatformFamily(),
  ).future);
}

@riverpod
FutureOr<List<ChartData>> priceByPlatformFamily(
    PriceByPlatformFamilyRef ref) async {
  return await ref.watch(createPriceDataByGrouperProvider(
    const GameGrouperByPlatformFamily(),
  ).future);
}

// ### Platform Analytics ################################################### //

@riverpod
FutureOr<List<ChartData>> platformLegend(PlatformLegendRef ref) async {
  final l10n = ref.watch(l10nProvider);
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);
  return activePlatforms
      .map((e) => ChartData(title: e.localizedAbbreviation(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlatform(
    GameAmountByPlatformRef ref) async {
  return await ref.watch(createGameAmountDataByGrouperProvider(
    const GameGrouperByPlatform(),
  ).future);
}

@riverpod
FutureOr<List<ChartData>> priceByPlatform(PriceByPlatformRef ref) async {
  return await ref.watch(createPriceDataByGrouperProvider(
    const GameGrouperByPlatform(),
  ).future);
}

// ### PlayStatus Analytics ################################################# //

@riverpod
List<ChartData> playStatusLegend(PlayStatusLegendRef ref) {
  final l10n = ref.watch(l10nProvider);

  return PlayStatus.values
      .map((e) => ChartData(title: e.toLocaleString(l10n), value: 0.0))
      .toList();
}

@riverpod
FutureOr<List<ChartData>> gameAmountByPlayStatus(
    GameAmountByPlayStatusRef ref) async {
  return await ref.watch(createGameAmountDataByGrouperProvider(
    const GameGrouperByPlayStatus(),
  ).future);
}

@riverpod
FutureOr<List<ChartData>> priceByPlayStatus(PriceByPlayStatusRef ref) async {
  return await ref.watch(createPriceDataByGrouperProvider(
    const GameGrouperByPlayStatus(),
  ).future);
}
