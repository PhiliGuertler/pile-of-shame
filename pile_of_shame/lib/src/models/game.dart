import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:quiver/core.dart';
import 'package:uuid/uuid.dart';
import 'age_restrictions.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  String uuid;

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

  /// Stores the last data at which this object was updated
  DateTime? lastUpdated;

  // ######################################################################## //
  // ### Scraped data ####################################################### //
  // ######################################################################## //

  /// release date of the game
  DateTime? releaseDate;

  /// the metacritic score (critics) at the time of scraping
  int? onlineScore;

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
    this.onlineScore,
    this.backgroundImage,
    this.coverImage,
    this.externalGameId,
    this.lastUpdated,
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
    this.onlineScore,
    this.backgroundImage,
    this.coverImage,
    this.externalGameId,
    this.lastUpdated,
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
        onlineScore = other.onlineScore,
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

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  @override
  bool operator ==(Object other) {
    return (other is Game) ? (uuid == other.uuid) : false;
  }

  @override
  int get hashCode {
    return hash2(uuid, title);
  }
}
