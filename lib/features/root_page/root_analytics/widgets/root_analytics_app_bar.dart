import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

class RootAnalyticsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final ScrollController scrollController;

  final preferredSizeAppBar = AppBar();

  RootAnalyticsAppBar({super.key, required this.scrollController});

  @override
  Size get preferredSize => preferredSizeAppBar.preferredSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.analytics),
    );
  }
}
