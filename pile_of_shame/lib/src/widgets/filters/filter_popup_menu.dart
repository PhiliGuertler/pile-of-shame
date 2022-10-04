import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/utils/game_filters.dart';

import '../../models/age_restrictions.dart';
import '../../models/game_platform.dart';
import '../../models/game_status.dart';

class FilterPopupMenu extends StatelessWidget {
  const FilterPopupMenu({
    super.key,
    required this.filters,
    required this.updateFilters,
  });

  final GameFilters filters;
  final void Function(GameFilters filters) updateFilters;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_list),
      itemBuilder: ((context) => [
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<GamePlatform>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(filters.platformFilter?.name ??
                            'Platform wählen...'),
                      ),
                      const Icon(Icons.arrow_right, size: 30.0),
                    ],
                  ),
                ),
                onSelected: (GamePlatform value) {
                  if (value.name == 'None') {
                    filters.platformFilter = null;
                  } else {
                    filters.platformFilter = value;
                  }
                  updateFilters(filters);
                  Navigator.pop(context);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: GamePlatform(
                      name: 'None',
                      abbreviation: 'None',
                      color: Colors.black,
                    ),
                    child: const Text('Filter entfernen'),
                  ),
                  const PopupMenuDivider(),
                  ...GamePlatforms.toList()
                      .map(
                        (platform) => PopupMenuItem(
                          value: platform,
                          child: Text(platform.name),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<AgeRestriction>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(filters.ageRestrictionFilter != null
                            ? 'USK ${AgeRestrictions.getAgeRestrictionText(filters.ageRestrictionFilter!)}'
                            : 'Altersbeschränkung wählen...'),
                      ),
                      const Icon(Icons.arrow_right, size: 30.0),
                    ],
                  ),
                ),
                onSelected: (AgeRestriction value) {
                  if (value == AgeRestriction.none) {
                    filters.ageRestrictionFilter = null;
                  } else {
                    filters.ageRestrictionFilter = value;
                  }
                  updateFilters(filters);
                  Navigator.pop(context);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: AgeRestriction.none,
                    child: Text('Filter entfernen'),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: AgeRestriction.unknown,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.unknown)}'),
                  ),
                  PopupMenuItem(
                    value: AgeRestriction.usk0,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.usk0)}'),
                  ),
                  PopupMenuItem(
                    value: AgeRestriction.usk6,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.usk6)}'),
                  ),
                  PopupMenuItem(
                    value: AgeRestriction.usk12,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.usk12)}'),
                  ),
                  PopupMenuItem(
                    value: AgeRestriction.usk16,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.usk16)}'),
                  ),
                  PopupMenuItem(
                    value: AgeRestriction.usk18,
                    child: Text(
                        'USK ${AgeRestrictions.getAgeRestrictionText(AgeRestriction.usk18)}'),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<GameState>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(filters.gameStateFilter != null
                            ? GameStates.gameStateToString(
                                filters.gameStateFilter!)
                            : 'Spiel-Status wählen...'),
                      ),
                      const Icon(Icons.arrow_right, size: 30.0),
                    ],
                  ),
                ),
                onSelected: (GameState value) {
                  if (value == GameState.none) {
                    filters.gameStateFilter = null;
                  } else {
                    filters.gameStateFilter = value;
                  }
                  updateFilters(filters);
                  Navigator.pop(context);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: GameState.none,
                    child: Text('Filter entfernen'),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: GameState.currentlyPlaying,
                    child: Text(GameStates.gameStateToString(
                        GameState.currentlyPlaying)),
                  ),
                  PopupMenuItem(
                    value: GameState.onPileOfShame,
                    child: Text(
                        GameStates.gameStateToString(GameState.onPileOfShame)),
                  ),
                  PopupMenuItem(
                    value: GameState.onWishList,
                    child: Text(
                        GameStates.gameStateToString(GameState.onWishList)),
                  ),
                  PopupMenuItem(
                    value: GameState.completed100Percent,
                    child: Text(GameStates.gameStateToString(
                        GameState.completed100Percent)),
                  ),
                  PopupMenuItem(
                    value: GameState.completed,
                    child:
                        Text(GameStates.gameStateToString(GameState.completed)),
                  ),
                  PopupMenuItem(
                    value: GameState.cancelled,
                    child:
                        Text(GameStates.gameStateToString(GameState.cancelled)),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              padding: EdgeInsets.zero,
              child: PopupMenuButton<int>(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(filters.isFavouriteFilter != null
                            ? (filters.isFavouriteFilter!
                                ? 'Favorisiert'
                                : 'Nicht Favorisiert')
                            : 'Favorisierung wählen...'),
                      ),
                      const Icon(Icons.arrow_right, size: 30.0),
                    ],
                  ),
                ),
                onSelected: (int value) {
                  if (value == 0) {
                    filters.isFavouriteFilter = null;
                  } else {
                    filters.isFavouriteFilter = value == 1;
                  }
                  updateFilters(filters);
                  Navigator.pop(context);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 0, child: Text('Filter entfernen')),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 1, child: Text('Favorisiert')),
                  const PopupMenuItem(
                      value: 2, child: Text('Nicht Favorisiert')),
                ],
              ),
            ),
          ]),
    );
  }
}
