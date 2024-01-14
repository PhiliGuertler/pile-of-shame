import 'package:flutter/material.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';

class AgeRatingTextDisplay extends StatelessWidget {
  final USK usk;

  const AgeRatingTextDisplay({super.key, required this.usk});

  AgeRatingTextDisplay.fromGame({super.key, required Game game})
      : usk = game.usk;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: usk.color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Center(
          child: Text(
            usk.toRatedString(AppLocalizations.of(context)!),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: usk.color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
