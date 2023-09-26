import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/analytics/analytics.dart';

class PlayStatusAnalytics extends ConsumerWidget {
  const PlayStatusAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final legend = ref.watch(playStatusLegendProvider);
    final gameCount = ref.watch(gameAmountByPlayStatusProvider);
    final price = ref.watch(priceByPlayStatusProvider);

    return Analytics(legend: legend, gameCount: gameCount, price: price);
  }
}
