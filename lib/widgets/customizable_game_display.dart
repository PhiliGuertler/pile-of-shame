import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/note.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_image_container.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class CustomizableGameDisplay extends ConsumerWidget {
  final Game game;
  final VoidCallback onTap;

  const CustomizableGameDisplay({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = ref.watch(currencyFormatProvider(context));
    final dateFormatter = ref.watch(dateFormatProvider(context));

    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget? leadingWidget;
    Widget? trailingWidget;
    Widget? secondaryWidget;

    settings.when(
        data: (settings) {
          switch (settings.leading) {
            case GameDisplayLeadingTrailing.ageRatingIcon:
              leadingWidget = USKLogo.fromGame(game: game);
            case GameDisplayLeadingTrailing.platformIcon:
              leadingWidget = GamePlatformIcon.fromGame(game: game);
            case GameDisplayLeadingTrailing.playStatusIcon:
              leadingWidget = PlayStatusIcon.fromGame(
                game: game,
              );
            case GameDisplayLeadingTrailing.priceAndLastModified:
              leadingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayLeadingTrailing.priceOnly:
              leadingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                ],
              );
            case GameDisplayLeadingTrailing.lastModifiedOnly:
              leadingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayLeadingTrailing.none:
              leadingWidget = null;
          }
          switch (settings.trailing) {
            case GameDisplayLeadingTrailing.ageRatingIcon:
              trailingWidget = USKLogo.fromGame(game: game);
            case GameDisplayLeadingTrailing.platformIcon:
              trailingWidget = GamePlatformIcon.fromGame(game: game);
            case GameDisplayLeadingTrailing.playStatusIcon:
              trailingWidget = PlayStatusIcon.fromGame(
                game: game,
              );
            case GameDisplayLeadingTrailing.priceAndLastModified:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayLeadingTrailing.priceOnly:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(currencyFormatter.format(game.fullPrice())),
                ],
              );
            case GameDisplayLeadingTrailing.lastModifiedOnly:
              trailingWidget = Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dateFormatter.format(game.lastModified)),
                ],
              );
            case GameDisplayLeadingTrailing.none:
              trailingWidget = null;
          }
          switch (settings.secondary) {
            case GameDisplaySecondary.statusText:
              secondaryWidget = PlayStatusDisplay.fromGame(game: game);
            case GameDisplaySecondary.ageRatingText:
              secondaryWidget = AgeRatingTextDisplay.fromGame(game: game);
            case GameDisplaySecondary.platformText:
              secondaryWidget = Text(
                  game.platform.localizedName(AppLocalizations.of(context)!));
            case GameDisplaySecondary.price:
              secondaryWidget =
                  Text(currencyFormatter.format(game.fullPrice()));
            case GameDisplaySecondary.none:
              secondaryWidget = null;
          }
        },
        error: (error, stackTrace) {},
        loading: () {
          trailingWidget = const ImageContainerSkeleton();
          leadingWidget = const ImageContainerSkeleton();
          secondaryWidget = const Skeleton();
        });

    const double favoriteSize = 32;

    List<String> notes = [];
    if (game.notes != null && game.notes!.isNotEmpty) {
      notes.add(game.notes!);
    }
    for (var dlc in game.dlcs) {
      if (dlc.notes != null && dlc.notes!.isNotEmpty) {
        notes.add(dlc.notes!);
      }
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) async {
              final updatedGame = game.copyWith(isFavorite: !game.isFavorite);
              final gamesList = await ref.read(gamesProvider.future);
              final update = gamesList.updateGame(updatedGame.id, updatedGame);

              await ref.read(gameStorageProvider).persistGamesList(update);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: game.isFavorite ? Icons.favorite : Icons.favorite_border,
          ),
        ],
      ),
      startActionPane: notes.isNotEmpty
          ? ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.2,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NotesOverlay(
                          notes: notes,
                        );
                      },
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  foregroundColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  icon: Icons.open_in_full,
                ),
              ],
            )
          : null,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Positioned(
                  right: -favoriteSize * 0.4,
                  child: Icon(
                    Icons.favorite,
                    size: favoriteSize,
                    color: Colors.red,
                  ))
              .animate(
                target: game.isFavorite ? 1 : 0,
              )
              .rotate(
                begin: 0,
                end: -0.04,
                curve: Curves.easeInOutBack,
              )
              .moveX(
                begin: favoriteSize,
                end: 0,
                curve: Curves.easeInOutBack,
              ),
          if (notes.isNotEmpty)
            Positioned(
              left: -favoriteSize * 0.4,
              child: Icon(
                Icons.note,
                size: favoriteSize,
                color: Theme.of(context).colorScheme.surfaceVariant,
              )
                  .animate()
                  .rotate(
                    begin: 0,
                    end: 0.02,
                    curve: Curves.easeInOutBack,
                  )
                  .moveX(
                    begin: -favoriteSize,
                    end: 0,
                    curve: Curves.easeInOutBack,
                  ),
            ),
          ListTile(
            title: Text(game.name),
            subtitle: secondaryWidget,
            leading: leadingWidget,
            trailing: trailingWidget,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class NotesOverlay extends StatefulWidget {
  final List<String> notes;

  const NotesOverlay({super.key, required this.notes});

  @override
  State<NotesOverlay> createState() => _NotesOverlayState();
}

class _NotesOverlayState extends State<NotesOverlay> {
  late List<bool> wasTappedOutside;

  @override
  void initState() {
    super.initState();

    wasTappedOutside = widget.notes.map((e) => false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPaddingX,
        vertical: 48.0,
      ),
      child: GestureDetector(
        onTap: () {
          Future.delayed(30.ms, () {
            if (wasTappedOutside.reduce((value, element) => value && element) &&
                context.mounted) {
              Navigator.of(context).pop();
            }
          });
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TapRegion(
                onTapInside: (event) {
                  setState(() {
                    wasTappedOutside[index] = false;
                  });
                },
                onTapOutside: (event) {
                  setState(() {
                    wasTappedOutside[index] = true;
                  });
                },
                child: Note(
                  child: Text(widget.notes[index]),
                ),
              ),
            );
          },
          itemCount: widget.notes.length,
        ),
      ),
    );
  }
}
