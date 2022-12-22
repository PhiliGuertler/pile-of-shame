// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      title: json['title'] as String,
      platforms: (json['platforms'] as List<dynamic>)
          .map((e) => $enumDecode(_$PlatformEnumMap, e))
          .toList(),
      playStatus: $enumDecode(_$PlayStatusEnumMap, json['playStatus']),
      price: (json['price'] as num?)?.toDouble(),
      ageRestriction:
          $enumDecodeNullable(_$AgeRestrictionEnumMap, json['ageRestriction']),
      isFavourite: json['isFavourite'] as bool? ?? false,
      notes: json['notes'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      onlineScore: json['onlineScore'] as int?,
      backgroundImage: json['backgroundImage'] == null
          ? null
          : Uri.parse(json['backgroundImage'] as String),
      coverImage: json['coverImage'] == null
          ? null
          : Uri.parse(json['coverImage'] as String),
      externalGameId: json['externalGameId'] as int?,
    )..uuid = json['uuid'] as String;

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'platforms':
          instance.platforms.map((e) => _$PlatformEnumMap[e]!).toList(),
      'playStatus': _$PlayStatusEnumMap[instance.playStatus]!,
      'price': instance.price,
      'ageRestriction': _$AgeRestrictionEnumMap[instance.ageRestriction],
      'isFavourite': instance.isFavourite,
      'notes': instance.notes,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'onlineScore': instance.onlineScore,
      'backgroundImage': instance.backgroundImage?.toString(),
      'coverImage': instance.coverImage?.toString(),
      'externalGameId': instance.externalGameId,
    };

const _$PlatformEnumMap = {
  Platform.pcDefault: 0,
  Platform.pcSteam: 1,
  Platform.pcGog: 2,
  Platform.pcUPlay: 3,
  Platform.pcEpic: 4,
  Platform.pcTwitch: 5,
  Platform.pcOrigin: 6,
  Platform.pcXBox: 7,
  Platform.vrSteam: 8,
  Platform.vrOculus: 9,
  Platform.playstation1: 10,
  Platform.playstation2: 11,
  Platform.playstation3: 12,
  Platform.playstation4: 13,
  Platform.playstation5: 15,
  Platform.playstationPortable: 17,
  Platform.playstationVita: 18,
  Platform.playstationVR: 19,
  Platform.playstationVR2: 20,
  Platform.xboxOriginal: 21,
  Platform.xbox360: 22,
  Platform.xboxOne: 23,
  Platform.xboxSeriesXS: 24,
  Platform.nintendoNES: 25,
  Platform.nintendoSNES: 26,
  Platform.nintendo64: 27,
  Platform.nintendoGameCube: 28,
  Platform.nintendoWii: 29,
  Platform.nintendoWiiU: 31,
  Platform.nintendoSwitch: 32,
  Platform.gameBoy: 34,
  Platform.gameBoyColor: 35,
  Platform.gameBoyAdvance: 36,
  Platform.nintendoDS: 37,
  Platform.nintendo3DS: 39,
};

const _$PlayStatusEnumMap = {
  PlayStatus.none: 0,
  PlayStatus.currentlyPlaying: 1,
  PlayStatus.onPileOfShame: 2,
  PlayStatus.completed100Percent: 3,
  PlayStatus.completed: 4,
  PlayStatus.cancelled: 5,
  PlayStatus.onWishList: 6,
  PlayStatus.unfinishable: 7,
};

const _$AgeRestrictionEnumMap = {
  AgeRestriction.usk0: 0,
  AgeRestriction.usk6: 1,
  AgeRestriction.usk12: 2,
  AgeRestriction.usk16: 3,
  AgeRestriction.usk18: 4,
  AgeRestriction.unknown: 5,
};
