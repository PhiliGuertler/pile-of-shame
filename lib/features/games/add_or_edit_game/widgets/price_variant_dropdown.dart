import 'package:flutter/material.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/price_variant.dart';

class PriceVariantIcon extends StatelessWidget {
  final PriceVariant priceVariant;

  const PriceVariantIcon({super.key, required this.priceVariant});

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      backgroundColor: priceVariant.backgroundColor,
      child: Icon(
        priceVariant.iconData,
        color: priceVariant.foregroundColor,
      ),
    );
  }
}

class PriceVariantDropdown extends StatelessWidget {
  final PriceVariant value;
  final void Function(PriceVariant selection) onSelect;
  final bool enabled;

  const PriceVariantDropdown({
    super.key,
    required this.value,
    required this.onSelect,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Widget content;

    if (value == PriceVariant.observing) {
      content = const SizedBox(height: 0);
    } else {
      content = DropdownButtonFormField<PriceVariant>(
        key: const ValueKey("price_variant"),
        isExpanded: true,
        decoration: InputDecoration(
          label: Text(
            "${l10n.priceVariant}*",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          suffixIcon: const Icon(Icons.expand_more),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PriceVariantIcon(
              priceVariant: value,
            ),
          ),
          enabled: enabled,
        ),
        onChanged: (value) {
          if (value != null) {
            onSelect(value);
          }
        },
        // Display the text of selected items only, as the prefix-icon takes care of the logo
        selectedItemBuilder: (context) => PriceVariant.values
            .where((element) => element != PriceVariant.observing)
            .map(
              (variant) => Text(
                variant.toLocaleString(l10n),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
            .toList(),
        // Don't display the default icon, instead display nothing
        icon: const SizedBox(),
        value: value,
        items: PriceVariant.values
            .where((element) => element != PriceVariant.observing)
            .map(
              (variant) => DropdownMenuItem<PriceVariant>(
                value: variant,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: PriceVariantIcon(priceVariant: variant),
                    ),
                    Text(
                      variant.toLocaleString(AppLocalizations.of(context)!),
                      key: ValueKey(variant.toString()),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }

    return AnimatedSize(
      curve: Curves.easeInOutBack,
      duration: const Duration(milliseconds: 200),
      child: content,
    );
  }
}
