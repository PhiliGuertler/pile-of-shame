import 'package:flutter/material.dart';
import 'age_restrictions.dart';

class Game {
  /// the game's title
  String title;

  /// the platform(s) on which the game was purchased/played
  String platform;

  /// the amount of money that was actually payed for the game
  double? price;

  /// the game's age restriction
  AgeRestriction? ageRestriction;

  /// signifies if the game is a favourite game or not
  bool isFavourite;

  Game(
      {required this.platform,
      required this.title,
      this.isFavourite = false,
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
