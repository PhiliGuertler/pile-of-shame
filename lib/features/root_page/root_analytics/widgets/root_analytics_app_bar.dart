import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootAnalyticsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar(
    title: const Text("Analytics"),
    bottom: const TabBar(tabs: [
      Tab(
        child: Text("by status"),
      )
    ]),
  );

  RootAnalyticsAppBar({super.key, required this.scrollController});

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;

  @override
  State<RootAnalyticsAppBar> createState() => _RootAnalyticsAppBarState();
}

class _RootAnalyticsAppBarState extends State<RootAnalyticsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.analytics),
      bottom: TabBar(
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
      ),
    );
  }
}
