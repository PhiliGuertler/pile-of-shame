import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/models/price_variant.dart';

part 'data_migration.freezed.dart';
part 'data_migration.g.dart';

// ### DLC ################################################################## //

/// DLC without createdAt (before App-Version 0.6.1)
@freezed
abstract class DLCv1 with _$DLCv1 {
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

  DLCv2 migrate() {
    return DLCv2(
      createdAt: lastModified,
      id: id,
      name: name,
      status: status,
      lastModified: lastModified,
      price: price,
      notes: notes,
      isFavorite: isFavorite,
      wasGifted: wasGifted,
    );
  }
}

/// DLC with wasGifted instead of priceVariant (before App-Version 1.3.0)
@freezed
abstract class DLCv2 with _$DLCv2 {
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

  DLCv3 migrate() {
    return DLCv3(
      createdAt: createdAt,
      id: id,
      name: name,
      status: status,
      lastModified: lastModified,
      price: price,
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: wasGifted
          ? PriceVariant.gifted
          : status == PlayStatus.onWishList
              ? PriceVariant.observing
              : PriceVariant.bought,
    );
  }
}

/// DLC with every field mandatory for parsing (before App-Version 1.6.0)
@freezed
abstract class DLCv3 with _$DLCv3 {
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

  DLCv4 migrate() {
    return DLCv4(
      version: 1,
      id: id,
      name: name,
      status: status,
      lastModified: lastModified,
      createdAt: createdAt,
      price: price,
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}

/// Current DLC with version counter (from App-Version 1.6.0)
@freezed
abstract class DLCv4 with _$DLCv4 {
  const factory DLCv4({
    required int version,
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    required String? notes,
    required bool isFavorite,
    required PriceVariant priceVariant,
  }) = _DLCv4;
  const DLCv4._();

  factory DLCv4.fromJson(Map<String, dynamic> json) => _$DLCv4FromJson(json);

  DLC migrate() {
    return DLC(
      id: id,
      name: name,
      status: status,
      lastModified: lastModified,
      createdAt: createdAt,
      price: price,
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}

// ### Game ################################################################# //

/// Game without createdAt (before App-Version 0.6.1)
@freezed
abstract class Gamev1 with _$Gamev1 {
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

  Gamev2 migrate() {
    return Gamev2(
      createdAt: lastModified,
      id: id,
      name: name,
      platform: platform,
      status: status,
      lastModified: lastModified,
      price: price,
      usk: usk,
      dlcs: dlcs.map((e) => e.migrate()).toList(),
      notes: notes,
      isFavorite: isFavorite,
      wasGifted: wasGifted,
    );
  }
}

/// Game with wasGifted instead of priceVariant (before App-Version 1.3.0)
@freezed
abstract class Gamev2 with _$Gamev2 {
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

  Gamev3 migrate() {
    return Gamev3(
      createdAt: createdAt,
      id: id,
      name: name,
      platform: platform,
      status: status,
      lastModified: lastModified,
      price: price,
      usk: usk,
      dlcs: dlcs.map((e) => e.migrate()).toList(),
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: wasGifted
          ? PriceVariant.gifted
          : status == PlayStatus.onWishList
              ? PriceVariant.observing
              : PriceVariant.bought,
    );
  }
}

/// Game with every field mandatory for parsing (before App-Version 1.6.0)
@freezed
abstract class Gamev3 with _$Gamev3 {
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

  Gamev4 migrate() {
    return Gamev4(
      version: 1,
      id: id,
      name: name,
      platform: platform,
      status: status,
      lastModified: lastModified,
      createdAt: createdAt,
      price: price,
      usk: usk,
      dlcs: dlcs.map((e) => e.migrate()).toList(),
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}

/// Current Game with version counter (from App-Version 1.6.0)
@freezed
abstract class Gamev4 with _$Gamev4 {
  const factory Gamev4({
    required int version,
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    required USK usk,
    required List<DLCv4> dlcs,
    required String? notes,
    required bool isFavorite,
    required PriceVariant priceVariant,
  }) = _Gamev4;
  const Gamev4._();

  factory Gamev4.fromJson(Map<String, dynamic> json) => _$Gamev4FromJson(json);

  Game migrate() {
    return Game(
      id: id,
      name: name,
      platform: platform,
      status: status,
      lastModified: lastModified,
      createdAt: createdAt,
      price: price,
      usk: usk,
      dlcs: dlcs
          .map(
            (e) => e.migrate(),
          )
          .toList(),
      notes: notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}

// ### VideoGameHardware #################################################### //

/// VideoGameHardware with wasGifted instead of priceVariant (before App-Version 1.3.0)
@freezed
abstract class VideoGameHardwarev1 with _$VideoGameHardwarev1 {
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

  VideoGameHardwarev2 migrate() {
    return VideoGameHardwarev2(
      priceVariant: wasGifted ? PriceVariant.gifted : PriceVariant.bought,
      createdAt: createdAt,
      id: id,
      lastModified: lastModified,
      name: name,
      notes: notes,
      platform: platform,
      price: price,
    );
  }
}

/// VideoGameHardware with priceVariant instead of wasGifted (before App-Version 1.6.0)
@freezed
abstract class VideoGameHardwarev2 with _$VideoGameHardwarev2 {
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

  VideoGameHardwarev3 migrate() {
    return VideoGameHardwarev3(
      version: 1,
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

/// Current VideoGameHardware with version counter (from App-Version 1.6.0)
@freezed
abstract class VideoGameHardwarev3 with _$VideoGameHardwarev3 {
  const factory VideoGameHardwarev3({
    required int version,
    required String id,
    required String name,
    required GamePlatform platform,
    required double price,
    required DateTime lastModified,
    required DateTime createdAt,
    required String? notes,
    required PriceVariant priceVariant,
  }) = _VideoGameHardwarev3;
  const VideoGameHardwarev3._();

  factory VideoGameHardwarev3.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwarev3FromJson(json);

  VideoGameHardware migrate() {
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
abstract class GamesListv1 with _$GamesListv1 {
  const factory GamesListv1({
    required List<Gamev1> games,
  }) = _GamesListv1;
  const GamesListv1._();

  factory GamesListv1.fromJson(Map<String, dynamic> json) =>
      _$GamesListv1FromJson(json);

  GamesListv2 migrate() {
    return GamesListv2(
      games: games.map((e) => e.migrate()).toList(),
    );
  }
}

/// GameList with Gamev2 without hardware (before App-Version 0.9.2)
@freezed
abstract class GamesListv2 with _$GamesListv2 {
  const factory GamesListv2({
    required List<Gamev2> games,
    // GamesListv2 is missing the Map of platforms to hardware
  }) = _GamesListv2;
  const GamesListv2._();

  factory GamesListv2.fromJson(Map<String, dynamic> json) =>
      _$GamesListv2FromJson(json);

  Databasev1 migrate() {
    return Databasev1(
      games: games,
      hardware: [],
    );
  }
}

/// Database with Gamev2 (before App-Version 1.3.0)
@freezed
abstract class Databasev1 with _$Databasev1 {
  const factory Databasev1({
    required List<Gamev2> games,
    required List<VideoGameHardwarev1> hardware,
  }) = _Databasev1;
  const Databasev1._();

  factory Databasev1.fromJson(Map<String, dynamic> json) =>
      _$Databasev1FromJson(json);

  Databasev2 migrate() {
    return Databasev2(
      games: games.map((e) => e.migrate()).toList(),
      hardware: hardware.map((e) => e.migrate()).toList(),
    );
  }
}

/// Database with Gamev3 (before App-Version 1.6.0)
@freezed
abstract class Databasev2 with _$Databasev2 {
  const factory Databasev2({
    required List<Gamev3> games,
    required List<VideoGameHardwarev2> hardware,
  }) = _Databasev2;
  const Databasev2._();

  factory Databasev2.fromJson(Map<String, dynamic> json) =>
      _$Databasev2FromJson(json);

  Databasev3 migrate() {
    return Databasev3(
      version: 1,
      games: games.map((e) => e.migrate()).toList(),
      hardware: hardware.map((e) => e.migrate()).toList(),
    );
  }
}

/// Database with Gamev4 and version (from App-Version 1.6.0)
@freezed
abstract class Databasev3 with _$Databasev3 {
  const factory Databasev3({
    required int version,
    required List<Gamev4> games,
    required List<VideoGameHardwarev3> hardware,
  }) = _Databasev3;
  const Databasev3._();

  factory Databasev3.fromJson(Map<String, dynamic> json) =>
      _$Databasev3FromJson(json);

  Database migrate() {
    return Database(
      games: games.map((e) => e.migrate()).toList(),
      hardware: hardware.map((e) => e.migrate()).toList(),
    );
  }
}

/// Migrates the database
class DatabaseMigrator {
  const DatabaseMigrator._();

  static Database loadAndMigrateGamesFromJson(Map<String, dynamic> jsonMap) {
    // ### Migration steps in reverse order ################################# //
    Database? result;
    Databasev3? databaseV3;
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
    try {
      databaseV3 = Databasev3.fromJson(jsonMap);
    } catch (error) {
      // fall through
    }

    // Migrate from olders to newest
    if (gamesV1 != null && gamesV2 == null) {
      gamesV2 = gamesV1.migrate();
    }
    if (gamesV2 != null && databaseV1 == null) {
      databaseV1 = gamesV2.migrate();
    }
    if (databaseV1 != null && databaseV2 == null) {
      databaseV2 = databaseV1.migrate();
    }
    if (databaseV2 != null && databaseV3 == null) {
      databaseV3 = databaseV2.migrate();
    }
    if (databaseV3 != null) {
      result = databaseV3.migrate();
    }

    // Throw an exception if loading failed
    if (result == null) {
      throw Exception("Failed to load games");
    }

    return result;
  }
}
