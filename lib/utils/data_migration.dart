import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'data_migration.freezed.dart';
part 'data_migration.g.dart';

/// DLC without createdAt (before App-Version 0.6.1)
@freezed
class DLCv1 with _$DLCv1 {
  const factory DLCv1({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    @Default(0.0) double price,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(false) bool wasGifted,
  }) = _DLCv1;
  const DLCv1._();

  factory DLCv1.fromJson(Map<String, dynamic> json) => _$DLCv1FromJson(json);
}

/// Game without createdAt (before App-Version 0.6.1)
@freezed
class Gamev1 with _$Gamev1 {
  const factory Gamev1({
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required double price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<DLCv1> dlcs,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(false) bool wasGifted,
  }) = _Gamev1;
  const Gamev1._();

  factory Gamev1.fromJson(Map<String, dynamic> json) => _$Gamev1FromJson(json);
}

@freezed
class DLCv2 with _$DLCv2 {
  const factory DLCv2({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    @Default(0.0) double price,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(false) bool wasGifted,
  }) = _DLCv2;
  const DLCv2._();

  factory DLCv2.fromJson(Map<String, dynamic> json) => _$DLCv2FromJson(json);
}

@freezed
class Gamev2 with _$Gamev2 {
  const factory Gamev2({
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<DLCv2> dlcs,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(false) bool wasGifted,
  }) = _Gamev2;
  const Gamev2._();

  factory Gamev2.fromJson(Map<String, dynamic> json) => _$Gamev2FromJson(json);
}

/// GamesList of Gamev1 and DLCv1
@freezed
class GamesListv1 with _$GamesListv1 {
  const factory GamesListv1({
    required List<Gamev1> games,
  }) = _GamesListv1;
  const GamesListv1._();

  factory GamesListv1.fromJson(Map<String, dynamic> json) =>
      _$GamesListv1FromJson(json);
}

@freezed
class GamesListv2 with _$GamesListv2 {
  const factory GamesListv2({
    required List<Gamev2> games,
    // GamesListv2 is missing the Map of platforms to hardware
  }) = _GamesListv2;
  const GamesListv2._();

  factory GamesListv2.fromJson(Map<String, dynamic> json) =>
      _$GamesListv2FromJson(json);
}

@freezed
class GamesListv3 with _$GamesListv3 {
  const factory GamesListv3({
    required List<Game> games,
    // GamesListv2 is missing the Map of platforms to hardware
  }) = _GamesListv3;
  const GamesListv3._();

  factory GamesListv3.fromJson(Map<String, dynamic> json) =>
      _$GamesListv3FromJson(json);
}

/// Migrates the database
class DatabaseMigrator {
  const DatabaseMigrator._();

  static DLCv2 migrateDLCv1(DLCv1 dlc) {
    return DLCv2(
      createdAt: dlc.lastModified,
      id: dlc.id,
      name: dlc.name,
      status: dlc.status,
      lastModified: dlc.lastModified,
      price: dlc.price,
      notes: dlc.notes,
      isFavorite: dlc.isFavorite,
      wasGifted: dlc.wasGifted,
    );
  }

  static DLC migrateDLCv2(DLCv2 dlc) {
    return DLC(
      createdAt: dlc.lastModified,
      id: dlc.id,
      name: dlc.name,
      status: dlc.status,
      lastModified: dlc.lastModified,
      price: dlc.price,
      notes: dlc.notes,
      isFavorite: dlc.isFavorite,
      priceVariant: dlc.wasGifted
          ? PriceVariant.gifted
          : dlc.status == PlayStatus.onWishList
              ? PriceVariant.onWishList
              : PriceVariant.bought,
    );
  }

  static Gamev2 migrateGamev1(Gamev1 game) {
    return Gamev2(
      createdAt: game.lastModified,
      id: game.id,
      name: game.name,
      platform: game.platform,
      status: game.status,
      lastModified: game.lastModified,
      price: game.price,
      usk: game.usk,
      dlcs: game.dlcs.map((e) => migrateDLCv1(e)).toList(),
      notes: game.notes,
      isFavorite: game.isFavorite,
      wasGifted: game.wasGifted,
    );
  }

  static Game migrateGamev2(Gamev2 game) {
    return Game(
      createdAt: game.lastModified,
      id: game.id,
      name: game.name,
      platform: game.platform,
      status: game.status,
      lastModified: game.lastModified,
      price: game.price,
      usk: game.usk,
      dlcs: game.dlcs.map((e) => migrateDLCv2(e)).toList(),
      notes: game.notes,
      isFavorite: game.isFavorite,
      priceVariant: game.wasGifted
          ? PriceVariant.gifted
          : game.status == PlayStatus.onWishList
              ? PriceVariant.onWishList
              : PriceVariant.bought,
    );
  }

  static GamesListv2 migrateGamesListV1(GamesListv1 gamesList) {
    return GamesListv2(
      games: gamesList.games.map((e) => migrateGamev1(e)).toList(),
    );
  }

  static GamesListv3 migrateGamesListV2(GamesListv2 gamesList) {
    return GamesListv3(
      games: gamesList.games.map((e) => migrateGamev2(e)).toList(),
    );
  }

  static Database migrateGamesListV3(GamesListv3 gamesList) {
    return Database(
      games: gamesList.games,
      hardware: [],
    );
  }

  static Database loadAndMigrateGamesFromJson(Map<String, dynamic> jsonMap) {
    Database? result;
    try {
      result = Database.fromJson(jsonMap);
    } catch (error) {
      // fall through to the previous migration step
      result = null;
    }

    // ### Migration steps in reverse order ################################# //
    GamesListv3? gamesV3;
    GamesListv2? gamesV2;
    GamesListv1? gamesV1;

    // Attempt to deserialize from newest to oldest
    if (result == null) {
      try {
        gamesV3 = GamesListv3.fromJson(jsonMap);
      } catch (error) {
        // fall through to the previous migration step
      }
    }

    if (result == null) {
      try {
        gamesV2 = GamesListv2.fromJson(jsonMap);
      } catch (error) {
        // fall through to the previous migration step
      }
    }

    if (result == null) {
      try {
        gamesV1 = GamesListv1.fromJson(jsonMap);
      } catch (error) {
        // fall through to the previous migration step
      }
    }

    // Migrate from olders to newest
    if (gamesV1 != null) {
      gamesV2 = migrateGamesListV1(gamesV1);
    }
    if (gamesV2 != null) {
      gamesV3 = migrateGamesListV2(gamesV2);
    }
    if (gamesV3 != null) {
      result = migrateGamesListV3(gamesV3);
    }

    // Throw an exception if loading failed
    if (result == null) {
      throw Exception("Failed to load games");
    }

    return result;
  }
}
