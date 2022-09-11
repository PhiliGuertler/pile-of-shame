import 'package:flutter/material.dart';
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
      ageRestriction: AgeRestriction.usk0),
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
      platform: 'Nintendo Switch',
      title: 'Xenoblade Chronicles 4',
      price: 46.99,
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
    int numItems = games.length * 2 - 1;
    numItems = numItems < 0 ? 0 : numItems + 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hauptseite'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: numItems,
        itemBuilder: (context, i) {
          if (i == numItems - 1) {
            return GameListSummary(games: games);
          }
          if (i.isOdd) {
            return const Divider();
          }

          var currentGame = games[(i ~/ 2)];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameDetails(game: currentGame)));
            },
            child: GameListItem(
              game: currentGame,
            ),
          );
        },
      ),
    );
  }
}
