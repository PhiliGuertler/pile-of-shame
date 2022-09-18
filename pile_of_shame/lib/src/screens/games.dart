import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/screens/game_addition.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';

import '../models/game.dart';
import '../widgets/game_list_summary.dart';
import 'game_details.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Game> _games = [];

  void refresh() {
    debugPrint('Initializing State of Games-Screen');
    Storage().readGames().then((value) {
      setState(() {
        _games = value;
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
          IconButton(
            onPressed: () {
              debugPrint('TODO: Filter list');
            },
            icon: const Icon(Icons.filter_list),
          ),
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
