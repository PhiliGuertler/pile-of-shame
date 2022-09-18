import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/screens/game_addition.dart';
import 'package:pile_of_shame/src/utils/game_filters.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';

import '../models/game.dart';
import '../widgets/game_list_summary.dart';
import '../widgets/popup_menu_title.dart';
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
      setState(() {
        _games = _filters.applyFilters(value);
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
      appBar: AppBar(
        title: const Text('Hauptseite'),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGameScreen(),
                ),
              );
              refresh();
            },
            icon: const Icon(Icons.add_circle_outline),
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
              icon: const Icon(Icons.filter_list),
              itemBuilder: (context) => [
                    const PopupMenuTitle(title: 'Sortieren nach'),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.byDateOfAddition,
                      checked: _filters.sortStrategy ==
                          SortStrategy.byDateOfAddition,
                      child: const Text('Hinzufügedatum'),
                    ),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.byAlphabet,
                      checked: _filters.sortStrategy == SortStrategy.byAlphabet,
                      child: const Text('Alphabet'),
                    ),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.byAgeRestriction,
                      checked: _filters.sortStrategy ==
                          SortStrategy.byAgeRestriction,
                      child: const Text('Altersbeschränkung'),
                    ),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.byPrice,
                      checked: _filters.sortStrategy == SortStrategy.byPrice,
                      child: const Text('Preis'),
                    ),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.byPlatform,
                      checked: _filters.sortStrategy == SortStrategy.byPlatform,
                      child: const Text('Plattform'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuTitle(title: 'Reihenfolge'),
                    CheckedPopupMenuItem<SortStrategy>(
                      value: SortStrategy.none,
                      checked: !_filters.isDescending,
                      child: const Text('aufsteigend'),
                    ),
                  ]),
          IconButton(
            onPressed: () {
              debugPrint('TODO: Import/Export files');
              Storage().writeGames(_games);
            },
            icon: const Icon(Icons.import_export),
          ),
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: ListTile.divideTiles(
                context: context,
                tiles: _games.map(
                  (game) => InkWell(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GameDetails(gameUuid: game.uuid)));
                      refresh();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: GameListItem(
                        game: game,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: const Divider(
                thickness: 3,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  right: 8.0, left: 8.0, top: 16.0, bottom: 32.0),
              child: GameListSummary(games: _games),
            ),
          ],
        ),
      ),
    );
  }
}
