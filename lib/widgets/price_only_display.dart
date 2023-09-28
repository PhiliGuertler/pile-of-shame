import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class PriceOnlyDisplay extends ConsumerWidget {
  final double price;
  final bool wasGifted;

  const PriceOnlyDisplay({
    super.key,
    required this.price,
    required this.wasGifted,
  });

  factory PriceOnlyDisplay.fromGame({required Game game}) {
    return PriceOnlyDisplay(
      price: game.fullPrice(),
      wasGifted: game.wasGifted && game.fullPrice() < 0.01,
    );
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
          if (wasGifted)
            Icon(
              Icons.cake_sharp,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (!wasGifted) Text(currencyFormatter.format(price)),
        ],
      ),
    );
  }
}
