import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:quiver/core.dart';
import 'package:uuid/uuid.dart';
import 'age_restrictions.dart';

class Game {
  final String uuid;

  /// the game's title
  String title;

  /// the platform(s) on which the game was purchased/played
  List<String> platforms;

  /// the game's current state of playing
  GameState gameState;

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

  /// release date of the game
  DateTime? releaseDate;

  /// the metacritic score (critics) at the time of scraping
  int? metacriticScore;

  /// background image for the game
  String? backgroundImage;

  /// cover image of the game
  String? coverImage;

  /// the game's id in an external database like RAWG.io or IGDB
  int? externalGameId;

  Game({
    required this.title,
    required this.platforms,
    required this.gameState,
    this.price,
    this.ageRestriction,
    this.isFavourite = false,
    this.notes,
    this.releaseDate,
    this.metacriticScore,
    this.backgroundImage,
    this.coverImage,
    this.externalGameId,
  }) : uuid = const Uuid().v4();

  Game.withUuid({
    required this.uuid,
    required this.title,
    required this.platforms,
    required this.gameState,
    this.price,
    this.ageRestriction,
    this.isFavourite = false,
    this.notes,
    this.releaseDate,
    this.metacriticScore,
    this.backgroundImage,
    this.coverImage,
    this.externalGameId,
  });

  Game.from(Game other)
      : uuid = other.uuid,
        gameState = other.gameState,
        title = other.title,
        platforms = other.platforms,
        price = other.price,
        ageRestriction = other.ageRestriction,
        isFavourite = other.isFavourite,
        notes = other.notes,
        releaseDate = other.releaseDate,
        metacriticScore = other.metacriticScore,
        backgroundImage = other.backgroundImage,
        coverImage = other.coverImage,
        externalGameId = other.externalGameId;

  Color getAgeRestictionColor() {
    return AgeRestrictions.getAgeRestictionColor(
        ageRestriction ?? AgeRestriction.unknown);
  }

  String getAgeRestrictionText() {
    return AgeRestrictions.getAgeRestrictionText(
        ageRestriction ?? AgeRestriction.unknown);
  }

  Game.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        gameState = json['gameState'] != null
            ? GameState.values[json['gameState']]
            : GameState.currentlyPlaying,
        title = json['title'],
        platforms = List<String>.from(json['platforms'] as List),
        price = json['price'],
        ageRestriction = json['ageRestriction'] != null
            ? AgeRestriction.values[json['ageRestriction']]
            : null,
        isFavourite = json['isFavourite'],
        notes = json['notes'],
        releaseDate = json['releaseDate'] != null
            ? DateTime.parse(json['releaseDate'])
            : null,
        metacriticScore = json['metacriticScore'],
        backgroundImage = json['backgroundImage'],
        coverImage = json['coverImage'],
        externalGameId = json['externalGameId'] ?? json['rawgGameId'];

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'gameState': gameState.index,
        'title': title.trim(),
        'platforms': platforms,
        'price': price,
        'ageRestriction': ageRestriction?.index,
        'isFavourite': isFavourite,
        'notes': notes?.trim(),
        'releaseDate': releaseDate?.toIso8601String(),
        'metacriticScore': metacriticScore,
        'backgroundImage': backgroundImage,
        'coverImage': coverImage,
        'externalGameId': externalGameId,
      };

  @override
  bool operator ==(Object other) {
    return (other is Game) ? (uuid == other.uuid) : false;
  }

  @override
  int get hashCode {
    return hash2(uuid, title);
  }
}
