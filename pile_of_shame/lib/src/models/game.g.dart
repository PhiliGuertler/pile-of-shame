// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      title: json['title'] as String,
      platforms:
          (json['platforms'] as List<dynamic>).map((e) => e as String).toList(),
      gameState: $enumDecode(_$GameStateEnumMap, json['gameState']),
      price: (json['price'] as num?)?.toDouble(),
      ageRestriction:
          $enumDecodeNullable(_$AgeRestrictionEnumMap, json['ageRestriction']),
      isFavourite: json['isFavourite'] as bool? ?? false,
      notes: json['notes'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      onlineScore: json['onlineScore'] as int?,
      backgroundImage: json['backgroundImage'] as String?,
      coverImage: json['coverImage'] as String?,
      externalGameId: json['externalGameId'] as int?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'platforms': instance.platforms,
      'gameState': _$GameStateEnumMap[instance.gameState]!,
      'price': instance.price,
      'ageRestriction': _$AgeRestrictionEnumMap[instance.ageRestriction],
      'isFavourite': instance.isFavourite,
      'notes': instance.notes,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'onlineScore': instance.onlineScore,
      'backgroundImage': instance.backgroundImage,
      'coverImage': instance.coverImage,
      'externalGameId': instance.externalGameId,
    };

const _$GameStateEnumMap = {
  GameState.none: 0,
  GameState.currentlyPlaying: 1,
  GameState.onPileOfShame: 2,
  GameState.completed100Percent: 3,
  GameState.completed: 4,
  GameState.cancelled: 5,
  GameState.onWishList: 6,
  GameState.unfinishable: 7,
};

const _$AgeRestrictionEnumMap = {
  AgeRestriction.none: 0,
  AgeRestriction.unknown: 1,
  AgeRestriction.usk0: 2,
  AgeRestriction.usk6: 3,
  AgeRestriction.usk12: 4,
  AgeRestriction.usk16: 5,
  AgeRestriction.usk18: 6,
};
