import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/screens/game_addition.dart';
import 'package:pile_of_shame/src/utils/game_filters.dart';
import 'package:pile_of_shame/src/widgets/game_displays/game_list_item.dart';

import '../models/game.dart';
import '../models/game_status.dart';
import '../widgets/game_list_summary.dart';
import '../widgets/popup_menu_title.dart';
import '../widgets/selected_text_style.dart';
import 'game_details.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Game> _games = [];

  GameFilters _filters = GameFilters();

  void refresh() {
    Storage().readGames().then((value) {
      List<Game> filteredGames = _filters.filter(value);
      setState(() {
        _games = filteredGames;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "add_game_fab",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGameScreen(),
            ),
          );
          refresh();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Alle Spiele'),
        actions: [
          PopupMenuButton(
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
                              child: Text(_filters.platformFilter?.name ??
                                  'Platform wählen...'),
                            ),
                            const Icon(Icons.arrow_right, size: 30.0),
                          ],
                        ),
                      ),
                      onSelected: (GamePlatform value) {
                        if (value.name == 'None') {
                          _filters.platformFilter = null;
                        } else {
                          _filters.platformFilter = value;
                        }
                        refresh();
                        Navigator.pop(context);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: GamePlatform(
                              name: 'None',
                              abbreviation: 'None',
                              color: Colors.black,
                              rawgId: -1),
                          child: Text('Filter entfernen'),
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
                              child: Text(_filters.ageRestrictionFilter != null
                                  ? 'USK ${AgeRestrictions.getAgeRestrictionText(_filters.ageRestrictionFilter!)}'
                                  : 'Altersbeschränkung wählen...'),
                            ),
                            const Icon(Icons.arrow_right, size: 30.0),
                          ],
                        ),
                      ),
                      onSelected: (AgeRestriction value) {
                        if (value == AgeRestriction.none) {
                          _filters.ageRestrictionFilter = null;
                        } else {
                          _filters.ageRestrictionFilter = value;
                        }
                        refresh();
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
                              child: Text(_filters.gameStateFilter != null
                                  ? GameStates.gameStateToString(
                                      _filters.gameStateFilter!)
                                  : 'Spiel-Status wählen...'),
                            ),
                            const Icon(Icons.arrow_right, size: 30.0),
                          ],
                        ),
                      ),
                      onSelected: (GameState value) {
                        if (value == GameState.none) {
                          _filters.gameStateFilter = null;
                        } else {
                          _filters.gameStateFilter = value;
                        }
                        refresh();
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
                          child: Text(GameStates.gameStateToString(
                              GameState.onPileOfShame)),
                        ),
                        PopupMenuItem(
                          value: GameState.onWishList,
                          child: Text(GameStates.gameStateToString(
                              GameState.onWishList)),
                        ),
                        PopupMenuItem(
                          value: GameState.completed100Percent,
                          child: Text(GameStates.gameStateToString(
                              GameState.completed100Percent)),
                        ),
                        PopupMenuItem(
                          value: GameState.completed,
                          child: Text(GameStates.gameStateToString(
                              GameState.completed)),
                        ),
                        PopupMenuItem(
                          value: GameState.cancelled,
                          child: Text(GameStates.gameStateToString(
                              GameState.cancelled)),
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
                              child: Text(_filters.isFavouriteFilter != null
                                  ? (_filters.isFavouriteFilter!
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
                          _filters.isFavouriteFilter = null;
                        } else {
                          _filters.isFavouriteFilter = value == 1;
                        }
                        refresh();
                        Navigator.pop(context);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 0, child: Text('Filter entfernen')),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                            value: 1, child: Text('Favorisiert')),
                        const PopupMenuItem(
                            value: 2, child: Text('Nicht Favorisiert')),
                      ],
                    ),
                  ),
                ]),
          ),
          PopupMenuButton<SortStrategy>(
            onSelected: (value) {
              final SortStrategy sortStrategy =
                  value == SortStrategy.none ? _filters.sortStrategy : value;
              final bool isDescending = value == SortStrategy.none
                  ? !_filters.isDescending
                  : _filters.isDescending;
              setState(() {
                _filters = GameFilters(
                    sortStrategy: sortStrategy, isDescending: isDescending);
              });
              refresh();
            },
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => [
              const PopupMenuTitle(title: 'Sortieren nach'),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byDateOfAddition,
                child: SelectedTextStyle(
                  text: 'Hinzufügedatum',
                  isSelected:
                      _filters.sortStrategy == SortStrategy.byDateOfAddition,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byAlphabet,
                child: SelectedTextStyle(
                  text: 'Alphabet',
                  isSelected: _filters.sortStrategy == SortStrategy.byAlphabet,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byAgeRestriction,
                child: SelectedTextStyle(
                  text: 'Altersbeschränkung',
                  isSelected:
                      _filters.sortStrategy == SortStrategy.byAgeRestriction,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byPrice,
                child: SelectedTextStyle(
                  text: 'Preis',
                  isSelected: _filters.sortStrategy == SortStrategy.byPrice,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byPlatform,
                child: SelectedTextStyle(
                  text: 'Plattform',
                  isSelected: _filters.sortStrategy == SortStrategy.byPlatform,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byFavourite,
                child: SelectedTextStyle(
                  text: 'Favoriten',
                  isSelected: _filters.sortStrategy == SortStrategy.byFavourite,
                ),
              ),
              PopupMenuItem<SortStrategy>(
                value: SortStrategy.byStatus,
                child: SelectedTextStyle(
                  text: 'Status',
                  isSelected: _filters.sortStrategy == SortStrategy.byStatus,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuTitle(title: 'Reihenfolge'),
              CheckedPopupMenuItem<SortStrategy>(
                value: SortStrategy.none,
                checked: !_filters.isDescending,
                child: const Text('aufsteigend'),
              ),
            ],
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () {
                  refresh();
                },
                value: 0,
                child: const ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Neu laden'),
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () async {
                  final bool wasSuccessful = await Storage().exportGames();
                  if (wasSuccessful) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Spiele erfolgreich exportiert'),
                      ),
                    );
                  }
                },
                value: 1,
                child: const ListTile(
                  leading: Icon(Icons.import_export),
                  title: Text('Spiele exportieren'),
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                onTap: () async {
                  List<Game> allGames = await Storage().importGames();
                  await Storage().writeGames(allGames);
                  refresh();
                },
                value: 2,
                child: const ListTile(
                  leading: Icon(Icons.import_export),
                  title: Text('Spiele importieren'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _games.length + 2,
        itemBuilder: (context, index) {
          if (index < _games.length) {
            final game = _games[index];
            return InkWell(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GameDetails(gameUuid: game.uuid)));
                refresh();
              },
              child: GameListItem(
                game: game,
              ),
            );
          } else if (index == _games.length) {
            return Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: const Divider(
                thickness: 3,
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 16.0, bottom: 100.0),
              child: GameListSummary(games: _games),
            );
          }
        },
      ),
    );
  }
}
