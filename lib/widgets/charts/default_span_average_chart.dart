import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/animated/animated_currency.dart';

class DefaultSpanAverageChart extends ConsumerStatefulWidget {
  const DefaultSpanAverageChart({
    super.key,
    required this.min,
    required this.max,
    required this.average,
    required this.title,
  });

  final double min;
  final double max;
  final double average;
  final String title;

  @override
  ConsumerState<DefaultSpanAverageChart> createState() =>
      _DefaultSpanAverageChartState();
}

class _DefaultSpanAverageChartState
    extends ConsumerState<DefaultSpanAverageChart> {
  double avg = 0;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(250.ms, () {
      if (context.mounted) {
        setState(() {
          avg = widget.average;
          if (widget.max - widget.min < 0.01) {
            progress = 1.0;
          } else {
            progress =
                (widget.average - widget.min) / (widget.max - widget.min);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    height: 48.0,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth;

                      final outsideStyle =
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              );
                      final insideStyle =
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              );

                      return Row(
                        children: [
                          AnimatedContainer(
                            duration: 250.ms,
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                              ),
                            ),
                            width: (maxWidth * progress).clamp(0.0, maxWidth),
                            height: 48.0,
                            child: progress > 0.5
                                ? Center(
                                    child: AnimatedCurrency(
                                      currency: avg,
                                      duration: 250.ms,
                                      formatCurrency: (value) =>
                                          "Ø ${currencyFormatter.format(value)}",
                                      style: insideStyle,
                                    ),
                                  )
                                : null,
                          ),
                          if (progress < 0.5)
                            Expanded(
                              child: Center(
                                child: AnimatedCurrency(
                                  currency: avg,
                                  duration: 250.ms,
                                  formatCurrency: (value) =>
                                      "Ø ${currencyFormatter.format(value)}",
                                  style: outsideStyle,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(currencyFormatter.format(widget.min)),
                  Text(currencyFormatter.format(widget.max)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
