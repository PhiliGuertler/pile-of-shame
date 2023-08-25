import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class SliverDLCDetails extends ConsumerWidget {
  final String gameId;
  final String dlcId;

  const SliverDLCDetails(
      {super.key, required this.gameId, required this.dlcId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameByIdProvider(gameId));
    final dlc = ref.watch(dlcByGameAndIdProvider(gameId, dlcId));
    final dateFormatter = ref.watch(dateFormatProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return SliverList.list(
      children: [
        dlc.when(
          data: (dlc) => ListTile(
            title: Text(dlc.name),
            subtitle: PlayStatusDisplay(playStatus: dlc.status),
          ),
          error: (error, stackTrace) =>
              Text("An Error occured: '${error.toString()}'"),
          loading: () => const ListTileSkeleton(
            hasLeading: false,
            hasSubtitle: true,
          ),
        ),
        ...dlc.when(
          data: (dlc) => [
            ListTile(
              title: Text(AppLocalizations.of(context)!.price),
              subtitle: Text(
                currencyFormatter.format(dlc.price),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lastModified),
              subtitle: Text(dateFormatter.format(dlc.lastModified)),
            ),
            game.when(
              data: (game) => ListTile(
                leading: ImageContainer(
                  child: Image.asset(game.platform.iconPath),
                ),
                title: Text(AppLocalizations.of(context)!.platform),
                subtitle: Text(game.platform.name),
              ),
              loading: () => const ListTileSkeleton(
                hasSubtitle: true,
              ),
              error: (error, stackTrace) => const SizedBox(),
            ),
            game.when(
              data: (game) => ListTile(
                leading: USKLogo(
                  ageRestriction: game.usk,
                ),
                title: Text(AppLocalizations.of(context)!.ageRating),
                subtitle: Text(AppLocalizations.of(context)!
                    .ratedN(game.usk.age.toString())),
              ),
              loading: () => const ListTileSkeleton(),
              error: (error, stackTrace) => const SizedBox(),
            ),
            const SizedBox(height: 48.0)
          ],
          loading: () => [
            const ListTileSkeleton(
              hasLeading: false,
              hasSubtitle: true,
            ),
            const ListTileSkeleton(
              hasLeading: false,
              hasSubtitle: true,
            ),
            const ListTileSkeleton(hasSubtitle: true),
            const ListTileSkeleton(hasSubtitle: true),
          ],
          error: (error, stackTrace) => [],
        ),
      ],
    );
  }
}
