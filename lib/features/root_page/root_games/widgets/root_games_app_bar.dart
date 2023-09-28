import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/games/game_filter_provider.dart';
import 'package:pile_of_shame/providers/games/game_search_provider.dart';

class RootGamesAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar();

  RootGamesAppBar({super.key, required this.scrollController});

  @override
  ConsumerState<RootGamesAppBar> createState() => _RootGamesAppBarState();

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;
}

class _RootGamesAppBarState extends ConsumerState<RootGamesAppBar> {
  late bool isSearchOpen;
  late TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();

    final currentSearch = ref.read(gameSearchProvider);

    isSearchOpen = currentSearch.isNotEmpty;
    searchTextController = TextEditingController(text: currentSearch);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilterActive = ref.watch(isAnyFilterActiveProvider);

    return AppBar(
      title: isSearchOpen
          ? TextField(
              key: const ValueKey('search_games'),
              controller: searchTextController,
              onChanged: (value) {
                ref.read(gameSearchProvider.notifier).setSearch(value);
              },
              decoration: InputDecoration.collapsed(
                hintText: AppLocalizations.of(context)!.searchGames,
              ),
              autofocus: true,
            )
          : GestureDetector(
              key: const ValueKey('games_screen_title'),
              child: Text(AppLocalizations.of(context)!.games),
              onTap: () {
                widget.scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              },
            ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            key: const ValueKey("sort_games"),
            icon: const Icon(Icons.sort),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        IconButton(
          key: const ValueKey("toggle_game_search"),
          onPressed: () {
            if (isSearchOpen) {
              searchTextController.text = "";
              ref.invalidate(gameSearchProvider);
            }
            setState(() {
              isSearchOpen = !isSearchOpen;
            });
          },
          icon: Icon(isSearchOpen ? Icons.search_off : Icons.search),
        ),
        Builder(
          builder: (context) {
            Widget result = IconButton(
              key: const ValueKey("filter_games"),
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
                child: ColoredBox(
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
}
