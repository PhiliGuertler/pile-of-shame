import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/database.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/utils/data_migration.dart';

void main() {
  group("DLCv1 -> DLCv2", () {
    test("correctly migrates DLCv1 -> DLCv2", () {
      final DLCv1 dlcv1 = DLCv1(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 24.3,
        wasGifted: true,
      );

      final DLCv2 migrated = DatabaseMigrator.migrateDLCv1(dlcv1);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 20));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 24.3);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.wasGifted, true);
    });
  });
  group("DLCv2 -> DLCv3", () {
    test("correctly migrates gifted DLCv2 -> DLCv3", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        wasGifted: true,
        price: 0,
      );

      final DLCv3 migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 0);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.priceVariant, PriceVariant.gifted);
    });
    test("correctly migrates bought DLCv2 -> DLCv3", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 0,
        wasGifted: false,
      );

      final DLCv3 migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 0);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.priceVariant, PriceVariant.bought);
    });
    test("correctly migrates wishlisted DLCv2 -> DLCv3", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onWishList,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 69.99,
        wasGifted: false,
      );

      final DLCv3 migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 69.99);
      expect(migrated.status, PlayStatus.onWishList);
      expect(migrated.priceVariant, PriceVariant.observing);
    });
  });

  group("Gamev1 -> Gamev2", () {
    test("correctly migrates Gamev1 -> Gamev2", () {
      final Gamev1 gamev1 = Gamev1(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        name: "Ye olden Game",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 24.3,
        wasGifted: true,
        platform: GamePlatform.gameBoy,
        usk: USK.usk0,
        dlcs: [
          DLCv1(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            wasGifted: true,
            price: 0.0,
            isFavorite: false,
            notes: null,
          ),
        ],
      );

      final Gamev2 migrated = DatabaseMigrator.migrateGamev1(gamev1);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 20));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Game");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 24.3);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.wasGifted, true);
      expect(migrated.dlcs, [
        DLCv2(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 21),
          wasGifted: true,
          price: 0.0,
          isFavorite: false,
          notes: null,
        ),
      ]);
    });
  });
  group("Gamev2 -> Gamev3", () {
    test("correctly migrates gifted Gamev2 -> Gamev3", () {
      final Gamev2 gamev2 = Gamev2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden Game",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        wasGifted: true,
        platform: GamePlatform.atariJaguar,
        price: 0,
        usk: USK.usk16,
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            wasGifted: true,
            isFavorite: false,
            notes: null,
            price: 0,
          ),
        ],
      );

      final Gamev3 migrated = DatabaseMigrator.migrateGamev2(gamev2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Game");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 0);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.priceVariant, PriceVariant.gifted);
      expect(migrated.platform, GamePlatform.atariJaguar);
      expect(migrated.usk, USK.usk16);
      expect(migrated.dlcs, [
        DLCv3(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          priceVariant: PriceVariant.gifted,
          isFavorite: false,
          notes: null,
          price: 0,
        ),
      ]);
    });
    test("correctly migrates bought Gamev2 -> Gamev3", () {
      final Gamev2 gamev2 = Gamev2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden Game",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        platform: GamePlatform.atariJaguar,
        price: 59.49,
        usk: USK.usk0,
        wasGifted: false,
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            price: 24.95,
            notes: null,
            isFavorite: false,
            wasGifted: false,
          ),
        ],
      );

      final Gamev3 migrated = DatabaseMigrator.migrateGamev2(gamev2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Game");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 59.49);
      expect(migrated.status, PlayStatus.onPileOfShame);
      expect(migrated.priceVariant, PriceVariant.bought);
      expect(migrated.platform, GamePlatform.atariJaguar);
      expect(migrated.dlcs, [
        DLCv3(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          priceVariant: PriceVariant.bought,
          price: 24.95,
          notes: null,
          isFavorite: false,
        ),
      ]);
    });
    test("correctly migrates wishlisted Gamev2 -> Gamev3", () {
      final Gamev2 gamev2 = Gamev2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden Game",
        status: PlayStatus.onWishList,
        isFavorite: true,
        notes: "Some kind of Note",
        platform: GamePlatform.atariJaguar,
        price: 59.49,
        usk: USK.usk0,
        wasGifted: false,
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onWishList,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            price: 24.95,
            isFavorite: false,
            notes: null,
            wasGifted: false,
          ),
        ],
      );

      final Gamev3 migrated = DatabaseMigrator.migrateGamev2(gamev2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Game");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 59.49);
      expect(migrated.status, PlayStatus.onWishList);
      expect(migrated.priceVariant, PriceVariant.observing);
      expect(migrated.platform, GamePlatform.atariJaguar);
      expect(migrated.dlcs, [
        DLCv3(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onWishList,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          priceVariant: PriceVariant.observing,
          price: 24.95,
          isFavorite: false,
          notes: null,
        ),
      ]);
    });
  });

  group("VideoGameHardwarev1 -> VideoGameHardwarev2", () {
    test("correctly migrates gifted VideoGameHardwarev1 -> VideoGameHardwarev2",
        () {
      final VideoGameHardwarev1 hardwarev1 = VideoGameHardwarev1(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden Hardware",
        notes: "Some kind of Note",
        wasGifted: true,
        platform: GamePlatform.atariJaguar,
        price: 0,
      );

      final VideoGameHardwarev2 migrated =
          DatabaseMigrator.migrateHardwarev1(hardwarev1);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Hardware");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 0);
      expect(migrated.priceVariant, PriceVariant.gifted);
      expect(migrated.platform, GamePlatform.atariJaguar);
    });
    test("correctly migrates bought Gamev2 -> Gamev3", () {
      final VideoGameHardwarev1 hardwarev1 = VideoGameHardwarev1(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden Hardware",
        notes: "Some kind of Note",
        wasGifted: false,
        platform: GamePlatform.atariJaguar,
        price: 0,
      );

      final VideoGameHardwarev2 migrated =
          DatabaseMigrator.migrateHardwarev1(hardwarev1);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Hardware");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 0);
      expect(migrated.priceVariant, PriceVariant.bought);
      expect(migrated.platform, GamePlatform.atariJaguar);
    });
  });

  group("loadAndMigrateGamesFromJson", () {
    final DLCv1 dlcv1 = DLCv1(
      id: "123456",
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden DLC",
      status: PlayStatus.onPileOfShame,
      isFavorite: true,
      notes: "Some kind of Note",
      wasGifted: true,
      price: 0.0,
    );
    final DLC migratedDLC1 = DLC(
      id: "123456",
      createdAt: DateTime(2023, 4, 20),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden DLC",
      status: PlayStatus.onPileOfShame,
      isFavorite: true,
      notes: "Some kind of Note",
      priceVariant: PriceVariant.gifted,
    );
    final DLCv2 dlcv2 = DLCv2(
      id: "123456",
      createdAt: DateTime(2023, 4, 19),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden DLC",
      status: PlayStatus.onWishList,
      isFavorite: true,
      notes: "Some kind of Note",
      price: 24.3,
      wasGifted: false,
    );
    final DLC migratedDLC2 = DLC(
      id: "123456",
      createdAt: DateTime(2023, 4, 19),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden DLC",
      status: PlayStatus.onWishList,
      isFavorite: true,
      notes: "Some kind of Note",
      priceVariant: PriceVariant.observing,
      price: 24.3,
    );

    final Gamev1 gamev1 = Gamev1(
      id: "123456",
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden Game",
      status: PlayStatus.onPileOfShame,
      isFavorite: true,
      notes: "Some kind of Note",
      price: 0,
      wasGifted: true,
      platform: GamePlatform.gameBoy,
      usk: USK.usk6,
      dlcs: [
        dlcv1,
      ],
    );
    final Game migratedGame1 = Game(
      id: "123456",
      createdAt: DateTime(2023, 4, 20),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden Game",
      status: PlayStatus.onPileOfShame,
      isFavorite: true,
      notes: "Some kind of Note",
      price: 0,
      priceVariant: PriceVariant.gifted,
      platform: GamePlatform.gameBoy,
      usk: USK.usk6,
      dlcs: [
        migratedDLC1,
      ],
    );
    final Gamev2 gamev2 = Gamev2(
      id: "123456",
      createdAt: DateTime(2023, 4, 19),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden Game",
      status: PlayStatus.onWishList,
      isFavorite: true,
      notes: "Some kind of Note",
      price: 25,
      platform: GamePlatform.gameBoy,
      usk: USK.usk12,
      wasGifted: false,
      dlcs: [
        dlcv2,
      ],
    );
    final Game migratedGame2 = Game(
      id: "123456",
      createdAt: DateTime(2023, 4, 19),
      lastModified: DateTime(2023, 4, 20),
      name: "Ye olden Game",
      status: PlayStatus.onWishList,
      isFavorite: true,
      notes: "Some kind of Note",
      price: 25,
      priceVariant: PriceVariant.observing,
      platform: GamePlatform.gameBoy,
      usk: USK.usk12,
      dlcs: [
        migratedDLC2,
      ],
    );

    final VideoGameHardwarev1 hardware = VideoGameHardwarev1(
      id: "hardiwary",
      name: "Some Hardware",
      platform: GamePlatform.gameBoyAdvance,
      lastModified: DateTime(2023, 4, 10),
      createdAt: DateTime(2023, 4, 10),
      notes: null,
      price: 0,
      wasGifted: true,
    );
    final VideoGameHardware migratedHardware = VideoGameHardware(
      id: "hardiwary",
      name: "Some Hardware",
      platform: GamePlatform.gameBoyAdvance,
      lastModified: DateTime(2023, 4, 10),
      createdAt: DateTime(2023, 4, 10),
      priceVariant: PriceVariant.gifted,
    );

    test("throws on malformed json", () {
      try {
        DatabaseMigrator.loadAndMigrateGamesFromJson({
          "what": [
            {"thatsnot": "right"},
          ],
        });
      } catch (error) {
        return;
      }
      fail("No exception thrown!");
    });
    test("correctly migrates GamesListv1", () {
      final Map<String, dynamic> json =
          jsonDecode('{"games":[${jsonEncode(gamev1.toJson())}]}')
              as Map<String, dynamic>;

      final result = DatabaseMigrator.loadAndMigrateGamesFromJson(json);
      expect(
        result,
        Database(
          games: [migratedGame1],
          hardware: [],
        ),
      );
    });
    test("correctly migrates GamesListv2", () {
      final Map<String, dynamic> json =
          jsonDecode('{"games":[${jsonEncode(gamev2.toJson())}]}')
              as Map<String, dynamic>;

      final result = DatabaseMigrator.loadAndMigrateGamesFromJson(json);
      expect(
        result,
        Database(
          games: [migratedGame2],
          hardware: [],
        ),
      );
    });
    test("correctly migrates Databasev1", () {
      final Map<String, dynamic> json = jsonDecode(
        '{"games":[${jsonEncode(gamev2.toJson())}],"hardware":[${jsonEncode(hardware.toJson())}]}',
      ) as Map<String, dynamic>;

      final result = DatabaseMigrator.loadAndMigrateGamesFromJson(json);
      expect(
        result,
        Database(
          games: [migratedGame2],
          hardware: [migratedHardware],
        ),
      );
    });
  });
}
