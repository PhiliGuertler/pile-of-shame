import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

class PriceAndLastModifiedDisplay extends ConsumerWidget {
  final double price;
  final PriceVariant priceVariant;
  final DateTime lastModified;

  const PriceAndLastModifiedDisplay({
    super.key,
    required this.price,
    required this.lastModified,
    required this.priceVariant,
  });

  factory PriceAndLastModifiedDisplay.fromGame({required Game game}) {
    return PriceAndLastModifiedDisplay(
      price: game.fullPrice(),
      lastModified: game.lastModified,
      priceVariant: game.priceVariant,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));
    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));

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
            Text(
              dateFormatter.format(lastModified),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
