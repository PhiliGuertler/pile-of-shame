import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'data_migration.freezed.dart';
part 'data_migration.g.dart';

// ### DLC ################################################################## //

/// DLC without createdAt (before App-Version 0.6.1)
@freezed
class DLCv1 with _$DLCv1 {
  const factory DLCv1({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required double price,
    required String? notes,
    required bool isFavorite,
    required bool wasGifted,
  }) = _DLCv1;
  const DLCv1._();

  factory DLCv1.fromJson(Map<String, dynamic> json) => _$DLCv1FromJson(json);
}

/// DLC with wasGifted instead of priceVariant (before App-Version 1.3.0)
@freezed
class DLCv2 with _$DLCv2 {
  const factory DLCv2({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    required String? notes,
    required bool isFavorite,
    required bool wasGifted,
  }) = _DLCv2;
  const DLCv2._();

  factory DLCv2.fromJson(Map<String, dynamic> json) => _$DLCv2FromJson(json);
}

/// Current DLC with every field mandatory for parsing (from App-Version 1.3.0)
@freezed
class DLCv3 with _$DLCv3 {
  const factory DLCv3({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    required String? notes,
    required bool isFavorite,
    required PriceVariant priceVariant,
  }) = _DLCv3;
  const DLCv3._();

  factory DLCv3.fromJson(Map<String, dynamic> json) => _$DLCv3FromJson(json);

  DLC toDLC() {
    return DLC(
      id: id,
      createdAt: createdAt,
      lastModified: lastModified,
      name: name,
      status: status,
      isFavorite: isFavorite,
      notes: notes,
      price: price,
      priceVariant: priceVariant,
    );
  }
}

// ### Game ################################################################# //

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
    required USK usk,
    required List<DLCv1> dlcs,
    required String? notes,
    required bool isFavorite,
    required bool wasGifted,
  }) = _Gamev1;
  const Gamev1._();

  factory Gamev1.fromJson(Map<String, dynamic> json) => _$Gamev1FromJson(json);
}

/// Game with wasGifted instead of priceVariant (before App-Version 1.3.0)
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
    required USK usk,
    required List<DLCv2> dlcs,
    required String? notes,
    required bool isFavorite,
    required bool wasGifted,
  }) = _Gamev2;
  const Gamev2._();

  factory Gamev2.fromJson(Map<String, dynamic> json) => _$Gamev2FromJson(json);
}

/// Current Game with every field mandatory for parsing (from App-Version 1.3.0)
@freezed
class Gamev3 with _$Gamev3 {
  const factory Gamev3({
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    required USK usk,
    required List<DLCv3> dlcs,
    required String? notes,
    required bool isFavorite,
    required PriceVariant priceVariant,
  }) = _Gamev3;
  const Gamev3._();

  factory Gamev3.fromJson(Map<String, dynamic> json) => _$Gamev3FromJson(json);

  Game toGame() {
    return Game(
      id: id,
      name: name,
      platform: platform,
      status: status,
      lastModified: lastModified,
      createdAt: createdAt,
      price: price,
      dlcs: dlcs.map((e) => e.toDLC()).toList(),
      isFavorite: isFavorite,
      notes: notes,
      priceVariant: priceVariant,
      usk: usk,
    );
  }
}

// ### VideoGameHardware #################################################### //

/// VideoGameHardware with wasGifted instead of priceVariant (before App-Version 1.3.0)
@freezed
class VideoGameHardwarev1 with _$VideoGameHardwarev1 {
  const factory VideoGameHardwarev1({
    required String id,
    required String name,
    required GamePlatform platform,
    required double price,
    required DateTime lastModified,
    required DateTime createdAt,
    required String? notes,
    required bool wasGifted,
  }) = _VideoGameHardwarev1;
  const VideoGameHardwarev1._();

  factory VideoGameHardwarev1.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwarev1FromJson(json);
}

/// Current VideoGameHardware (from App-Version 1.3.0)
@freezed
class VideoGameHardwarev2 with _$VideoGameHardwarev2 {
  const factory VideoGameHardwarev2({
    required String id,
    required String name,
    required GamePlatform platform,
    required double price,
    required DateTime lastModified,
    required DateTime createdAt,
    required String? notes,
    required PriceVariant priceVariant,
  }) = _VideoGameHardwarev2;
  const VideoGameHardwarev2._();

  factory VideoGameHardwarev2.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwarev2FromJson(json);

  VideoGameHardware toHardware() {
    return VideoGameHardware(
      id: id,
      name: name,
      platform: platform,
      price: price,
      lastModified: lastModified,
      createdAt: createdAt,
      notes: notes,
      priceVariant: priceVariant,
    );
  }
}

