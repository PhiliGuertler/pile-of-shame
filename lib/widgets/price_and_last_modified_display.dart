import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class PriceAndLastModifiedDisplay extends ConsumerWidget {
  final double price;
  final DateTime lastModified;

  const PriceAndLastModifiedDisplay(
      {super.key, required this.price, required this.lastModified});

  factory PriceAndLastModifiedDisplay.fromGame({required Game game}) {
    return PriceAndLastModifiedDisplay(
        price: game.fullPrice(), lastModified: game.lastModified);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider(context));

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currencyFormatter.format(price)),
          Text(dateFormatter.format(lastModified)),
        ],
      ),
    );
  }
}
