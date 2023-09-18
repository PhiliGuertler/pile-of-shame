import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/utils/constants.dart';

class Note extends StatelessWidget {
  final Widget child;

  const Note({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const creaseSize = 25.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX - 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          shape: const BeveledRectangleBorder(
              borderRadius:
                  BorderRadius.only(topRight: Radius.circular(creaseSize))),
          child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: Material(
                    elevation: 5,
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      width: creaseSize,
                      height: creaseSize,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.notes,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: creaseSize + 16.0,
                    left: 8.0,
                    bottom: 16.0,
                    right: 8.0,
                  ),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
