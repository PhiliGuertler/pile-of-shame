import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';

class RootGamesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar();

  RootGamesAppBar({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFilterActive = ref.watch(isAnyFilterActiveProvider);

    return AppBar(
      title: GestureDetector(
        child: Text(AppLocalizations.of(context)!.games),
        onTap: () {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        },
      ),
      leading: Builder(builder: (context) {
        return IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            });
      }),
      actions: [
        Builder(
          builder: (context) {
            Widget result = IconButton(
              icon: const Icon(Icons.filter_alt),
              color:
                  isFilterActive ? Theme.of(context).colorScheme.primary : null,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
            if (isFilterActive) {
              result = ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: result,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .shimmer(
                      duration: 1500.ms,
                      delay: 10.seconds,
                      color: Theme.of(context).colorScheme.surfaceTint,
                    ),
              );
            }
            return result;
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}
