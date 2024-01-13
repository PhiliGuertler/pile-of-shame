import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

class PriceOnlyDisplay extends ConsumerWidget {
  final double price;
  final PriceVariant priceVariant;

  const PriceOnlyDisplay({
    super.key,
    required this.price,
    required this.priceVariant,
  });

  factory PriceOnlyDisplay.fromGame({required Game game}) {
    return PriceOnlyDisplay(
      price: game.fullPrice(),
      priceVariant: game.priceVariant,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return SizedBox(
      width: textSlotWidth,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (price < 0.01)
              Icon(
                priceVariant.iconData,
                color: priceVariant.backgroundColor,
              ),
            if (!(price < 0.01))
              Text(
                currencyFormatter.format(price),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}
