import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'age_restrictions.dart';
import 'package:collection/collection.dart';

class Game {
  /// the game's title
  String title;

  /// the platform(s) on which the game was purchased/played
  List<String> platforms;

  /// the amount of money that was actually payed for the game
  double? price;

  /// the game's age restriction
  AgeRestriction? ageRestriction;

  /// signifies if the game is a favourite game or not
  bool isFavourite;

  /// Stores user-defined notes for the game, e.g. if the game was gifted,
  /// or if DLCs are part of the price
  String? notes;

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
    required this.title,
    required this.platforms,
    this.price,
    this.ageRestriction,
    this.isFavourite = false,
    this.notes,
    this.wasScraped = false,
    this.releaseDate,
    this.metacriticScore,
    this.backgroundImage,
    this.rawgGameId,
  });

  Game.from(Game other)
      : title = other.title,
        platforms = other.platforms,
        price = other.price,
        ageRestriction = other.ageRestriction,
        isFavourite = other.isFavourite,
        notes = other.notes,
        wasScraped = other.wasScraped,
        releaseDate = other.releaseDate,
        metacriticScore = other.metacriticScore,
        backgroundImage = other.backgroundImage,
        rawgGameId = other.rawgGameId;

  Color getAgeRestictionColor() {
    return AgeRestrictions.getAgeRestictionColor(
        ageRestriction ?? AgeRestriction.unknown);
  }

  String getAgeRestrictionText() {
    return AgeRestrictions.getAgeRestrictionText(
        ageRestriction ?? AgeRestriction.unknown);
  }

  Game.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        platforms = List<String>.from(json['platforms'] as List),
        price = json['price'],
        ageRestriction = json['ageRestriction'] != null
            ? AgeRestriction.values[json['ageRestriction']]
            : null,
        isFavourite = json['isFavourite'],
        notes = json['notes'],
        wasScraped = json['wasScraped'],
        releaseDate = json['releaseDate'] != null
            ? DateTime.parse(json['releaseDate'])
            : null,
        metacriticScore = json['metacriticScore'],
        backgroundImage = json['backgroundImage'],
        rawgGameId = json['rawgGameId'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'platforms': platforms,
        'price': price,
        'ageRestriction': ageRestriction?.index,
        'isFavourite': isFavourite,
        'notes': notes,
        'wasScraped': wasScraped,
        'releaseDate': releaseDate?.toIso8601String(),
        'metacriticScore': metacriticScore,
        'backgroundImage': backgroundImage,
        'rawgGameId': rawgGameId,
      };

  @override
  bool operator ==(Object other) {
    final equalizer = const ListEquality().equals;
    return (other is Game)
        ? (title == other.title &&
            equalizer(platforms, other.platforms) &&
            price == other.price &&
            ageRestriction == other.ageRestriction &&
            isFavourite == other.isFavourite &&
            notes == other.notes &&
            wasScraped == other.wasScraped &&
            releaseDate == other.releaseDate &&
            metacriticScore == other.metacriticScore &&
            backgroundImage == other.backgroundImage &&
            rawgGameId == other.rawgGameId)
        : false;
  }

  @override
  int get hashCode {
    return hash2(title, platforms);
  }
}
