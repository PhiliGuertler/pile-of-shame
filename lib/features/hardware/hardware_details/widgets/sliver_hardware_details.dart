import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/note.dart';

class SliverHardwareDetails extends ConsumerWidget {
  final VideoGameHardware hardware;

  const SliverHardwareDetails({super.key, required this.hardware});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));
    final timeFormatter =
        ref.watch(timeFormatProvider(Localizations.localeOf(context)));
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    final l10n = AppLocalizations.of(context)!;

    return SliverList.list(
      children: [
        if (hardware.notes != null && hardware.notes!.isNotEmpty)
          Note(
            child: Text(hardware.notes!),
          ),
        ListTile(
          title: Text(l10n.name),
          subtitle: Text(hardware.name),
        ),
        ListTile(
          leading: hardware.wasGifted
              ? ImageContainer(
                  child: Icon(
                    Icons.cake_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
          title: Text(l10n.price),
          subtitle: Text(
            hardware.wasGifted && hardware.price < 0.01
                ? l10n.gift
                : currencyFormatter.format(hardware.price),
          ),
        ),
        ListTile(
          title: Text(l10n.lastModified),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(hardware.lastModified),
              timeFormatter.format(hardware.lastModified),
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.createdAt),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(hardware.createdAt),
              timeFormatter.format(hardware.createdAt),
            ),
          ),
        ),
        ListTile(
          leading: GamePlatformIcon(
            platform: hardware.platform,
          ),
          title: Text(l10n.platform),
          subtitle: Text(
            hardware.platform.localizedName(l10n),
          ),
        ),
      ],
    );
  }
}
