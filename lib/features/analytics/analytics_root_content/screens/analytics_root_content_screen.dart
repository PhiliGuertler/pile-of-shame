import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/providers/analytics_provider.dart';
import 'package:pile_of_shame/features/analytics/analytics_root_content/widgets/default_pie_chart.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';

class AnalyticsRootContentScreen extends ConsumerStatefulWidget {
  const AnalyticsRootContentScreen({super.key});

  @override
  ConsumerState<AnalyticsRootContentScreen> createState() =>
      _AnalyticsRootContentScreenState();
}

class _AnalyticsRootContentScreenState
    extends ConsumerState<AnalyticsRootContentScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final gameAmountByPlatformFamily =
        ref.watch(gameAmountByPlatformFamilyProvider);
    final gameAmountByPlatform = ref.watch(gameAmountByPlatformProvider);
    final gameAmountByPlayStatus = ref.watch(gameAmountByPlayStatusProvider);

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 8.0,
            ),
            child: gameAmountByPlatformFamily.maybeWhen(
              orElse: () {
                return const SizedBox();
              },
              data: (data) {
                return DefaultPieChart(
                  title: AppLocalizations.of(context)!.platformFamilies,
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
            child: gameAmountByPlatform.maybeWhen(
              orElse: () {
                return const SizedBox();
              },
              data: (data) {
                return DefaultPieChart(
                  title: AppLocalizations.of(context)!.platform,
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
            child: gameAmountByPlayStatus.maybeWhen(
              orElse: () {
                return const SizedBox();
              },
              data: (data) {
                return DefaultPieChart(
                  title: AppLocalizations.of(context)!.status,
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
        ],
      ),
    );
  }
}
