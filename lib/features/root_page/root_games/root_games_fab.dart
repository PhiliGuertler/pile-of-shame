import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/widgets/collapsing_floating_action_button.dart';

class RootGamesFab extends StatelessWidget {
  final bool isExtended;

  const RootGamesFab({super.key, required this.isExtended});

  @override
  Widget build(BuildContext context) {
    return CollapsingFloatingActionButton(
      key: const ValueKey('add'),
      icon: const Icon(Icons.add_rounded),
      label: Text(AppLocalizations.of(context)!.addGame),
      isExtended: isExtended,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Container(),
          ),
        );
      },
    );
  }
}
