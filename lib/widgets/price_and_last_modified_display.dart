import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class PriceAndLastModifiedDisplay extends ConsumerWidget {
  final double price;
  final bool wasGifted;
  final DateTime lastModified;

  const PriceAndLastModifiedDisplay({
    super.key,
    required this.price,
    required this.lastModified,
    required this.wasGifted,
  });

  factory PriceAndLastModifiedDisplay.fromGame({required Game game}) {
    return PriceAndLastModifiedDisplay(
      price: game.fullPrice(),
      lastModified: game.lastModified,
      wasGifted: game.wasGifted && game.fullPrice() < 0.01,
    );
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
          if (wasGifted)
            Icon(
              Icons.cake_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (!wasGifted) Text(currencyFormatter.format(price)),
          Text(dateFormatter.format(lastModified)),
        ],
      ),
    );
  }
}
