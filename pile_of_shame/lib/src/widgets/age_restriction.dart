import 'package:flutter/material.dart';

import '../screens/games.dart';

class AgeRestrictionWidget extends StatelessWidget {
  const AgeRestrictionWidget({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ColoredBox(
          color: game.getAgeRestictionColor().withOpacity(0.5),
          child: Center(
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(1 / 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ColoredBox(
                    color: game.getAgeRestictionColor(),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(-1 / 8),
                      child: Center(
                        child: Text(
                          game.getAgeRestrictionText(),
                          style: TextStyle(
                            color: game
                                        .getAgeRestictionColor()
                                        .computeLuminance() >
                                    0.5
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
