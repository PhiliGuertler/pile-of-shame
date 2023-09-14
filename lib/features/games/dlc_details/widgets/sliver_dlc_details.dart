import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class SliverDLCDetails extends ConsumerWidget {
  final Game game;
  final DLC dlc;

  const SliverDLCDetails({super.key, required this.game, required this.dlc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = ref.watch(dateFormatProvider(context));
    final timeFormatter = ref.watch(timeFormatProvider(context));
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return SliverList.list(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.name),
          subtitle: Text(game.name),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.name),
          subtitle: Text(dlc.name),
          trailing: const Chip(label: Text("DLC")),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.price),
          subtitle: Text(
            currencyFormatter.format(dlc.price),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.lastModified),
          subtitle: Text(
            AppLocalizations.of(context)!.dateAtTime(
              dateFormatter.format(dlc.lastModified),
              timeFormatter.format(dlc.lastModified),
            ),
          ),
        ),
        ListTile(
          leading: PlayStatusIcon(
            playStatus: dlc.status,
          ),
          title: Text(AppLocalizations.of(context)!.status),
          subtitle: Text(dlc.status.toLocaleString(context)),
        ).animate().fadeIn(),
        ListTile(
          leading: GamePlatformIcon(
            platform: game.platform,
          ),
          title: Text(AppLocalizations.of(context)!.platform),
          subtitle: Text(game.platform.name),
        ),
        ListTile(
          leading: USKLogo(
            ageRestriction: game.usk,
          ),
          title: Text(AppLocalizations.of(context)!.ageRating),
          subtitle: Text(
              AppLocalizations.of(context)!.ratedN(game.usk.age.toString())),
        ),
        const SizedBox(height: 48.0)
      ],
    );
  }
}

class SliverDLCDetailsSkeleton extends StatelessWidget {
  const SliverDLCDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: const [
        ListTile(
          title: Skeleton(),
          subtitle: Skeleton(
            widthFactor: 1.0,
            height: PlayStatusDisplay.height,
          ),
          trailing: Chip(
            label: Text("DLC"),
          ),
        ),
        ListTileSkeleton(
          hasLeading: false,
          hasSubtitle: true,
        ),
        ListTileSkeleton(
          hasLeading: false,
          hasSubtitle: true,
        ),
        ListTileSkeleton(hasSubtitle: true),
        ListTileSkeleton(hasSubtitle: true),
      ],
    );
  }
}
