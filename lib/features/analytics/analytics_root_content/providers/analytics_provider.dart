import 'package:pile_of_shame/features/analytics/analytics_root_content/models/default_pie_chart_data.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

@riverpod
FutureOr<List<DefaultPieChartData>> createPieChartDataByGrouper(
    CreatePieChartDataByGrouperRef ref, GameGrouper grouper) async {
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

  final List<DefaultPieChartData> result = [];
  for (var i = 0; i < grouped.length; ++i) {
    final entry = grouped.entries.elementAt(i);
    result.add(DefaultPieChartData(
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
FutureOr<List<DefaultPieChartData>> gameAmountByPlatformFamily(
    GameAmountByPlatformFamilyRef ref) async {
  return await ref.watch(createPieChartDataByGrouperProvider(
    const GameGrouperByPlatformFamily(),
  ).future);
}

@riverpod
FutureOr<List<DefaultPieChartData>> gameAmountByPlatform(
    GameAmountByPlatformRef ref) async {
  return await ref.watch(createPieChartDataByGrouperProvider(
    const GameGrouperByPlatform(),
  ).future);
}

@riverpod
FutureOr<List<DefaultPieChartData>> gameAmountByPlayStatus(
    GameAmountByPlayStatusRef ref) async {
  return await ref.watch(createPieChartDataByGrouperProvider(
    const GameGrouperByPlayStatus(),
  ).future);
}
