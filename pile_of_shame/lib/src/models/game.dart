import 'package:flutter/material.dart';
import 'age_restrictions.dart';

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
