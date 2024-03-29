import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';

class LastModifiedDisplay extends ConsumerWidget {
  final DateTime lastModified;

  const LastModifiedDisplay({super.key, required this.lastModified});

  factory LastModifiedDisplay.fromGame({required Game game}) {
    return LastModifiedDisplay(lastModified: game.lastModified);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));

    return SizedBox(
      height: ImageContainer.imageSize,
      width: textSlotWidth,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.labelSmall ?? const TextStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
