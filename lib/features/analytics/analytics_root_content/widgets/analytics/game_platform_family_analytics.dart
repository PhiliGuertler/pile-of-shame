import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/chart_data.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

class GamePlatformFamilyAnalytics extends ConsumerStatefulWidget {
  const GamePlatformFamilyAnalytics({super.key});

  @override
  ConsumerState<GamePlatformFamilyAnalytics> createState() =>
      _GamePlatformFamilyAnalyticsState();
}

class _GamePlatformFamilyAnalyticsState
    extends ConsumerState<GamePlatformFamilyAnalytics> {
  String? highlightedLabel;

  void handleSectionChange(String? selection) {
    if (highlightedLabel == selection) {
      setState(() {
        highlightedLabel = null;
      });
    } else {
      setState(() {
        highlightedLabel = selection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final legend = ref.watch(platformFamilyLegendProvider);
    final gameCount = ref.watch(gameAmountByPlatformFamilyProvider);
    final price = ref.watch(priceByPlatformFamilyProvider);
    final l10n = AppLocalizations.of(context)!;

    return Analytics(
        legend: legend.maybeWhen(
          orElse: () => GamePlatformFamily.values
              .map(
                (e) => ChartData(title: e.toLocale(l10n), value: 0),
              )
              .toList(),
          data: (data) => data,
        ),
        gameCount: gameCount,
        price: price);
  }
}
