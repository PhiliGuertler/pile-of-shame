import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

class GamePlatformAnalytics extends ConsumerWidget {
  const GamePlatformAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final legend = ref.watch(platformLegendProvider);
    final gameCount = ref.watch(gameAmountByPlatformProvider);
    final price = ref.watch(priceByPlatformProvider);
    final l10n = AppLocalizations.of(context)!;
    return Analytics(
        legend: legend.maybeWhen(
          orElse: () => GamePlatform.values
              .map(
                (e) =>
                    ChartData(title: e.localizedAbbreviation(l10n), value: 0),
              )
              .toList(),
          data: (data) => data,
        ),
        gameCount: gameCount,
        price: price);
  }
}
