import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/hardware/hardware_details/screens/hardware_details_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/providers/format_provider.dart';

class HardwareEntry extends ConsumerStatefulWidget {
  final VideoGameHardware hardware;
  final bool isLastElement;

  const HardwareEntry({
    super.key,
    required this.hardware,
    required this.isLastElement,
  });

  @override
  ConsumerState<HardwareEntry> createState() => _HardwareEntryState();
}

class _HardwareEntryState extends ConsumerState<HardwareEntry> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft:
              widget.isLastElement ? const Radius.circular(12.0) : Radius.zero,
          bottomRight:
              widget.isLastElement ? const Radius.circular(30.0) : Radius.zero,
        ),
      ),
      title: Text(widget.hardware.name),
      subtitle: widget.hardware.wasGifted
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.cake,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    l10n.gift,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            )
          : Text(
              currencyFormatter.format(widget.hardware.price),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
      trailing: const Icon(Icons.navigate_next),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HardwareDetailsScreen(
              hardwareId: widget.hardware.id,
            ),
          ),
        );
      },
    );
  }
}
