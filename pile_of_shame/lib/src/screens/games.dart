import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';

import '../widgets/game_list_summary.dart';

enum AgeRestriction {
  unknown,
  usk0,
  usk6,
  usk12,
  usk16,
  usk18,
}

class AgeRestrictions {
  static Color getAgeRestictionColor(AgeRestriction ageRestriction) {
    switch (ageRestriction) {
      case AgeRestriction.usk0:
        return Colors.white;
      case AgeRestriction.usk6:
        return Colors.yellow;
      case AgeRestriction.usk12:
        return Colors.green;
      case AgeRestriction.usk16:
        return Colors.blue;
      case AgeRestriction.usk18:
        return Colors.red;
      case AgeRestriction.unknown:
      default:
        return Colors.grey;
    }
  }

  static String getAgeRestrictionText(AgeRestriction ageRestriction) {
    switch (ageRestriction) {
      case AgeRestriction.usk0:
        return "0";
      case AgeRestriction.usk6:
        return "6";
      case AgeRestriction.usk12:
        return "12";
      case AgeRestriction.usk16:
        return "16";
      case AgeRestriction.usk18:
        return "18";
      case AgeRestriction.unknown:
      default:
        return "???";
    }
  }
}

class Game {
  String platform;
  String title;
  double? price;
  AgeRestriction? ageRestriction;

  Game(
      {required this.platform,
      required this.title,
      this.price,
      this.ageRestriction});

  Color getAgeRestictionColor() {
    return AgeRestrictions.getAgeRestictionColor(
        ageRestriction ?? AgeRestriction.unknown);
  }

  String getAgeRestrictionText() {
    return AgeRestrictions.getAgeRestrictionText(
        ageRestriction ?? AgeRestriction.unknown);
  }
}

List<Game> games = [
  Game(
      platform: 'Nintendo Switch',
      title: 'Xenoblade Chronicles Definitive Edition',
      price: 30,
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

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: numItems,
      itemBuilder: (context, i) {
        if (i == numItems - 1) {
          return GameListSummary(games: games);
        }
        if (i.isOdd) {
          return const Divider();
        }
        return GameListItem(
          game: games[(i ~/ 2)],
        );
      },
    );
  }
}
