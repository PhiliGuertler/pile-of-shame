import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/widgets/animated/animated_heart/animated_heart_button.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/note.dart';
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
    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));
    final timeFormatter =
        ref.watch(timeFormatProvider(Localizations.localeOf(context)));
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    return SliverList.list(
      children: [
        if (dlc.notes != null && dlc.notes!.isNotEmpty)
          Note(
            child: Text(dlc.notes!),
          ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.gameName),
          subtitle: Text(game.name),
          trailing: const Chip(label: Text("DLC")),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.dlcName),
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
          leading: dlc.wasGifted
              ? ImageContainer(
                  child: Icon(
                    Icons.cake_sharp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
          title: Text(AppLocalizations.of(context)!.price),
          subtitle: Text(
            dlc.wasGifted
                ? AppLocalizations.of(context)!.gift
                : currencyFormatter.format(dlc.price),
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
          title: Text(AppLocalizations.of(context)!.createdAt),
          subtitle: Text(
            AppLocalizations.of(context)!.dateAtTime(
              dateFormatter.format(dlc.createdAt),
              timeFormatter.format(dlc.createdAt),
            ),
          ),
        ),
        ListTile(
          leading: PlayStatusIcon(
            playStatus: dlc.status,
          ),
          title: Text(AppLocalizations.of(context)!.status),
          subtitle:
              Text(dlc.status.toLocaleString(AppLocalizations.of(context)!)),
        ),
        ListTile(
          leading: GamePlatformIcon(
            platform: game.platform,
          ),
          title: Text(AppLocalizations.of(context)!.platform),
          subtitle:
              Text(game.platform.localizedName(AppLocalizations.of(context)!)),
        ),
        ListTile(
          leading: USKLogo(
            ageRestriction: game.usk,
          ),
          title: Text(AppLocalizations.of(context)!.ageRating),
          subtitle: Text(
            AppLocalizations.of(context)!.ratedN(game.usk.age.toString()),
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
