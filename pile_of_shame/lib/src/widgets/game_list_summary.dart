import 'package:flutter/cupertino.dart';

import '../screens/games.dart';

class GameListSummary extends StatelessWidget {
  const GameListSummary({super.key, required this.games});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    double priceSum = games
        .map((game) => game.price ?? 0)
        .reduce((value, price) => value + price);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${games.length} Einträge'),
        Text('Summe ${priceSum.toStringAsFixed(2)} €')
      ],
    );
  }
}
