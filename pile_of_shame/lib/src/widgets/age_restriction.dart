import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/age_restrictions.dart';

import '../models/game.dart';

class AgeRestrictionWidget extends StatelessWidget {
  const AgeRestrictionWidget({
    super.key,
    required AgeRestriction ageRestriction,
  }) : _ageRestriction = ageRestriction;

  AgeRestrictionWidget.fromGame({super.key, required Game game})
      : _ageRestriction = game.ageRestriction ?? AgeRestriction.unknown;

  final AgeRestriction _ageRestriction;

  @override
  Widget build(BuildContext context) {
    final ageRestrictionColor =
        AgeRestrictions.getAgeRestictionColor(_ageRestriction);
    final ageRestrictionText =
        AgeRestrictions.getAgeRestrictionText(_ageRestriction);
    return SizedBox(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ColoredBox(
          color: ageRestrictionColor.withOpacity(0.5),
          child: Center(
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(1 / 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ColoredBox(
                    color: ageRestrictionColor,
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(-1 / 8),
                      child: Center(
                        child: Text(
                          ageRestrictionText,
                          style: TextStyle(
                            color: ageRestrictionColor.computeLuminance() > 0.5
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
