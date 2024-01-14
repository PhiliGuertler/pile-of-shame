import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';

class PlayStatusDropdown extends StatelessWidget {
  final PlayStatus value;
  final void Function(PlayStatus selection) onSelect;

  const PlayStatusDropdown({
    super.key,
    required this.value,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<PlayStatus>(
      key: const ValueKey("play_status"),
      isExpanded: true,
      decoration: InputDecoration(
        label: Text(
          "${AppLocalizations.of(context)!.status}*",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        suffixIcon: const Icon(Icons.expand_more),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: PlayStatusIcon(playStatus: value),
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          onSelect(value);
        }
      },
      // Display the text of selected items only, as the prefix-icon takes care of the logo
      selectedItemBuilder: (context) => PlayStatus.values
          .map(
            (status) => Text(
              status.toLocaleString(AppLocalizations.of(context)!),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
          .toList(),
      // Don't display the default icon, instead display nothing
      icon: const SizedBox(),
      value: value,
      items: PlayStatus.values
          .map(
            (status) => DropdownMenuItem<PlayStatus>(
              value: status,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: PlayStatusIcon(playStatus: status),
                  ),
                  Text(
                    status.toLocaleString(AppLocalizations.of(context)!),
                    key: ValueKey(status.toString()),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
