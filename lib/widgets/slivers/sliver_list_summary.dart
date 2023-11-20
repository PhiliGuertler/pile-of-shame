import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';

class SliverListSummary extends ConsumerWidget {
  const SliverListSummary({
    super.key,
    required this.gameCount,
    required this.totalPrice,
  });

  final int? gameCount;
  final double? totalPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: defaultPaddingX,
          right: defaultPaddingX,
          bottom: 32.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 128,
              child: gameCount != null
                  ? Text(
                      l10n.nGames(gameCount!),
                    )
                  : const Skeleton(
                      widthFactor: 1,
                    ),
            ),
            SizedBox(
              width: 128,
              child: Align(
                alignment: Alignment.centerRight,
                child: totalPrice != null
                    ? Text(currencyFormatter.format(totalPrice))
                    : const Skeleton(
                        widthFactor: 1,
                        alignment: Alignment.centerRight,
                      ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }
}
