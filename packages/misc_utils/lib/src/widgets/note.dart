import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final Widget child;

  final String label;

  const Note({super.key, required this.child, required this.label});

  @override
  Widget build(BuildContext context) {
    const creaseSize = 25.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: const BeveledRectangleBorder(
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(creaseSize)),
        ),
        child: ColoredBox(
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
                    label,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