// ### Database ############################################################# //

/// GameList with Gamev1 (before App-Version 0.6.1)
@freezed
class GamesListv1 with _$GamesListv1 {
  const factory GamesListv1({
    required List<Gamev1> games,
  }) = _GamesListv1;
  const GamesListv1._();

  factory GamesListv1.fromJson(Map<String, dynamic> json) =>
      _$GamesListv1FromJson(json);
}

/// GameList with Gamev2 without hardware (before App-Version 0.9.2)
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

/// Database with Gamev2 (before App-Version 1.3.0)
@freezed
class Databasev1 with _$Databasev1 {
  const factory Databasev1({
    required List<Gamev2> games,
    required List<VideoGameHardwarev1> hardware,
  }) = _Databasev1;
  const Databasev1._();

  factory Databasev1.fromJson(Map<String, dynamic> json) =>
      _$Databasev1FromJson(json);
}

/// Database with Gamev3 (from App-Version 1.3.0)
@freezed
class Databasev2 with _$Databasev2 {
  const factory Databasev2({
    required List<Gamev3> games,
    required List<VideoGameHardwarev2> hardware,
  }) = _Databasev2;
  const Databasev2._();

  factory Databasev2.fromJson(Map<String, dynamic> json) =>
      _$Databasev2FromJson(json);
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

  static DLCv3 migrateDLCv2(DLCv2 dlc) {
    return DLCv3(
      createdAt: dlc.createdAt,
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

  static Gamev3 migrateGamev2(Gamev2 game) {
    return Gamev3(
      createdAt: game.createdAt,
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

  static VideoGameHardwarev2 migrateHardwarev1(VideoGameHardwarev1 hardware) {
    return VideoGameHardwarev2(
      priceVariant:
          hardware.wasGifted ? PriceVariant.gifted : PriceVariant.bought,
      createdAt: hardware.createdAt,
      id: hardware.id,
      lastModified: hardware.lastModified,
      name: hardware.name,
      notes: hardware.notes,
      platform: hardware.platform,
      price: hardware.price,
    );
  }

  static GamesListv2 migrateGamesListV1(GamesListv1 gamesList) {
    return GamesListv2(
      games: gamesList.games.map((e) => migrateGamev1(e)).toList(),
    );
  }

  static Databasev1 migrateGamesListV2(GamesListv2 gamesList) {
    return Databasev1(
      games: gamesList.games,
      hardware: [],
    );
  }

  static Databasev2 migrateDatabaseV1(Databasev1 database) {
    return Databasev2(
      games: database.games.map((e) => migrateGamev2(e)).toList(),
      hardware: database.hardware.map((e) => migrateHardwarev1(e)).toList(),
    );
  }

  static Database migrateLatestModelToDatabase(Databasev2 database) {
    return Database(
      games: database.games.map((game) => game.toGame()).toList(),
      hardware:
          database.hardware.map((hardware) => hardware.toHardware()).toList(),
    );
  }

  static Database loadAndMigrateGamesFromJson(Map<String, dynamic> jsonMap) {
    // ### Migration steps in reverse order ################################# //
    Database? result;
    Databasev2? databaseV2;
    Databasev1? databaseV1;
    GamesListv2? gamesV2;
    GamesListv1? gamesV1;

    // Attempt to deserialize from newest to oldest
    try {
      gamesV1 = GamesListv1.fromJson(jsonMap);
    } catch (error) {
      // fall through
    }
    try {
      gamesV2 = GamesListv2.fromJson(jsonMap);
    } catch (error) {
      // fall through
    }
    try {
      databaseV1 = Databasev1.fromJson(jsonMap);
    } catch (error) {
      // fall through
    }
    try {
      databaseV2 = Databasev2.fromJson(jsonMap);
    } catch (error) {
      // fall through
    }

    // Migrate from olders to newest
    if (gamesV1 != null && gamesV2 == null) {
      gamesV2 = migrateGamesListV1(gamesV1);
    }
    if (gamesV2 != null && databaseV1 == null) {
      databaseV1 = migrateGamesListV2(gamesV2);
    }
    if (databaseV1 != null && databaseV2 == null) {
      databaseV2 = migrateDatabaseV1(databaseV1);
    }
    if (databaseV2 != null) {
      result = migrateLatestModelToDatabase(databaseV2);
    }

    // Throw an exception if loading failed
    if (result == null) {
      throw Exception("Failed to load games");
    }

    return result;
  }
}
