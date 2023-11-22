import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class SliverDLCDetails extends ConsumerWidget {
  final Game game;
  final DLC dlc;

  const SliverDLCDetails({super.key, required this.game, required this.dlc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));
    final timeFormatter =
        ref.watch(timeFormatProvider(Localizations.localeOf(context)));
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return SliverList.list(
      children: [
        if (dlc.notes != null && dlc.notes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Note(
              label: l10n.notes,
              child: Text(dlc.notes!),
            ),
          ),
        ListTile(
          title: Text(l10n.gameName),
          subtitle: Text(game.name),
          trailing: const Chip(label: Text("DLC")),
        ),
        ListTile(
          title: Text(l10n.dlcName),
          subtitle: Text(dlc.name),
          trailing: AnimatedHeartButton(
            isFilled: dlc.isFavorite,
            onPressed: () async {
              final updatedDLC = dlc.copyWith(isFavorite: !dlc.isFavorite);
              final List<DLC> updatedDLCs = List.from(game.dlcs);
              final dlcIndex =
                  updatedDLCs.indexWhere((element) => element.id == dlc.id);
              updatedDLCs[dlcIndex] = updatedDLC;
              final updatedGame = game.copyWith(dlcs: updatedDLCs);

              final database = await ref.read(databaseProvider.future);
              final update = database.updateGame(updatedGame.id, updatedGame);

              await ref.read(databaseStorageProvider).persistDatabase(update);
            },
          ),
        ),
        ListTile(
          leading: ImageContainer(
            child: Icon(
              dlc.priceVariant.toIconData(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(l10n.price),
          subtitle: Text(
            dlc.price < 0.01
                ? dlc.priceVariant.toLocaleString(l10n)
                : currencyFormatter.format(dlc.price),
          ),
        ),
        ListTile(
          title: Text(l10n.lastModified),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(dlc.lastModified),
              timeFormatter.format(dlc.lastModified),
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.createdAt),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(dlc.createdAt),
              timeFormatter.format(dlc.createdAt),
            ),
          ),
        ),
        ListTile(
          leading: PlayStatusIcon(
            playStatus: dlc.status,
          ),
          title: Text(l10n.status),
          subtitle: Text(dlc.status.toLocaleString(l10n)),
        ),
        ListTile(
          leading: GamePlatformIcon(
            platform: game.platform,
          ),
          title: Text(l10n.platform),
          subtitle: Text(game.platform.localizedName(l10n)),
        ),
        ListTile(
          leading: USKLogo(
            ageRestriction: game.usk,
          ),
          title: Text(l10n.ageRating),
          subtitle: Text(
            l10n.ratedN(game.usk.age.toString()),
          ),
        ),
        const SizedBox(height: 48.0),
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
