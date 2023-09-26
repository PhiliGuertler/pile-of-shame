import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';

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

    return legend.when(
      data: (legend) => Analytics(
        legend: legend,
        gameCount: gameCount,
        price: price,
      ),
      loading: () => const AnalyticsSkeleton(),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
