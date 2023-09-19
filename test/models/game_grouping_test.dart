import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations_de.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations_en.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final gameDarkSouls = Game(
    id: 'dark-souls',
    name: "Dark Souls",
    platform: GamePlatform.playStation4,
    status: PlayStatus.replaying,
    lastModified: DateTime(2023, 4, 20),
    price: 39.99,
    usk: USK.usk16,
    dlcs: [
      DLC(
        id: 'dark-souls-artorias-of-the-abyss',
        name: "Artorias of the Abyss",
        status: PlayStatus.onWishList,
        lastModified: DateTime(2013, 7, 10),
        price: 9.99,
        notes: "DLC Notes",
      ),
    ],
    notes: "Game Notes",
  );

  group("GameGrouperByPlatform", () {
    GameGrouperByPlatform grouper = const GameGrouperByPlatform();
    group("matchesGroup", () {
      test("returns true if the game platform matches the group", () {
        final response = grouper.matchesGroup(GamePlatform.nintendoSwitch,
            gameDarkSouls.copyWith(platform: GamePlatform.nintendoSwitch));
        expect(response, true);
      });
      test("returns false if the game platform does not match the group", () {
        final response = grouper.matchesGroup(GamePlatform.wii,
            gameDarkSouls.copyWith(platform: GamePlatform.nintendoSwitch));
        expect(response, false);
      });
    });
    test("values returns all GamePlatforms", () {
      final response = grouper.values();
      expect(response, GamePlatform.values);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string for a platform", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsDe(), GamePlatform.nintendoSwitch);
        expect(response, "Nintendo Switch");
      });
      test("returns correct DE string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsDe(), GamePlatform.unknown);
        expect(response, "Sonstige");
      });
      test("returns correct EN string for a platform", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsEn(), GamePlatform.nintendoSwitch);
        expect(response, "Nintendo Switch");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsEn(), GamePlatform.unknown);
        expect(response, "Misc");
      });
    });
  });
  group("GameGrouperByPlatformFamily", () {
    GameGrouperByPlatformFamily grouper = const GameGrouperByPlatformFamily();
    group("matchesGroup", () {
      test("returns true if the game platform family matches the group", () {
        final response = grouper.matchesGroup(GamePlatformFamily.nintendo,
            gameDarkSouls.copyWith(platform: GamePlatform.nintendoSwitch));
        expect(response, true);
      });
      test("returns false if the game platform family does not match the group",
          () {
        final response = grouper.matchesGroup(GamePlatformFamily.pc,
            gameDarkSouls.copyWith(platform: GamePlatform.nintendoSwitch));
        expect(response, false);
      });
    });
    test("values returns all GamePlatformFamilies", () {
      final response = grouper.values();
      expect(response, GamePlatformFamily.values);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string for a company", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsDe(), GamePlatformFamily.sony);
        expect(response, "Sony");
      });
      test("returns correct DE string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsDe(), GamePlatformFamily.misc);
        expect(response, "Sonstige");
      });
      test("returns correct EN string for a company", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsEn(), GamePlatformFamily.sony);
        expect(response, "Sony");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsEn(), GamePlatformFamily.misc);
        expect(response, "Misc");
      });
    });
  });
  group("GameGrouperByPlayStatus", () {
    GameGrouperByPlayStatus grouper = const GameGrouperByPlayStatus();
    group("matchesGroup", () {
      test("returns true if the play status matches the group", () {
        final response = grouper.matchesGroup(PlayStatus.onPileOfShame,
            gameDarkSouls.copyWith(status: PlayStatus.onPileOfShame));
        expect(response, true);
      });
      test("returns false if the play status does not match the group", () {
        final response = grouper.matchesGroup(PlayStatus.onWishList,
            gameDarkSouls.copyWith(status: PlayStatus.onPileOfShame));
        expect(response, false);
      });
    });
    test("values returns all PlayStatuses", () {
      final response = grouper.values();
      expect(response, PlayStatus.values);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsDe(), PlayStatus.playing);
        expect(response, "Am Spielen");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
            AppLocalizationsEn(), PlayStatus.playing);
        expect(response, "Playing");
      });
    });
  });
  group("GameGrouperByAgeRating", () {
    GameGrouperByAgeRating grouper = const GameGrouperByAgeRating();
    group("matchesGroup", () {
      test("returns true if the age rating matches the group", () {
        final response = grouper.matchesGroup(
            USK.usk12, gameDarkSouls.copyWith(usk: USK.usk12));
        expect(response, true);
      });
      test("returns false if the age rating does not match the group", () {
        final response = grouper.matchesGroup(
            USK.usk16, gameDarkSouls.copyWith(usk: USK.usk12));
        expect(response, false);
      });
    });
    test("values returns all USKs", () {
      final response = grouper.values();
      expect(response, USK.values);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsDe(), USK.usk12);
        expect(response, "Freigegeben ab 12 Jahren");
      });
      test("returns correct EN string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsEn(), USK.usk12);
        expect(response, "Rated 12");
      });
    });
  });
  group("GameGrouperByIsFavorite", () {
    GameGrouperByIsFavorite grouper = const GameGrouperByIsFavorite();
    group("matchesGroup", () {
      test("returns true if the favorite-flag matches the group", () {
        final response = grouper.matchesGroup(
            true, gameDarkSouls.copyWith(isFavorite: true));
        expect(response, true);
      });
      test("returns false if the favorite-flag does not match the group", () {
        final response = grouper.matchesGroup(
            true, gameDarkSouls.copyWith(isFavorite: false));
        expect(response, false);
      });
    });
    test("values returns all bool values", () {
      final response = grouper.values();
      expect(response, [true, false]);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsDe(), true);
        expect(response, "ist Favorit");
      });
      test("returns correct EN string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsEn(), true);
        expect(response, "is favorite");
      });
    });
  });
  group("GameGrouperByHasNotes", () {
    GameGrouperByHasNotes grouper = const GameGrouperByHasNotes();
    group("matchesGroup", () {
      test("returns true if notes exist and the group is true", () {
        final response = grouper.matchesGroup(
            true, gameDarkSouls.copyWith(notes: "some notes"));
        expect(response, true);
      });
      test("returns false if notes exist the group is false", () {
        final response = grouper.matchesGroup(
            false, gameDarkSouls.copyWith(notes: "some notes"));
        expect(response, false);
      });
    });
    test("values returns all bool values", () {
      final response = grouper.values();
      expect(response, [true, false]);
    });
    group("groupToLocaleString", () {
      test("returns correct DE string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsDe(), true);
        expect(response, "hat Notizen");
      });
      test("returns correct EN string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsEn(), true);
        expect(response, "has notes");
      });
    });
  });
}
