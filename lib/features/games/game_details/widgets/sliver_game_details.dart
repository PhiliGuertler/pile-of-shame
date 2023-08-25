import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/dlc_details/screens/dlc_details_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class SliverGameDetails extends ConsumerStatefulWidget {
  final String gameId;

  const SliverGameDetails({super.key, required this.gameId});

  @override
  ConsumerState<SliverGameDetails> createState() => _SliverGameDetailsState();
}

class _SliverGameDetailsState extends ConsumerState<SliverGameDetails> {
  bool shouldShowPriceSum = true;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameByIdProvider(widget.gameId));
    final dateFormatter = ref.watch(dateFormatProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return SliverList.list(
      children: [
        game.when(
          data: (game) => ListTile(
            title: Text(game.name),
            subtitle: PlayStatusDisplay(playStatus: game.status),
          ),
          error: (error, stackTrace) =>
              Text("An Error occured: '${error.toString()}'"),
          loading: () => const ListTileSkeleton(
            hasLeading: false,
            hasSubtitle: true,
          ),
        ),
        ...game.when(
          data: (game) => [
            ListTile(
              title: Text(shouldShowPriceSum
                  ? AppLocalizations.of(context)!.priceWithDLCs
                  : AppLocalizations.of(context)!.price),
              subtitle: Text(
                currencyFormatter
                    .format(shouldShowPriceSum ? game.fullPrice() : game.price),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.swap_horiz),
                onPressed: () {
                  setState(() {
                    shouldShowPriceSum = !shouldShowPriceSum;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lastModified),
              subtitle: Text(dateFormatter.format(game.lastModified)),
            ),
            ListTile(
              leading: ImageContainer(
                child: Image.asset(game.platform.iconPath),
              ),
              title: Text(AppLocalizations.of(context)!.platform),
              subtitle: Text(game.platform.name),
            ),
            ListTile(
              leading: USKLogo(
                ageRestriction: game.usk,
              ),
              title: Text(AppLocalizations.of(context)!.ageRating),
              subtitle: Text(AppLocalizations.of(context)!
                  .ratedN(game.usk.age.toString())),
            ),
            if (game.dlcs.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPaddingX, right: defaultPaddingX, top: 16.0),
                child: Text(
                  "DLCs",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            if (game.dlcs.isNotEmpty)
              SegmentedActionCard(
                items: game.dlcs
                    .map(
                      (dlc) => SegmentedActionCardItem(
                        title: Text(dlc.name),
                        subtitle: SizedBox(
                            height: 32.0,
                            child: PlayStatusDisplay(playStatus: dlc.status)),
                        openBuilderOnTap: (context, action) => DLCDetailsScreen(
                            gameId: widget.gameId, dlcId: dlc.id),
                      ),
                    )
                    .toList(),
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
