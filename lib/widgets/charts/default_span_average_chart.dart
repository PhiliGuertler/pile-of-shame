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
  });

  final double min;
  final double max;
  final double average;

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
          progress = (widget.average - widget.min) / (widget.max - widget.min);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return Column(
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
                                      currencyFormatter.format(value),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
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
                                  currencyFormatter.format(value),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
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
    );
  }
}
