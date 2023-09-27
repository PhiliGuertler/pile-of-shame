import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';

class GamePlatformFamilyAnalytics extends ConsumerWidget {
  const GamePlatformFamilyAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final legend = ref.watch(platformFamilyLegendProvider);
    final gameCount = ref.watch(gameAmountByPlatformFamilyProvider);
    final price = ref.watch(priceByPlatformFamilyProvider);
    final averagePrice = ref.watch(averagePriceByPlatformFamilyProvider);

    return legend.when(
      data: (legend) => Analytics(
        legend: legend,
        gameCount: gameCount,
        price: price,
        averagePrice: averagePrice,
      ),
      loading: () => const AnalyticsSkeleton(),
      error: (error, stackTrace) => Text(error.toString()),
    );
  }
}
