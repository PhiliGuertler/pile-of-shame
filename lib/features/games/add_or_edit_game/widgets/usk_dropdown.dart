import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class USKDropdown extends StatelessWidget {
  final USK value;
  final void Function(USK value) onChanged;

  const USKDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<USK>(
      key: const ValueKey("age_rating"),
      isExpanded: true,
      decoration: InputDecoration(
        label: Text(
          AppLocalizations.of(context)!.ageRating,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: USKLogo(ageRestriction: value),
        ),
        suffixIcon: const Icon(Icons.expand_more),
      ),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      // Display the text of selected items only, as the prefix-icon takes care of the logo
      selectedItemBuilder: (context) => USK.values
          .map(
            (usk) => Text(
              usk.toRatedString(AppLocalizations.of(context)!),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
          .toList(),
      // Don't display the default icon, instead display nothing
      icon: const SizedBox(),
      value: value,
      items: USK.values
          .map(
            (usk) => DropdownMenuItem<USK>(
              value: usk,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: USKLogo(ageRestriction: usk),
                  ),
                  Text(
                    usk.toRatedString(AppLocalizations.of(context)!),
                    key: ValueKey(usk.toString()),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
