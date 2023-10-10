import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class SliverSortGamesOrder extends StatelessWidget {
  const SliverSortGamesOrder({
    super.key,
    required this.isAscending,
    required this.onChanged,
  });

  final bool isAscending;
  final void Function(bool isAscending) onChanged;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CheckboxListTile(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              ),
            ),
            Text(AppLocalizations.of(context)!.isAscending),
          ],
        ),
        value: isAscending,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
