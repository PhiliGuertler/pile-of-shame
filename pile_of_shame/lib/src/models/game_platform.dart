import 'package:flutter/material.dart';

class GamePlatform {
  final String name;
  final String abbreviation;
  final int rawgId;
  final Color color;

  @override
  String toString() {
    return '$name [$abbreviation]';
  }

  const GamePlatform(
      {required this.name,
      required this.rawgId,
      required this.abbreviation,
      required this.color});
}

class GamePlatforms {
  // private constructor as this class is not meant to be instantiated
  GamePlatforms._();

  /// finds and returns a GamePlatform by its name
  static GamePlatform byName(String name) {
    List<GamePlatform> allPlatforms = GamePlatforms.toList();
    final matches = allPlatforms.where((element) => element.name == name);
    if (matches.length == 1) {
      return matches.first;
    }
    throw Exception('Platform $name does not exist');
  }

  // ######################################################################## //
  // ### PC ################################################################# //
  // ######################################################################## //

  static final GamePlatform pc = GamePlatform(
      name: 'PC',
      abbreviation: 'PC',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcSteam = GamePlatform(
      name: 'PC: Steam',
      abbreviation: 'Steam',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcGog = GamePlatform(
      name: 'PC: Gog',
      abbreviation: 'Gog',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcUPlay = GamePlatform(
      name: 'PC: U-Play',
      abbreviation: 'U-Play',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcEpic = GamePlatform(
      name: 'PC: Epic',
      abbreviation: 'Epic',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcTwitch = GamePlatform(
      name: 'PC: Twitch',
      abbreviation: 'Twitch',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform pcXBox = GamePlatform(
      name: 'PC: XBox',
      abbreviation: 'XBox (PC)',
      rawgId: 4,
      color: Colors.blueGrey.shade900);
  static final GamePlatform vrSteam = GamePlatform(
      name: 'VR: Steam',
      abbreviation: 'SteamVR',
      rawgId: 4,
      color: Colors.blueGrey.shade900);

  // ######################################################################## //
  // ### Sony ############################################################### //
  // ######################################################################## //

  static final GamePlatform playstation1 = GamePlatform(
      name: 'PlayStation',
      abbreviation: 'PS1',
      rawgId: 27,
      color: Colors.grey.shade300);
  static final GamePlatform playstation2 = GamePlatform(
      name: 'PlayStation 2',
      abbreviation: 'PS2',
      rawgId: 15,
      color: Colors.grey.shade800);
  static final GamePlatform playstation3 = GamePlatform(
      name: 'PlayStation 3',
      abbreviation: 'PS3',
      rawgId: 16,
      color: Colors.blue.shade800);
  static final GamePlatform playstation4 = GamePlatform(
      name: 'PlayStation 4',
      abbreviation: 'PS4',
      rawgId: 18,
      color: Colors.blue.shade600);
  static final GamePlatform playstation4PSPlus = GamePlatform(
      name: 'PlayStation 4 (PS+)',
      abbreviation: 'PS4 (PS+)',
      rawgId: 18,
      color: Colors.blue.shade600);
  static final GamePlatform playstation5 = GamePlatform(
      name: 'PlayStation 5',
      abbreviation: 'PS5',
      rawgId: 187,
      color: Colors.grey.shade50);
  static final GamePlatform playstation5PSPlus = GamePlatform(
      name: 'PlayStation 5 (PS+)',
      abbreviation: 'PS5 (PS+)',
      rawgId: 187,
      color: Colors.grey.shade50);
  static final GamePlatform playstationPortable = GamePlatform(
      name: 'PlayStation Portable',
      abbreviation: 'PSP',
      rawgId: 17,
      color: Colors.grey.shade600);
  static final GamePlatform playstationVita = GamePlatform(
      name: 'PlayStation Vita',
      abbreviation: 'PS Vita',
      rawgId: 19,
      color: Colors.blue.shade400);
  static final GamePlatform playstationVR = GamePlatform(
      name: 'PlayStation VR',
      abbreviation: 'PS VR',
      rawgId: 18,
      color: Colors.blue.shade600);
  static final GamePlatform playstationVR2 = GamePlatform(
      name: 'PlayStation VR 2',
      abbreviation: 'PS VR 2',
      rawgId: 187,
      color: Colors.grey.shade50);

  // ######################################################################## //
  // ### Microsoft ########################################################## //
  // ######################################################################## //

  static final GamePlatform xboxOriginal = GamePlatform(
      name: 'XBox',
      abbreviation: 'XBox',
      rawgId: 80,
      color: Colors.green.shade300);
  static const GamePlatform xbox360 = GamePlatform(
      name: 'XBox 360',
      abbreviation: 'XBox 360',
      rawgId: 14,
      color: Colors.green);
  static final GamePlatform xboxOne = GamePlatform(
      name: 'XBox One',
      abbreviation: 'XBox One',
      rawgId: 1,
      color: Colors.green.shade700);
  static final GamePlatform xboxSeriesXS = GamePlatform(
      name: 'XBox Series S/X',
      abbreviation: 'XBox Series S/X',
      rawgId: 186,
      color: Colors.green.shade900);

  // ######################################################################## //
  // ### Nintendo ########################################################### //
  // ######################################################################## //

  static const GamePlatform nes = GamePlatform(
      name: 'Nintendo Entertainment System',
      abbreviation: 'NES',
      rawgId: 49,
      color: Colors.grey);
  static const GamePlatform snes = GamePlatform(
      name: 'Super Nintendo Entertainment System',
      abbreviation: 'SNES',
      rawgId: 79,
      color: Colors.purple);
  static final GamePlatform nintendo64 = GamePlatform(
      name: 'Nintendo 64',
      abbreviation: 'N64',
      rawgId: 83,
      color: Colors.yellow.shade900);
  static final GamePlatform nintendoGameCube = GamePlatform(
      name: 'Nintendo GameCube',
      abbreviation: 'GCN',
      rawgId: 105,
      color: Colors.purple.shade900);
  static const GamePlatform nintendoWii = GamePlatform(
      name: 'Nintendo Wii',
      abbreviation: 'Wii',
      rawgId: 11,
      color: Colors.white);
  static const GamePlatform virtualConsoleWii = GamePlatform(
      name: 'Virtual Console: Wii',
      abbreviation: 'Wii:VC',
      rawgId: 11,
      color: Colors.white);
  static const GamePlatform nintendoWiiU = GamePlatform(
      name: 'Nintendo Wii U',
      abbreviation: 'Wii U',
      rawgId: 10,
      color: Colors.cyan);
  static const GamePlatform nintendoSwitch = GamePlatform(
      name: 'Nintendo Switch',
      abbreviation: 'Switch',
      rawgId: 7,
      color: Colors.red);
  static const GamePlatform nintendoSwitchOnline = GamePlatform(
      name: 'Nintendo Switch Online',
      abbreviation: 'Switch Online',
      rawgId: 7,
      color: Colors.red);

  static const GamePlatform gameBoy = GamePlatform(
      name: 'GameBoy', abbreviation: 'GB', rawgId: 26, color: Colors.blueGrey);
  static const GamePlatform gameBoyColor = GamePlatform(
      name: 'GameBoy Color',
      abbreviation: 'GBC',
      rawgId: 43,
      color: Colors.lime);
  static final GamePlatform gameBoyAdvance = GamePlatform(
      name: 'GameBoy Advance',
      abbreviation: 'GBA',
      rawgId: 24,
      color: Colors.purple.shade700);
  static final GamePlatform nintendoDS = GamePlatform(
      name: 'Nintendo DS',
      abbreviation: 'DS',
      rawgId: 9,
      color: Colors.cyan.shade200);
  static final GamePlatform nintendoDSi = GamePlatform(
      name: 'Nintendo DSi',
      abbreviation: 'DSi',
      rawgId: 13,
      color: Colors.pink.shade900);
  static final GamePlatform nintendo3DS = GamePlatform(
      name: 'Nintendo 3DS',
      abbreviation: '3DS',
      rawgId: 8,
      color: Colors.lightBlue.shade300);
  static final GamePlatform virtualConsole3DS = GamePlatform(
      name: 'Virtual Console: 3DS',
      abbreviation: '3DS:VC',
      rawgId: 8,
      color: Colors.lightBlue.shade300);

  static List<GamePlatform> toList() {
    return [
      // PC
      pc,
      pcSteam,
      pcGog,
      pcUPlay,
      pcEpic,
      pcTwitch,
      pcXBox,
      vrSteam,
      // Sony
      playstation1,
      playstation2,
      playstation3,
      playstation4,
      playstation4PSPlus,
      playstation5,
      playstation5PSPlus,
      playstationPortable,
      playstationVita,
      playstationVR,
      playstationVR2,
      // Microsoft
      xboxOriginal,
      xbox360,
      xboxOne,
      xboxSeriesXS,
      // Nintendo
      nes,
      snes,
      nintendo64,
      nintendoGameCube,
      nintendoWii,
      virtualConsoleWii,
      nintendoWiiU,
      nintendoSwitch,
      nintendoSwitchOnline,
      gameBoy,
      gameBoyColor,
      gameBoyAdvance,
      nintendoDS,
      nintendoDSi,
      nintendo3DS,
      virtualConsole3DS
    ];
  }
}
