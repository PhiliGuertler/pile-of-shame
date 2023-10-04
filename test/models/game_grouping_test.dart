import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations_de.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations_en.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

import '../../test_resources/test_games.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("GameGrouperByPlatform", () {
    const GameGrouperByPlatform grouper = GameGrouperByPlatform();
    group("matchesGroup", () {
      test("returns true if the game platform matches the group", () {
        final response = grouper.matchesGroup(
          GamePlatform.nintendoSwitch,
          TestGames.gameDarkSouls
              .copyWith(platform: GamePlatform.nintendoSwitch),
        );
        expect(response, true);
      });
      test("returns false if the game platform does not match the group", () {
        final response = grouper.matchesGroup(
          GamePlatform.wii,
          TestGames.gameDarkSouls
              .copyWith(platform: GamePlatform.nintendoSwitch),
        );
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
          AppLocalizationsDe(),
          GamePlatform.nintendoSwitch,
        );
        expect(response, "Switch");
      });
      test("returns correct DE string", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsDe(),
          GamePlatform.unknown,
        );
        expect(response, "Sonstige");
      });
      test("returns correct EN string for a platform", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsEn(),
          GamePlatform.nintendoSwitch,
        );
        expect(response, "Switch");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsEn(),
          GamePlatform.unknown,
        );
        expect(response, "Misc");
      });
    });
  });
  group("GameGrouperByPlatformFamily", () {
    const GameGrouperByPlatformFamily grouper = GameGrouperByPlatformFamily();
    group("matchesGroup", () {
      test("returns true if the game platform family matches the group", () {
        final response = grouper.matchesGroup(
          GamePlatformFamily.nintendo,
          TestGames.gameDarkSouls
              .copyWith(platform: GamePlatform.nintendoSwitch),
        );
        expect(response, true);
      });
      test("returns false if the game platform family does not match the group",
          () {
        final response = grouper.matchesGroup(
          GamePlatformFamily.pc,
          TestGames.gameDarkSouls
              .copyWith(platform: GamePlatform.nintendoSwitch),
        );
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
          AppLocalizationsDe(),
          GamePlatformFamily.sony,
        );
        expect(response, "Sony");
      });
      test("returns correct DE string", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsDe(),
          GamePlatformFamily.misc,
        );
        expect(response, "Sonstige");
      });
      test("returns correct EN string for a company", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsEn(),
          GamePlatformFamily.sony,
        );
        expect(response, "Sony");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsEn(),
          GamePlatformFamily.misc,
        );
        expect(response, "Misc");
      });
    });
  });
  group("GameGrouperByPlayStatus", () {
    const GameGrouperByPlayStatus grouper = GameGrouperByPlayStatus();
    group("matchesGroup", () {
      test("returns true if the play status matches the group", () {
        final response = grouper.matchesGroup(
          PlayStatus.onPileOfShame,
          TestGames.gameDarkSouls.copyWith(status: PlayStatus.onPileOfShame),
        );
        expect(response, true);
      });
      test("returns false if the play status does not match the group", () {
        final response = grouper.matchesGroup(
          PlayStatus.onWishList,
          TestGames.gameDarkSouls.copyWith(status: PlayStatus.onPileOfShame),
        );
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
          AppLocalizationsDe(),
          PlayStatus.playing,
        );
        expect(response, "Am Spielen");
      });
      test("returns correct EN string", () {
        final response = grouper.groupToLocaleString(
          AppLocalizationsEn(),
          PlayStatus.playing,
        );
        expect(response, "Playing");
      });
    });
  });
  group("GameGrouperByAgeRating", () {
    const GameGrouperByAgeRating grouper = GameGrouperByAgeRating();
    group("matchesGroup", () {
      test("returns true if the age rating matches the group", () {
        final response = grouper.matchesGroup(
          USK.usk12,
          TestGames.gameDarkSouls.copyWith(usk: USK.usk12),
        );
        expect(response, true);
      });
      test("returns false if the age rating does not match the group", () {
        final response = grouper.matchesGroup(
          USK.usk16,
          TestGames.gameDarkSouls.copyWith(usk: USK.usk12),
        );
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
    const GameGrouperByIsFavorite grouper = GameGrouperByIsFavorite();
    group("matchesGroup", () {
      test("returns true if the favorite-flag matches the group", () {
        final response = grouper.matchesGroup(
          true,
          TestGames.gameDarkSouls.copyWith(isFavorite: true),
        );
        expect(response, true);
      });
      test("returns false if the favorite-flag does not match the group", () {
        final response = grouper.matchesGroup(
          true,
          TestGames.gameDarkSouls.copyWith(isFavorite: false),
        );
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
    const GameGrouperByHasNotes grouper = GameGrouperByHasNotes();
    group("matchesGroup", () {
      test("returns true if notes exist and the group is true", () {
        final response = grouper.matchesGroup(
          true,
          TestGames.gameDarkSouls.copyWith(notes: "some notes"),
        );
        expect(response, true);
      });
      test("returns false if notes exist the group is false", () {
        final response = grouper.matchesGroup(
          false,
          TestGames.gameDarkSouls.copyWith(notes: "some notes"),
        );
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
  group("GameGrouperByHasDLCs", () {
    const GameGrouperByHasDLCs grouper = GameGrouperByHasDLCs();
    group("matchesGroup", () {
      test("returns true if DLCs exist and the group is true", () {
        final response = grouper.matchesGroup(true, TestGames.gameDarkSouls);
        expect(response, true);
      });
      test("returns false if DLCs exist the group is false", () {
        final response = grouper.matchesGroup(false, TestGames.gameDarkSouls);
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
        expect(response, "hat DLCs");
      });
      test("returns correct EN string", () {
        final response =
            grouper.groupToLocaleString(AppLocalizationsEn(), true);
        expect(response, "has DLCs");
      });
    });
  });
}
