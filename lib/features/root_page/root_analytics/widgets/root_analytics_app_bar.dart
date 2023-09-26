import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootAnalyticsAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final bool hasGames;

  final preferredSizeAppBar = AppBar(
    title: const Text("Analytics"),
    bottom: const TabBar(tabs: [
      Tab(
        child: Text("by status"),
      )
    ]),
  );

  final preferredSizeAppBarSmall = AppBar(
    title: const Text("Analytics"),
  );

  RootAnalyticsAppBar({super.key, required this.hasGames});

  @override
  Size get preferredSize => hasGames
      ? preferredSizeAppBar.preferredSize
      : preferredSizeAppBarSmall.preferredSize;

  @override
  ConsumerState<RootAnalyticsAppBar> createState() =>
      _RootAnalyticsAppBarState();
}

class _RootAnalyticsAppBarState extends ConsumerState<RootAnalyticsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.analytics),
      bottom: widget.hasGames
          ? TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  child: Text(AppLocalizations.of(context)!.byPlatformFamily),
                ),
                Tab(
                  child: Text(AppLocalizations.of(context)!.byPlatform),
                ),
                Tab(
                  child: Text(AppLocalizations.of(context)!.byStatus),
                ),
              ],
            )
          : null,
    );
  }
}
