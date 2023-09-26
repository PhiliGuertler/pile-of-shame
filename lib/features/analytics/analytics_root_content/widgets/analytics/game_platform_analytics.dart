import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

import '../default_pie_chart.dart';

class GamePlatformAnalytics extends ConsumerWidget {
  const GamePlatformAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameCount = ref.watch(gameAmountByPlatformProvider);
    final price = ref.watch(priceByPlatformProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPaddingX,
            vertical: 8.0,
          ),
          child: gameCount.maybeWhen(
            orElse: () {
              return const SizedBox();
            },
            data: (data) {
              return DefaultPieChart(
                title: AppLocalizations.of(context)!.gameCount,
                data: data,
                total: data
                    .fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.value.toInt())
                    .toString(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPaddingX,
            vertical: 8.0,
          ),
          child: price.maybeWhen(
            orElse: () {
              return const SizedBox();
            },
            data: (data) {
              return DefaultPieChart(
                title: AppLocalizations.of(context)!.price,
                data: data,
                total: currencyFormatter.format(data.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.value.toInt())),
                formatData: (data) => currencyFormatter.format(data),
              );
            },
          ),
        ),
      ],
    );
  }
}
