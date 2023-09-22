import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class PriceOnlyDisplay extends ConsumerWidget {
  final double price;

  const PriceOnlyDisplay({super.key, required this.price});

  factory PriceOnlyDisplay.fromGame({required Game game}) {
    return PriceOnlyDisplay(price: game.fullPrice());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currencyFormatter.format(price)),
        ],
      ),
    );
  }
}
