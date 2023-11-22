import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
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
  group("DLCv2 -> DLC", () {
    test("correctly migrates gifted DLCv2 -> DLC", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        wasGifted: true,
      );

      final DLC migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
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
    test("correctly migrates bought DLCv2 -> DLC", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
      );

      final DLC migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
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
    test("correctly migrates wishlisted DLCv2 -> DLC", () {
      final DLCv2 dlcv2 = DLCv2(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        createdAt: DateTime(2023, 4, 19),
        name: "Ye olden DLC",
        status: PlayStatus.onWishList,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 69.99,
      );

      final DLC migrated = DatabaseMigrator.migrateDLCv2(dlcv2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 69.99);
      expect(migrated.status, PlayStatus.onWishList);
      expect(migrated.priceVariant, PriceVariant.onWishList);
    });
  });

  group("Gamev1 -> Gamev2", () {
    test("correctly migrates Gamev1 -> Gamev2", () {
      final Gamev1 gamev1 = Gamev1(
        id: "123456",
        lastModified: DateTime(2023, 4, 20),
        name: "Ye olden DLC",
        status: PlayStatus.onPileOfShame,
        isFavorite: true,
        notes: "Some kind of Note",
        price: 24.3,
        wasGifted: true,
        platform: GamePlatform.gameBoy,
        dlcs: [
          DLCv1(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            wasGifted: true,
          ),
        ],
      );

      final Gamev2 migrated = DatabaseMigrator.migrateGamev1(gamev1);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 20));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden DLC");
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
        ),
      ]);
    });
  });
  group("Gamev2 -> Game", () {
    test("correctly migrates gifted Gamev2 -> Game", () {
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
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            wasGifted: true,
          ),
        ],
      );

      final Game migrated = DatabaseMigrator.migrateGamev2(gamev2);
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
      expect(migrated.dlcs, [
        DLC(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          priceVariant: PriceVariant.gifted,
        ),
      ]);
    });
    test("correctly migrates bought Gamev2 -> Game", () {
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
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onPileOfShame,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            price: 24.95,
          ),
        ],
      );

      final Game migrated = DatabaseMigrator.migrateGamev2(gamev2);
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
        DLC(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onPileOfShame,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          // ignore: avoid_redundant_argument_values
          priceVariant: PriceVariant.bought,
          price: 24.95,
        ),
      ]);
    });
    test("correctly migrates wishlisted DLCv2 -> DLC", () {
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
        dlcs: [
          DLCv2(
            id: "654321",
            name: "DLC",
            status: PlayStatus.onWishList,
            lastModified: DateTime(2023, 4, 21),
            createdAt: DateTime(2023, 4, 20),
            price: 24.95,
          ),
        ],
      );

      final Game migrated = DatabaseMigrator.migrateGamev2(gamev2);
      expect(migrated.id, "123456");
      expect(migrated.createdAt, DateTime(2023, 4, 19));
      expect(migrated.isFavorite, true);
      expect(migrated.lastModified, DateTime(2023, 4, 20));
      expect(migrated.name, "Ye olden Game");
      expect(migrated.notes, "Some kind of Note");
      expect(migrated.price, 59.49);
      expect(migrated.status, PlayStatus.onWishList);
      expect(migrated.priceVariant, PriceVariant.onWishList);
      expect(migrated.platform, GamePlatform.atariJaguar);
      expect(migrated.dlcs, [
        DLC(
          id: "654321",
          name: "DLC",
          status: PlayStatus.onWishList,
          lastModified: DateTime(2023, 4, 21),
          createdAt: DateTime(2023, 4, 20),
          // ignore: avoid_redundant_argument_values
          priceVariant: PriceVariant.onWishList,
          price: 24.95,
        ),
      ]);
    });
  });
}
