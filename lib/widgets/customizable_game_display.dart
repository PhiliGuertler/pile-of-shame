import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/custom_game_display.dart';
import 'package:pile_of_shame/providers/database/database_provider.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/age_rating_text_display.dart';
import 'package:pile_of_shame/widgets/game_platform_icon.dart';
import 'package:pile_of_shame/widgets/last_modified_display.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/play_status_icon.dart';
import 'package:pile_of_shame/widgets/price_and_last_modified_display.dart';
import 'package:pile_of_shame/widgets/price_only_display.dart';
import 'package:pile_of_shame/widgets/progressing_icon.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_image_container.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class LeadingTrailingGameDisplaySlot extends StatelessWidget {
  const LeadingTrailingGameDisplaySlot({
    super.key,
    required this.game,
    required this.variant,
  });

  final Game game;
  final GameDisplayLeadingTrailing variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case GameDisplayLeadingTrailing.ageRatingIcon:
        return USKLogo.fromGame(game: game);
      case GameDisplayLeadingTrailing.platformIcon:
        return GamePlatformIcon.fromGame(game: game);
      case GameDisplayLeadingTrailing.playStatusIcon:
        return PlayStatusIcon.fromGame(
          game: game,
        );
      case GameDisplayLeadingTrailing.priceAndLastModified:
        return PriceAndLastModifiedDisplay.fromGame(
          game: game,
        );
      case GameDisplayLeadingTrailing.priceOnly:
        return PriceOnlyDisplay.fromGame(
          game: game,
        );
      case GameDisplayLeadingTrailing.lastModifiedOnly:
        return LastModifiedDisplay.fromGame(
          game: game,
        );
      case GameDisplayLeadingTrailing.none:
        return const Placeholder();
    }
  }
}

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
    final currencyFormatter =
        ref.watch(currencyFormatProvider(Localizations.localeOf(context)));

    final settings = ref.watch(customizeGameDisplaysProvider);

    Widget? leadingWidget;
    Widget? trailingWidget;
    Widget? secondaryWidget;

    settings.when(
      data: (settings) {
        switch (settings.leading) {
          case GameDisplayLeadingTrailing.none:
            leadingWidget = null;
          default:
            leadingWidget = LeadingTrailingGameDisplaySlot(
              game: game,
              variant: settings.leading,
            );
        }
        switch (settings.trailing) {
          case GameDisplayLeadingTrailing.none:
            trailingWidget = null;
          default:
            trailingWidget = LeadingTrailingGameDisplaySlot(
              game: game,
              variant: settings.trailing,
            );
        }
        switch (settings.secondary) {
          case GameDisplaySecondary.statusText:
            secondaryWidget = PlayStatusDisplay.fromGame(game: game);
          case GameDisplaySecondary.ageRatingText:
            secondaryWidget = AgeRatingTextDisplay.fromGame(game: game);
          case GameDisplaySecondary.platformText:
            secondaryWidget = Text(
              game.platform.localizedName(AppLocalizations.of(context)!),
            );
          case GameDisplaySecondary.price:
            secondaryWidget = Text(
              game.wasGifted && game.fullPrice() < 0.01
                  ? AppLocalizations.of(context)!.gift
                  : currencyFormatter.format(game.fullPrice()),
            );
          case GameDisplaySecondary.none:
            secondaryWidget = null;
        }
      },
      error: (error, stackTrace) {},
      loading: () {
        trailingWidget = const ImageContainerSkeleton();
        leadingWidget = const ImageContainerSkeleton();
        secondaryWidget = const Skeleton();
      },
    );

    const double favoriteSize = 32;

    final List<String> notes = [];
    if (game.notes != null && game.notes!.isNotEmpty) {
      notes.add(game.notes!);
    }
    for (final dlc in game.dlcs) {
      if (dlc.notes != null && dlc.notes!.isNotEmpty) {
        notes.add(dlc.notes!);
      }
    }

    return SwipeToTrigger(
      triggerOffset: 0.3,
      rightWidget: (triggerProgress) {
        final double triggerOvershoot =
            (triggerProgress - 1.0).clamp(0, double.infinity);
        final double untilTrigger = triggerProgress.clamp(0.0, 1.0);
        return ColoredBox(
          color: Colors.red,
          child: Transform.scale(
            scale: 1.0 + triggerOvershoot,
            child: ProgressingIcon(
              progress: untilTrigger,
              icon: game.isFavorite ? Icons.heart_broken_sharp : Icons.favorite,
              backgroundColor: Colors.red,
            ),
          ),
        );
      },
      onTriggerRight: () async {
        final updatedGame = game.copyWith(isFavorite: !game.isFavorite);
        final database = await ref.read(databaseProvider.future);
        final update = database.updateGame(updatedGame.id, updatedGame);

        await ref.read(databaseStorageProvider).persistDatabase(update);
      },
      leftWidget: notes.isNotEmpty
          ? (triggerProgress) {
              final double triggerOvershoot =
                  (triggerProgress - 1.0).clamp(0, double.infinity);
              final double untilTrigger = triggerProgress.clamp(0.0, 1.0);
              return ColoredBox(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Transform.scale(
                  scale: 1.0 + triggerOvershoot,
                  child: ProgressingIcon(
                    progress: untilTrigger,
                    icon: Icons.open_in_full,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
              );
            }
          : null,
      onTriggerLeft: () {
        showDialog(
          context: context,
          builder: (context) {
            return NotesOverlay(
              notes: notes,
            );
          },
        );
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Positioned(
            right: -favoriteSize * 0.4,
            child: Icon(
              Icons.favorite,
              size: favoriteSize,
              color: Colors.red,
            ),
          )
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
                  label: AppLocalizations.of(context)!.notes,
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
