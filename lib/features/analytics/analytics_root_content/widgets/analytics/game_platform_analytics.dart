import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';

class GamePlatformAnalytics extends ConsumerWidget {
  const GamePlatformAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final legend = ref.watch(platformLegendProvider);
    final gameCount = ref.watch(gameAmountByPlatformProvider);
    final price = ref.watch(priceByPlatformProvider);
    return Analytics(legend: legend, gameCount: gameCount, price: price);
  }
}
