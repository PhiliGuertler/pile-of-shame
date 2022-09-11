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

  // ######################################################################## //
  // ### Scraped data ####################################################### //
  // ######################################################################## //

  /// if true, this game's additional infos were scraped via RAWG.io
  bool wasScraped;

  /// release date of the game
  DateTime? releaseDate;

  /// the metacritic score (critics) at the time of scraping
  int? metacriticScore;

  /// background image for the game
  String? backgroundImage;

  /// the game's id in RAWG.io's database
  int? rawgGameId;

  Game({
    required this.platform,
    required this.title,
    this.isFavourite = false,
    this.wasScraped = false,
    this.price,
    this.ageRestriction,
    this.releaseDate,
    this.metacriticScore,
    this.backgroundImage,
    this.rawgGameId,
  });

  Color getAgeRestictionColor() {
    return AgeRestrictions.getAgeRestictionColor(
        ageRestriction ?? AgeRestriction.unknown);
  }

  String getAgeRestrictionText() {
    return AgeRestrictions.getAgeRestrictionText(
        ageRestriction ?? AgeRestriction.unknown);
  }
}
