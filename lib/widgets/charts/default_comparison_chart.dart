import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/animated/animated_currency.dart';

class DefaultComparisonChart extends ConsumerStatefulWidget {
  const DefaultComparisonChart({
    super.key,
    required this.left,
    this.leftText,
    required this.right,
    this.rightText,
    this.formatValue,
  });

  final double left;
  final String? leftText;
  final double right;
  final String? rightText;
  final String Function(double value)? formatValue;

  @override
  ConsumerState<DefaultComparisonChart> createState() =>
      _DefaultComparisonChartState();
}

class _DefaultComparisonChartState
    extends ConsumerState<DefaultComparisonChart> {
  static const double height = 52.0;

  double l = 0;
  double r = 0;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(250.ms, () {
      if (context.mounted) {
        setState(() {
          l = widget.left;
          r = widget.right;
          if (widget.left + widget.right < 0.01) {
            progress = 1.0;
          } else {
            progress = (widget.left) / (widget.left + widget.right);
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
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;

              final rightStyle =
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      );
              final leftStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  );

              return SizedBox(
                width: maxWidth,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: 250.ms,
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                              ),
                              border: widget.left < widget.right
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )
                                  : null,
                            ),
                            width: (maxWidth * progress).clamp(0.0, maxWidth),
                            height: height,
                            child: progress > 0.1
                                ? Center(
                                    child: AnimatedCurrency(
                                      currency: l,
                                      duration: 250.ms,
                                      formatCurrency: (value) =>
                                          widget.formatValue != null
                                              ? widget.formatValue!(value)
                                              : currencyFormatter.format(value),
                                      style: leftStyle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: 250.ms,
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16.0),
                              ),
                              border: widget.left > widget.right
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    )
                                  : null,
                            ),
                            width: (maxWidth * (1.0 - progress))
                                .clamp(0.0, maxWidth),
                            height: height,
                            child: progress < 0.9
                                ? Center(
                                    child: AnimatedCurrency(
                                      currency: r,
                                      duration: 250.ms,
                                      formatCurrency: (value) =>
                                          widget.formatValue != null
                                              ? widget.formatValue!(value)
                                              : currencyFormatter.format(value),
                                      style: rightStyle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            stops: const [0, 0.45, 0.55, 1.0],
                          ),
                        ),
                        width: maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.leftText ?? "",
                                style: leftStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                widget.rightText ?? "",
                                style: rightStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
