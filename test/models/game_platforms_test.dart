import 'package:flutter_test/flutter_test.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

void main() {
  test("Assembles icon path as expected", () {
    final iconPath = GamePlatform.playStation5.iconPath;
    expect(iconPath, 'assets/platforms/icons/sony/ps5.png');
  });
  test("Assembles text-logo path as expected", () {
    final iconPath = GamePlatform.nintendo3DS.textLogoPath;
    expect(iconPath, 'assets/platforms/text_logos/nintendo/nintendo_3ds.png');
  });
}
