import 'package:flutter/cupertino.dart';

import '../models/game.dart';

class GameListSummary extends StatelessWidget {
  const GameListSummary({super.key, required this.games});

  final List<Game> games;

  @override
  Widget build(BuildContext context) {
    double priceSum = 0;
    if (games.isNotEmpty) {
      games
          .map((game) => game.price ?? 0)
          .reduce((value, price) => value + price);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${games.length} Einträge'),
        Text('Summe ${priceSum.toStringAsFixed(2)} €')
      ],
    );
  }
}
