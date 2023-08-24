import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/widgets/image_container.dart';

import '../models/game.dart';

class USKLogo extends StatelessWidget {
  const USKLogo({
    super.key,
    required this.ageRestriction,
  });

  USKLogo.fromGame({super.key, required Game game}) : ageRestriction = game.usk;

  final USK ageRestriction;

  @override
  Widget build(BuildContext context) {
    final ageRestrictionColor = ageRestriction.color;
    final ageRestrictionText = ageRestriction.age.toString();
    return SizedBox(
      width: ImageContainer.imageSize,
      height: ImageContainer.imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ColoredBox(
          color: ageRestrictionColor.withOpacity(0.5),
          child: Center(
            child: Transform.rotate(
              angle: pi * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: ImageContainer.imageSize * 0.75,
                  height: ImageContainer.imageSize * 0.75,
                  child: ColoredBox(
                    color: ageRestrictionColor,
                    child: Transform.rotate(
                      angle: -pi * 0.25,
                      child: Center(
                        child: Text(
                          ageRestrictionText,
                          style: TextStyle(
                              color:
                                  ageRestrictionColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
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
