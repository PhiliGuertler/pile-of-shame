import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/screens/add_or_edit_dlc_screen.dart';
import 'package:pile_of_shame/features/games/add_or_edit_game/widgets/price_variant_dropdown.dart';
import 'package:pile_of_shame/features/games/dlc_details/screens/dlc_details_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class SliverGameDetails extends ConsumerStatefulWidget {
  final Game game;

  const SliverGameDetails({super.key, required this.game});

  @override
  ConsumerState<SliverGameDetails> createState() => _SliverGameDetailsState();
}

class _SliverGameDetailsState extends ConsumerState<SliverGameDetails> {
  bool shouldShowPriceSum = true;

  // a working copy of currently dismissed dlcs.
  // This is necessary for
  List<String> dismissedDLCs = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final dateFormatter =
        ref.watch(dateFormatProvider(Localizations.localeOf(context)));
    final timeFormatter =
        ref.watch(timeFormatProvider(Localizations.localeOf(context)));
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    for (int i = dismissedDLCs.length - 1; i >= 0; --i) {
      final String dismissed = dismissedDLCs[i];
      if (!widget.game.dlcs.any(
        (element) => element.id == dismissed,
      )) {
        // clean up the list of dismissed dlcs on every rerender
        setState(() {
          dismissedDLCs.remove(dismissed);
        });
      }
    }

    final addDLCActionCardItem = SegmentedActionCardItem(
      key: const ValueKey("add_dlc"),
      leading: const Icon(Icons.add),
      title: Text(l10n.addDLC),
      onTap: () async {
        final EditableDLC? result =
            await Navigator.of(context).push<EditableDLC?>(
          MaterialPageRoute(
            builder: (context) => const AddDLCScreen(),
          ),
        );

        if (result != null) {
          final updatedGame =
              widget.game.copyWith(dlcs: [...widget.game.dlcs, result.toDLC()]);

          final database = await ref.read(databaseProvider.future);
          final update = database.updateGame(updatedGame.id, updatedGame);

          await ref.read(databaseStorageProvider).persistDatabase(update);
        }
      },
    );

    return SliverList.list(
      children: [
        if (widget.game.notes != null && widget.game.notes!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Note(
              label: l10n.notes,
              child: Text(widget.game.notes!),
            ),
          ),
        ListTile(
          title: Text(l10n.gameName),
          subtitle: Text(widget.game.name),
          trailing: AnimatedHeartButton(
            isFilled: widget.game.isFavorite,
            onPressed: () async {
              final updatedGame =
                  widget.game.copyWith(isFavorite: !widget.game.isFavorite);
              final database = await ref.read(databaseProvider.future);
              final update = database.updateGame(updatedGame.id, updatedGame);

              await ref.read(databaseStorageProvider).persistDatabase(update);
            },
          ),
        ),
        ListTile(
          leading: PriceVariantIcon(priceVariant: widget.game.priceVariant),
          title: Text(
            shouldShowPriceSum ? l10n.priceWithDLCs : l10n.price,
          ),
          subtitle: Text(
            widget.game.fullPrice() < 0.01
                ? widget.game.priceVariant.toLocaleString(l10n)
                : currencyFormatter.format(
                    shouldShowPriceSum
                        ? widget.game.fullPrice()
                        : widget.game.price,
                  ),
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
          leading: PlayStatusIcon(
            playStatus: widget.game.status,
          ),
          title: Text(l10n.status),
          subtitle: Text(
            widget.game.status.toLocaleString(l10n),
          ),
        ),
        ListTile(
          leading: GamePlatformIcon(
            platform: widget.game.platform,
          ),
          title: Text(l10n.platform),
          subtitle: Text(
            widget.game.platform.localizedName(l10n),
          ),
        ),
        ListTile(
          leading: USKLogo(
            ageRestriction: widget.game.usk,
          ),
          title: Text(l10n.ageRating),
          subtitle: Text(
            l10n.ratedN(widget.game.usk.age.toString()),
          ),
        ),
        ListTile(
          title: Text(l10n.lastModified),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(widget.game.lastModified),
              timeFormatter.format(widget.game.lastModified),
            ),
          ),
        ),
        ListTile(
          title: Text(l10n.createdAt),
          subtitle: Text(
            l10n.dateAtTime(
              dateFormatter.format(widget.game.createdAt),
              timeFormatter.format(widget.game.createdAt),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: defaultPaddingX,
            right: defaultPaddingX,
            top: 16.0,
          ),
          child: Text(
            "DLCs",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SegmentedActionCard(
          items: [
            ...widget.game.dlcs
                .where((element) => !dismissedDLCs.contains(element.id))
                .map(
                  (dlc) => SegmentedActionCardItem(
                    key: ValueKey(dlc.id),
                    leading: PlayStatusIcon(playStatus: dlc.status),
                    title: Text(dlc.name),
                    subtitle: Text(
                      dlc.price < 0.01
                          ? dlc.priceVariant.toLocaleString(l10n)
                          : currencyFormatter.format(dlc.price),
                    ),
                    openBuilderOnTap: (context, action) => DLCDetailsScreen(
                      game: widget.game,
                      dlcId: dlc.id,
                    ),
                  ),
                ),
            addDLCActionCardItem,
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPaddingX),
          child: Text(
            l10n.nDLCs(widget.game.dlcs.length),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class SliverGameDetailsSkeleton extends StatelessWidget {
  const SliverGameDetailsSkeleton({super.key});

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
