import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class SliverSortOrder extends StatelessWidget {
  const SliverSortOrder({
    super.key,
    required this.isAscending,
    required this.onChanged,
  });

  final bool isAscending;
  final void Function(bool isAscending) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: ListTile(
        title: Text(isAscending ? l10n.isAscending : l10n.descending),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            isAscending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
        ),
        onTap: () {
          onChanged(!isAscending);
        },
      ),
    );
  }
}
