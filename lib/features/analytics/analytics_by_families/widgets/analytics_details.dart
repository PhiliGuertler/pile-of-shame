import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/analytics/analytics_by_families/utils/game_data.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/charts/default_bar_chart.dart';
import 'package:pile_of_shame/widgets/charts/default_pie_chart.dart';
import 'package:pile_of_shame/widgets/charts/legend.dart';

class AnalyticsDetails extends ConsumerStatefulWidget {
  const AnalyticsDetails({
    super.key,
    required this.games,
  });

  final List<Game> games;

  @override
  ConsumerState<AnalyticsDetails> createState() => _AnalyticsDetailsState();
}

class _AnalyticsDetailsState extends ConsumerState<AnalyticsDetails> {
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
    final l10n = AppLocalizations.of(context)!;

    final GameData data =
        GameData(games: widget.games, l10n: l10n, highlight: highlightedLabel);

    return ListView(
      children: [
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPaddingX,
            vertical: 8.0,
          ),
          child: Legend(
            onChangeSelection: handleSectionChange,
            data: data.toPlatformLegendData(highlightedLabel),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: DefaultPieChart(
                data: data.toCompletedData(),
                title: "Komplettierungsrate",
                onTapSection: handleSectionChange,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}

class AnalyticsDetailsSkeleton extends StatelessWidget {
  const AnalyticsDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(
          height: 16.0,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: defaultPaddingX, vertical: 8.0),
          child: LegendSkeleton(),
        ),
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultBarChartSkeleton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultBarChartSkeleton(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPaddingX,
                vertical: 8.0,
              ),
              child: SizedBox(
                width: 350,
                child: DefaultPieChartSkeleton(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
