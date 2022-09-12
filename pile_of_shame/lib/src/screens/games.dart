import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/persistance/games_storage.dart';
import 'package:pile_of_shame/src/screens/game_addition.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';

import '../models/age_restrictions.dart';
import '../models/game.dart';
import '../widgets/game_list_summary.dart';
import 'game_details.dart';

List<Game> games = [
  Game(
    platform: 'Nintendo Switch',
    title: 'Xenoblade Chronicles Definitive Edition',
    price: 30,
    isFavourite: true,
    ageRestriction: AgeRestriction.usk0,
    // backgroundImage:
    // 'https://www.futurezone.de/wp-content/uploads/sites/11/2022/05/weltraum-milchstrasse.jpg',
    // metacriticScore: 1111,
    // wasScraped: true,
  ),
  Game(
      platform: 'Nintendo Switch',
      title: 'Xenoblade Chronicles 2',
      price: 46.99,
      ageRestriction: AgeRestriction.usk6),
  Game(
      platform: 'Nintendo Switch',
      title: 'Xenoblade Chronicles 3',
      price: 56.86,
      ageRestriction: AgeRestriction.usk12),
  Game(
      platform: 'Playstation 2',
      title: 'SSX 3',
      price: 13.68,
      ageRestriction: AgeRestriction.usk16),
  Game(
      platform: 'Steam',
      title: 'Bayonetta',
      ageRestriction: AgeRestriction.usk18),
  Game(
    platform: 'Gog',
    title: 'Irgendwas, kp',
  ),
];

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hauptseite'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddGameScreen()));
              },
              icon: const Icon(Icons.add_circle_outline)),
          IconButton(
              onPressed: () {
                debugPrint('TODO: Filter list');
              },
              icon: const Icon(Icons.filter_list)),
          IconButton(
            onPressed: () {
              debugPrint('TODO: Import/Export files');
              GamesStorage().writeGames(games);
            },
            icon: const Icon(Icons.import_export),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: games.map(
                (game) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameDetails(game: game)));
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
            padding: const EdgeInsets.all(8.0),
            child: GameListSummary(games: games),
          ),
        ],
        ),
      ),
    );
  }
}
