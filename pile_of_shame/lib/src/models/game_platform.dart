import 'package:flutter/material.dart';
import 'package:quiver/core.dart';

class GamePlatform {
  final String name;
  final String abbreviation;
  int? externalPlatformId;
  final Color color;

  @override
  String toString() {
    return '$name [$abbreviation]';
  }

  GamePlatform(
      {required this.name,
      this.externalPlatformId,
      required this.abbreviation,
      required this.color});

  @override
  bool operator ==(Object other) {
    return (other is GamePlatform)
        ? (name == other.name && abbreviation == other.abbreviation)
        : false;
  }

  @override
  int get hashCode {
    return hash2(name, abbreviation);
  }
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
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcSteam = GamePlatform(
    name: 'PC: Steam',
    abbreviation: 'Steam',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcGog = GamePlatform(
    name: 'PC: Gog',
    abbreviation: 'Gog',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcUPlay = GamePlatform(
    name: 'PC: U-Play',
    abbreviation: 'U-Play',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcEpic = GamePlatform(
    name: 'PC: Epic',
    abbreviation: 'Epic',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcTwitch = GamePlatform(
    name: 'PC: Twitch',
    abbreviation: 'Twitch',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform pcXBox = GamePlatform(
    name: 'PC: XBox',
    abbreviation: 'XBox (PC)',
    color: Colors.blueGrey.shade900,
  );
  static final GamePlatform vrSteam = GamePlatform(
    name: 'VR: Steam',
    abbreviation: 'SteamVR',
    color: Colors.blueGrey.shade900,
  );

  // ######################################################################## //
  // ### Sony ############################################################### //
  // ######################################################################## //

  static final GamePlatform playstation1 = GamePlatform(
    name: 'PlayStation',
    abbreviation: 'PS1',
    color: Colors.grey.shade300,
  );
  static final GamePlatform playstation2 = GamePlatform(
    name: 'PlayStation 2',
    abbreviation: 'PS2',
    color: Colors.grey.shade800,
  );
  static final GamePlatform playstation3 = GamePlatform(
    name: 'PlayStation 3',
    abbreviation: 'PS3',
    color: Colors.blue.shade800,
  );
  static final GamePlatform playstation4 = GamePlatform(
    name: 'PlayStation 4',
    abbreviation: 'PS4',
    color: Colors.blue.shade600,
  );
  static final GamePlatform playstation4PSPlus = GamePlatform(
    name: 'PlayStation 4 (PS+)',
    abbreviation: 'PS4 (PS+)',
    color: Colors.blue.shade600,
  );
  static final GamePlatform playstation5 = GamePlatform(
    name: 'PlayStation 5',
    abbreviation: 'PS5',
    color: Colors.grey.shade50,
  );
  static final GamePlatform playstation5PSPlus = GamePlatform(
    name: 'PlayStation 5 (PS+)',
    abbreviation: 'PS5 (PS+)',
    color: Colors.grey.shade50,
  );
  static final GamePlatform playstationPortable = GamePlatform(
    name: 'PlayStation Portable',
    abbreviation: 'PSP',
    color: Colors.grey.shade600,
  );
  static final GamePlatform playstationVita = GamePlatform(
    name: 'PlayStation Vita',
    abbreviation: 'PS Vita',
    color: Colors.blue.shade400,
  );
  static final GamePlatform playstationVR = GamePlatform(
    name: 'PlayStation VR',
    abbreviation: 'PS VR',
    color: Colors.blue.shade600,
  );
  static final GamePlatform playstationVR2 = GamePlatform(
    name: 'PlayStation VR 2',
    abbreviation: 'PS VR 2',
    color: Colors.grey.shade50,
  );

  // ######################################################################## //
  // ### Microsoft ########################################################## //
  // ######################################################################## //

  static final GamePlatform xboxOriginal = GamePlatform(
    name: 'XBox',
    abbreviation: 'XBox',
    color: Colors.green.shade300,
  );
  static final GamePlatform xbox360 = GamePlatform(
    name: 'XBox 360',
    abbreviation: 'XBox 360',
    color: Colors.green,
  );
  static final GamePlatform xboxOne = GamePlatform(
    name: 'XBox One',
    abbreviation: 'XBox One',
    color: Colors.green.shade700,
  );
  static final GamePlatform xboxSeriesXS = GamePlatform(
    name: 'XBox Series S/X',
    abbreviation: 'XBox Series S/X',
    color: Colors.green.shade900,
  );

  // ######################################################################## //
  // ### Nintendo ########################################################### //
  // ######################################################################## //

  static final GamePlatform nes = GamePlatform(
    name: 'Nintendo Entertainment System',
    abbreviation: 'NES',
    color: Colors.grey,
  );
  static final GamePlatform snes = GamePlatform(
    name: 'Super Nintendo Entertainment System',
    abbreviation: 'SNES',
    color: Colors.purple,
  );
  static final GamePlatform nintendo64 = GamePlatform(
    name: 'Nintendo 64',
    abbreviation: 'N64',
    color: Colors.yellow.shade900,
  );
  static final GamePlatform nintendoGameCube = GamePlatform(
    name: 'Nintendo GameCube',
    abbreviation: 'GCN',
    color: Colors.purple.shade900,
  );
  static final GamePlatform nintendoWii = GamePlatform(
    name: 'Nintendo Wii',
    abbreviation: 'Wii',
    color: Colors.white,
  );
  static final GamePlatform virtualConsoleWii = GamePlatform(
    name: 'Virtual Console: Wii',
    abbreviation: 'Wii:VC',
    color: Colors.white,
  );
  static final GamePlatform nintendoWiiU = GamePlatform(
    name: 'Nintendo Wii U',
    abbreviation: 'Wii U',
    color: Colors.cyan,
  );
  static final GamePlatform nintendoSwitch = GamePlatform(
    name: 'Nintendo Switch',
    abbreviation: 'Switch',
    color: Colors.red,
  );
  static final GamePlatform nintendoSwitchOnline = GamePlatform(
    name: 'Nintendo Switch Online',
    abbreviation: 'Switch Online',
    color: Colors.red,
  );

  static final GamePlatform gameBoy = GamePlatform(
    name: 'GameBoy',
    abbreviation: 'GB',
    color: Colors.blueGrey,
  );
  static final GamePlatform gameBoyColor = GamePlatform(
    name: 'GameBoy Color',
    abbreviation: 'GBC',
    color: Colors.lime,
  );
  static final GamePlatform gameBoyAdvance = GamePlatform(
    name: 'GameBoy Advance',
    abbreviation: 'GBA',
    color: Colors.purple.shade700,
  );
  static final GamePlatform nintendoDS = GamePlatform(
    name: 'Nintendo DS',
    abbreviation: 'DS',
    color: Colors.cyan.shade200,
  );
  static final GamePlatform nintendoDSi = GamePlatform(
    name: 'Nintendo DSi',
    abbreviation: 'DSi',
    color: Colors.pink.shade900,
  );
  static final GamePlatform nintendo3DS = GamePlatform(
    name: 'Nintendo 3DS',
    abbreviation: '3DS',
    color: Colors.lightBlue.shade300,
  );
  static final GamePlatform virtualConsole3DS = GamePlatform(
    name: 'Virtual Console: 3DS',
    abbreviation: '3DS:VC',
    color: Colors.lightBlue.shade300,
  );

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
      // vrSteam,
      // Sony
      playstation1,
      playstation2,
      playstation3,
      playstation4,
      // playstation4PSPlus,
      playstation5,
      // playstation5PSPlus,
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
      // virtualConsoleWii,
      nintendoWiiU,
      nintendoSwitch,
      // nintendoSwitchOnline,
      gameBoy,
      gameBoyColor,
      gameBoyAdvance,
      nintendoDS,
      // nintendoDSi,
      nintendo3DS,
      // virtualConsole3DS
    ];
  }
}
