import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

void main() {
  test("Assembles icon path as expected", () {
    final iconPath = GamePlatform.playStation5.iconPath;
    expect(iconPath, 'assets/platforms/icons/sony/ps5.webp');
  });
  test("Assembles text-logo path as expected", () {
    final iconPath = GamePlatform.nintendo3DS.textLogoPath;
    expect(iconPath, 'assets/platforms/text_logos/nintendo/nintendo_3ds.webp');
  });
  test("Assembles controller-light path as expected", () {
    final iconPath = GamePlatform.xbox360.controllerLogoPathLight;
    expect(
        iconPath, 'assets/platforms/controllers/microsoft/xbox_360_light.webp');
  });
  test("Assembles controller-dark path as expected", () {
    final iconPath = GamePlatform.steam.controllerLogoPathDark;
    expect(iconPath, 'assets/platforms/controllers/pc/steam_dark.webp');
  });
}
