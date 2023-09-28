import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(overrides: []);
  });
  group("activeGamePlatformsProvider", () {
    test("loads persisted GamePlatforms correctly", () async {
      SharedPreferences.setMockInitialValues(
        {"game-platforms": '{"platforms":["Switch","PS5"]}'},
      );
      final initialValue =
          await container.read(activeGamePlatformsProvider.future);
      expect(
        initialValue,
        [GamePlatform.nintendoSwitch, GamePlatform.playStation5],
      );
    });
    test("falls back to all GamePlatforms if no persisted entry is found",
        () async {
      SharedPreferences.setMockInitialValues(
        {},
      );
      final initialValue =
          await container.read(activeGamePlatformsProvider.future);
      expect(initialValue, GamePlatform.values);
    });
    test("persists GamePlatforms like expected", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      final update = [
        GamePlatform.nintendoSwitch,
        GamePlatform.nintendo3DS,
      ];

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms(update);

      expect(await container.read(activeGamePlatformsProvider.future), update);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(ActiveGamePlatforms.storageKey),
        '{"platforms":["Switch","3DS"]}',
      );
    });
  });
  group("activeGamePlatformFamiliesProvider", () {
    test("returns an empty list if no platforms are stored", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms([]);

      final families =
          await container.read(activeGamePlatformFamiliesProvider.future);

      expect(families, []);
    });
    test("returns families of active platforms only", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms([
        GamePlatform.nintendoSwitch,
        GamePlatform.nintendo3DS,
        GamePlatform.nintendoDS,
        GamePlatform.playStation2,
      ]);

      final families =
          await container.read(activeGamePlatformFamiliesProvider.future);

      expect(families, [
        GamePlatformFamily.nintendo,
        GamePlatformFamily.sony,
      ]);
    });
  });
  group("gamePlatformsByFamilyProvider", () {
    test("returns all platforms of all families regardless of the active ones",
        () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms([
        GamePlatform.gameBoy,
        GamePlatform.gameBoyAdvance,
      ]);

      final families = container.read(gamePlatformsByFamilyProvider);

      expect(families, {
        GamePlatformFamily.nintendo: [
          GamePlatform.gameAndWatch,
          GamePlatform.gameBoy,
          GamePlatform.gameBoyColor,
          GamePlatform.gameBoyAdvance,
          GamePlatform.nintendoDS,
          GamePlatform.nintendoDSi,
          GamePlatform.nintendo3DS,
          GamePlatform.newNintendo3DS,
          GamePlatform.nes,
          GamePlatform.snes,
          GamePlatform.nintendo64,
          GamePlatform.gameCube,
          GamePlatform.wii,
          GamePlatform.wiiU,
          GamePlatform.nintendoSwitch,
        ],
        GamePlatformFamily.sony: [
          GamePlatform.playStationPortable,
          GamePlatform.playStationVita,
          GamePlatform.playStation1,
          GamePlatform.playStation2,
          GamePlatform.playStation3,
          GamePlatform.playStation4,
          GamePlatform.playStation5,
        ],
        GamePlatformFamily.microsoft: [
          GamePlatform.xbox,
          GamePlatform.xbox360,
          GamePlatform.xboxOne,
          GamePlatform.xboxSeries,
        ],
        GamePlatformFamily.sega: [
          GamePlatform.segaMegaDrive,
          GamePlatform.segaGameGear,
          GamePlatform.segaSaturn,
          GamePlatform.segaDreamcast,
        ],
        GamePlatformFamily.pc: [
          GamePlatform.pcMisc,
          GamePlatform.gog,
          GamePlatform.origin,
          GamePlatform.steam,
          GamePlatform.ubisoftConnect,
          GamePlatform.epicGames,
          GamePlatform.twitch,
        ],
        GamePlatformFamily.misc: [
          GamePlatform.smartphone,
          GamePlatform.unknown,
        ],
      });
    });
  });

  group("activeGamePlatformsByFamilyProvider", () {
    test("returns an empty map if no platforms are stored", () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms([]);

      final families =
          await container.read(activeGamePlatformsByFamilyProvider.future);

      expect(families, {});
    });
    test("returns a map of platform families containing active platforms only",
        () async {
      SharedPreferences.setMockInitialValues(
        {},
      );

      await container
          .read(activeGamePlatformsProvider.notifier)
          .updatePlatforms([
        GamePlatform.nintendoSwitch,
        GamePlatform.nintendo3DS,
        GamePlatform.nintendoDS,
        GamePlatform.playStation2,
      ]);

      final families =
          await container.read(activeGamePlatformsByFamilyProvider.future);

      expect(families, {
        GamePlatformFamily.nintendo: [
          GamePlatform.nintendoSwitch,
          GamePlatform.nintendo3DS,
          GamePlatform.nintendoDS,
        ],
        GamePlatformFamily.sony: [
          GamePlatform.playStation2,
        ],
      });
    });
  });
}
