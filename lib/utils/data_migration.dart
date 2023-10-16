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

/// Migrates the database
class DatabaseMigrator {
  const DatabaseMigrator._();

  static DLC migrateDLCv1(DLCv1 dlc) {
    return DLC(
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

  static Game migrateGamev1(Gamev1 game) {
    return Game(
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

  static Database migrateDatabase(GamesListv1 gamesList) {
    return Database(
      games: gamesList.games.map((e) => migrateGamev1(e)).toList(),
      hardware: {},
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
    if (result == null) {
      try {
        final GamesListv1 gamesV1 = GamesListv1.fromJson(jsonMap);
        result = migrateDatabase(gamesV1);
      } catch (error) {
        // fall through to the previous migration step
        result = null;
      }
    }
    // ### /Migration steps in reverse order ################################ //

    if (result == null) {
      throw Exception("Failed to load games");
    }
    return result;
  }
}
