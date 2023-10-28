import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/draggable_game_display_leading_trailing.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/draggable_game_display_secondary.dart';
import 'package:pile_of_shame/features/settings/game_display/widgets/game_display_drag_target.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/app_scaffold.dart';
import 'package:pile_of_shame/widgets/customizable_game_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/last_modified_display.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/price_and_last_modified_display.dart';
import 'package:pile_of_shame/widgets/price_only_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_game_display.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class GameDisplayScreen extends ConsumerStatefulWidget {
  const GameDisplayScreen({super.key});

  @override
  ConsumerState<GameDisplayScreen> createState() => _GameDisplayScreenState();
}

class _GameDisplayScreenState extends ConsumerState<GameDisplayScreen> {
  bool isEndPieceDragged = false;
  bool isBottomBarDragged = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final settings = ref.watch(customizeGameDisplaysProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final exampleGame = Game(
      id: "game-preview",
      name: "Outer Wilds",
      platform: GamePlatform.steam,
      status: PlayStatus.playing,
      usk: USK.usk12,
      price: 29.99,
      lastModified: DateTime(2023, 9, 24),
      createdAt: DateTime(2022, 8, 8),
    );

    void onDragEndPiece() {
      setState(() {
        isEndPieceDragged = true;
      });
    }

    void onDragEndEndPiece() {
      setState(() {
        isEndPieceDragged = false;
      });
    }

    void onDragBottomBar() {
      setState(() {
        isBottomBarDragged = true;
      });
    }

    void onDragEndBottomBar() {
      setState(() {
        isBottomBarDragged = false;
      });
    }

    return AppScaffold(
      appBar: AppBar(
        title: Text(l10n.gameDisplay),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 16.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: Text(
                  l10n.preview,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: defaultPaddingX,
              right: defaultPaddingX,
              top: 8.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.personalizeTheGameDisplayByDraggingEndPiecesOrBottomBarsIntoThePreview,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      CustomizableGameDisplay(
                        game: exampleGame,
                        onTap: () {
                          // Don't do anything here
                        },
                      ),
                      GameDisplayDragTarget(
                        isEndPieceMoving: isEndPieceDragged,
                        isBottomBarMoving: isBottomBarDragged,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: defaultPaddingX,
              right: defaultPaddingX,
              top: 8.0,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.endPieces,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 16.0,
            ),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      value: GameDisplayLeadingTrailing.ageRatingIcon,
                      child: USKLogo.fromGame(game: exampleGame),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      value: GameDisplayLeadingTrailing.platformIcon,
                      child: GamePlatformIcon.fromGame(game: exampleGame),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      value: GameDisplayLeadingTrailing.playStatusIcon,
                      child: PlayStatusIcon.fromGame(game: exampleGame),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      width: textSlotWidth + 8,
                      value: GameDisplayLeadingTrailing.priceAndLastModified,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: PriceAndLastModifiedDisplay.fromGame(
                          game: exampleGame,
                        ),
                      ),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      width: textSlotWidth + 8,
                      value: GameDisplayLeadingTrailing.priceOnly,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: PriceOnlyDisplay.fromGame(
                          game: exampleGame,
                        ),
                      ),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      width: textSlotWidth + 8,
                      value: GameDisplayLeadingTrailing.lastModifiedOnly,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: LastModifiedDisplay.fromGame(
                          game: exampleGame,
                        ),
                      ),
                    ),
                    DraggableGameDisplayLeadingTrailing(
                      onDragStarted: onDragEndPiece,
                      onDragEnded: onDragEndEndPiece,
                      value: GameDisplayLeadingTrailing.none,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.cancel,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.bottomBars,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingX,
              vertical: 16.0,
            ),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    DraggableGameDisplaySecondary(
                      value: GameDisplaySecondary.ageRatingText,
                      onDragStarted: onDragBottomBar,
                      onDragEnded: onDragEndBottomBar,
                      child: AgeRatingTextDisplay.fromGame(
                        game: exampleGame,
                      ),
                    ),
                    DraggableGameDisplaySecondary(
                      value: GameDisplaySecondary.statusText,
                      onDragStarted: onDragBottomBar,
                      onDragEnded: onDragEndBottomBar,
                      child: PlayStatusDisplay.fromGame(
                        game: exampleGame,
                      ),
                    ),
                    DraggableGameDisplaySecondary(
                      value: GameDisplaySecondary.platformText,
                      onDragStarted: onDragBottomBar,
                      onDragEnded: onDragEndBottomBar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          exampleGame.platform
                              .localizedName(AppLocalizations.of(context)!),
                        ),
                      ),
                    ),
                    DraggableGameDisplaySecondary(
                      value: GameDisplaySecondary.price,
                      onDragStarted: onDragBottomBar,
                      onDragEnded: onDragEndBottomBar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          currencyFormatter.format(exampleGame.fullPrice()),
                        ),
                      ),
                    ),
                    DraggableGameDisplaySecondary(
                      value: GameDisplaySecondary.none,
                      onDragStarted: onDragBottomBar,
                      onDragEnded: onDragEndBottomBar,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.cancel,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.delete,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPaddingX),
                child: Text(
                  l10n.settings,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
          ),
          settings.when(
            data: (settings) => SliverList.list(
              children: [
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Icon(Icons.animation),
                      ),
                      Text(l10n.fancyAnimations),
                    ],
                  ),
                  value: settings.hasFancyAnimations,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(customizeGameDisplaysProvider.notifier)
                          .setCustomGameDisplay(
                            settings.copyWith(hasFancyAnimations: value),
                          );
                    }
                  },
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 16.0),
                        child: Icon(Icons.repeat),
                      ),
                      Text(l10n.repeatAnimations),
                    ],
                  ),
                  enabled: settings.hasFancyAnimations,
                  value: settings.hasRepeatingAnimations,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(customizeGameDisplaysProvider.notifier)
                          .setCustomGameDisplay(
                            settings.copyWith(hasRepeatingAnimations: value),
                          );
                    }
                  },
                ),
              ],
            ),
            loading: () => SliverList.list(
              children: const [
                SkeletonGameDisplay(),
                ListTileSkeleton(),
                ListTileSkeleton(),
                ListTileSkeleton(),
                ListTileSkeleton(),
              ],
            ),
            error: (error, stackTrace) => SliverList.list(
              children: [Text(error.toString())],
            ),
          ),
        ],
      ),
    );
  }
}
