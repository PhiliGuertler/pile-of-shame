import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/games/dlc_details/screens/dlc_details_screen.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/note.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
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

  @override
  Widget build(BuildContext context) {
    final dateFormatter = ref.watch(dateFormatProvider(context));
    final timeFormatter = ref.watch(timeFormatProvider(context));
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return SliverList.list(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.gameName),
          subtitle: Text(widget.game.name),
        ),
        ListTile(
          title: Text(shouldShowPriceSum
              ? AppLocalizations.of(context)!.priceWithDLCs
              : AppLocalizations.of(context)!.price),
          subtitle: Text(
            currencyFormatter.format(shouldShowPriceSum
                ? widget.game.fullPrice()
                : widget.game.price),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                shouldShowPriceSum = !shouldShowPriceSum;
              });
            },
          ),
        ).animate().fadeIn(),
        ListTile(
          title: Text(AppLocalizations.of(context)!.lastModified),
          subtitle: Text(
            AppLocalizations.of(context)!.dateAtTime(
              dateFormatter.format(widget.game.lastModified),
              timeFormatter.format(widget.game.lastModified),
            ),
          ),
        ).animate().fadeIn(),
        ListTile(
          leading: PlayStatusIcon(
            playStatus: widget.game.status,
          ),
          title: Text(AppLocalizations.of(context)!.status),
          subtitle: Text(
              widget.game.status.toLocaleString(AppLocalizations.of(context)!)),
        ).animate().fadeIn(),
        ListTile(
          leading: GamePlatformIcon(
            platform: widget.game.platform,
          ),
          title: Text(AppLocalizations.of(context)!.platform),
          subtitle: Text(widget.game.platform
              .localizedName(AppLocalizations.of(context)!)),
        ).animate().fadeIn(),
        ListTile(
          leading: USKLogo(
            ageRestriction: widget.game.usk,
          ),
          title: Text(AppLocalizations.of(context)!.ageRating),
          subtitle: Text(AppLocalizations.of(context)!
              .ratedN(widget.game.usk.age.toString())),
        ).animate().fadeIn(),
        if (widget.game.notes != null && widget.game.notes!.isNotEmpty)
          Note(
            child: Text(widget.game.notes!),
          ),
        if (widget.game.dlcs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
                left: defaultPaddingX, right: defaultPaddingX, top: 16.0),
            child: Text(
              "DLCs",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ).animate().fadeIn(),
        if (widget.game.dlcs.isNotEmpty)
          SegmentedActionCard(
            items: widget.game.dlcs
                .map(
                  (dlc) => SegmentedActionCardItem(
                    title: Text(dlc.name),
                    subtitle: SizedBox(
                        height: 32.0,
                        child: PlayStatusDisplay(playStatus: dlc.status)),
                    openBuilderOnTap: (context, action) => DLCDetailsScreen(
                      game: widget.game,
                      dlcId: dlc.id,
                    ),
                  ),
                )
                .toList(),
          ).animate().fadeIn(),
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
