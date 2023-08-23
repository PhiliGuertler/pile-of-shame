import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/format_provider.dart';
import 'package:pile_of_shame/providers/game_provider.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:pile_of_shame/widgets/image_container.dart';
import 'package:pile_of_shame/widgets/play_status_display.dart';
import 'package:pile_of_shame/widgets/segmented_action_card.dart';
import 'package:pile_of_shame/widgets/skeletons/skeleton_list_tile.dart';
import 'package:pile_of_shame/widgets/slivers/sliver_fancy_image_app_bar.dart';
import 'package:pile_of_shame/widgets/usk_logo.dart';

class GameDetailsScreen extends ConsumerStatefulWidget {
  final String gameId;

  const GameDetailsScreen({super.key, required this.gameId});

  @override
  ConsumerState<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends ConsumerState<GameDetailsScreen> {
  bool shouldShowPriceSum = true;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameByIdProvider(widget.gameId));
    final dateFormatter = ref.watch(dateFormatProvider);
    final currencyFormatter = ref.watch(currencyFormatProvider(context));

    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(gamesProvider.future),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverFancyImageAppBar(
                borderRadius: -defaultBorderRadius * 2,
                imagePath: game.when(
                  data: (game) => game.platform.controllerLogoPath(context),
                  error: (error, stackTrace) =>
                      GamePlatform.unknown.controllerLogoPath(context),
                  loading: () =>
                      GamePlatform.unknown.controllerLogoPath(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      debugPrint('TODO: Implement editing');
                    },
                  )
                ],
                title: Text(
                  game.when(
                    data: (game) => game.name,
                    error: (error, stackTrace) => 'Error',
                    loading: () => 'Loading',
                  ),
                ),
              ),
              SliverList.list(
                children: [
                  game.when(
                    data: (game) => ListTile(
                      leading: ImageContainer(
                        child: game.coverArt != null
                            ? FadeInImage.assetNetwork(
                                width: double.infinity,
                                height: double.infinity,
                                fadeInDuration:
                                    const Duration(milliseconds: 150),
                                fadeOutDuration:
                                    const Duration(milliseconds: 150),
                                fit: BoxFit.cover,
                                placeholderFit: BoxFit.cover,
                                placeholder: game.platform.iconPath,
                                image: game.coverArt!,
                              )
                            : null,
                      ),
                      title: Text(game.name),
                      subtitle: PlayStatusDisplay(playStatus: game.status),
                    ),
                    error: (error, stackTrace) =>
                        Text("TODO: Handle error: ${error.toString()}"),
                    loading: () => const Text("TODO: Display Loading"),
                  ),
                  ...game.when(
                    data: (game) => [
                      ListTile(
                        title: Text(shouldShowPriceSum
                            ? AppLocalizations.of(context)!.priceWithDLCs
                            : AppLocalizations.of(context)!.price),
                        subtitle: Text(
                          currencyFormatter.format(shouldShowPriceSum
                              ? game.fullPrice()
                              : game.price),
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
                        title: Text(AppLocalizations.of(context)!.platform),
                        subtitle: Text(game.platform.name),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(context)!.lastModified),
                        subtitle: Text(dateFormatter.format(game.lastModified)),
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
                        SegmentedActionCard(
                          items: game.dlcs
                              .map(
                                (dlc) => SegmentedActionCardItem(
                                  title: Text(dlc.name),
                                  subtitle:
                                      PlayStatusDisplay(playStatus: dlc.status),
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 48.0)
                    ],
                    loading: () => [
                      const ListTileSkeleton(hasLeading: false),
                      const ListTileSkeleton(hasLeading: false),
                      const ListTileSkeleton(hasLeading: false),
                      const ListTileSkeleton(hasLeading: false),
                    ],
                    error: (error, stackTrace) => [],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
