class GamePlatform {
  final String name;
  final String abbreviation;
  final int rawgId;

  @override
  String toString() {
    return '$name [$abbreviation]';
  }

  const GamePlatform(
      {required this.name, required this.rawgId, required this.abbreviation});
}

class GamePlatforms {
  // private constructor as this class is not meant to be instantiated
  GamePlatforms._();

  // ######################################################################## //
  // ### PC ################################################################# //
  // ######################################################################## //

  static const GamePlatform pc =
      GamePlatform(name: 'PC', abbreviation: 'PC', rawgId: 4);
  static const GamePlatform pcSteam =
      GamePlatform(name: 'PC: Steam', abbreviation: 'Steam', rawgId: 4);
  static const GamePlatform pcGog =
      GamePlatform(name: 'PC: Gog', abbreviation: 'Gog', rawgId: 4);
  static const GamePlatform pcUPlay =
      GamePlatform(name: 'PC: U-Play', abbreviation: 'U-Play', rawgId: 4);
  static const GamePlatform pcEpic =
      GamePlatform(name: 'PC: Epic', abbreviation: 'Epic', rawgId: 4);
  static const GamePlatform pcTwitch =
      GamePlatform(name: 'PC: Twitch', abbreviation: 'Twitch', rawgId: 4);
  static const GamePlatform pcXBox =
      GamePlatform(name: 'PC: XBox', abbreviation: 'XBox (PC)', rawgId: 4);
  static const GamePlatform vrSteam =
      GamePlatform(name: 'VR: Steam', abbreviation: 'SteamVR', rawgId: 4);

  // ######################################################################## //
  // ### Sony ############################################################### //
  // ######################################################################## //

  static const GamePlatform playstation1 =
      GamePlatform(name: 'PlayStation', abbreviation: 'PS1', rawgId: 27);
  static const GamePlatform playstation2 =
      GamePlatform(name: 'PlayStation 2', abbreviation: 'PS2', rawgId: 15);
  static const GamePlatform playstation3 =
      GamePlatform(name: 'PlayStation 3', abbreviation: 'PS3', rawgId: 16);
  static const GamePlatform playstation4 =
      GamePlatform(name: 'PlayStation 4', abbreviation: 'PS4', rawgId: 18);
  static const GamePlatform playstation4PSPlus = GamePlatform(
      name: 'PlayStation 4 (PS+)', abbreviation: 'PS4 (PS+)', rawgId: 18);
  static const GamePlatform playstation5 =
      GamePlatform(name: 'PlayStation 5', abbreviation: 'PS5', rawgId: 187);
  static const GamePlatform playstation5PSPlus = GamePlatform(
      name: 'PlayStation 5 (PS+)', abbreviation: 'PS5 (PS+)', rawgId: 187);
  static const GamePlatform playstationPortable = GamePlatform(
      name: 'PlayStation Portable', abbreviation: 'PSP', rawgId: 17);
  static const GamePlatform playstationVita = GamePlatform(
      name: 'PlayStation Vita', abbreviation: 'PS Vita', rawgId: 19);
  static const GamePlatform playstationVR =
      GamePlatform(name: 'PlayStation VR', abbreviation: 'PS VR', rawgId: 18);
  static const GamePlatform playstationVR2 = GamePlatform(
      name: 'PlayStation VR 2', abbreviation: 'PS VR 2', rawgId: 187);

  // ######################################################################## //
  // ### Microsoft ########################################################## //
  // ######################################################################## //

  static const GamePlatform xboxOriginal =
      GamePlatform(name: 'XBox', abbreviation: 'XBox', rawgId: 80);
  static const GamePlatform xbox360 =
      GamePlatform(name: 'XBox 360', abbreviation: 'XBox 360', rawgId: 14);
  static const GamePlatform xboxOne =
      GamePlatform(name: 'XBox One', abbreviation: 'XBox One', rawgId: 1);
  static const GamePlatform xboxSeriesXS = GamePlatform(
      name: 'XBox Series S/X', abbreviation: 'XBox Series S/X', rawgId: 186);

  // ######################################################################## //
  // ### Nintendo ########################################################### //
  // ######################################################################## //

  static const GamePlatform nes = GamePlatform(
      name: 'Nintendo Entertainment System', abbreviation: 'NES', rawgId: 49);
  static const GamePlatform snes = GamePlatform(
      name: 'Super Nintendo Entertainment System',
      abbreviation: 'SNES',
      rawgId: 79);
  static const GamePlatform nintendo64 =
      GamePlatform(name: 'Nintendo 64', abbreviation: 'N64', rawgId: 83);
  static const GamePlatform nintendoGameCube =
      GamePlatform(name: 'Nintendo GameCube', abbreviation: 'GCN', rawgId: 105);
  static const GamePlatform nintendoWii =
      GamePlatform(name: 'Nintendo Wii', abbreviation: 'Wii', rawgId: 11);
  static const GamePlatform virtualConsoleWii = GamePlatform(
      name: 'Virtual Console: Wii', abbreviation: 'Wii:VC', rawgId: 11);
  static const GamePlatform nintendoWiiU =
      GamePlatform(name: 'Nintendo Wii U', abbreviation: 'Wii U', rawgId: 10);
  static const GamePlatform nintendoSwitch =
      GamePlatform(name: 'Nintendo Switch', abbreviation: 'Switch', rawgId: 7);
  static const GamePlatform nintendoSwitchOnline = GamePlatform(
      name: 'Nintendo Switch Online', abbreviation: 'Switch Online', rawgId: 7);

  static const GamePlatform gameBoy =
      GamePlatform(name: 'GameBoy', abbreviation: 'GB', rawgId: 26);
  static const GamePlatform gameBoyColor =
      GamePlatform(name: 'GameBoy Color', abbreviation: 'GBC', rawgId: 43);
  static const GamePlatform gameBoyAdvance =
      GamePlatform(name: 'GameBoy Advance', abbreviation: 'GBA', rawgId: 24);
  static const GamePlatform nintendoDS =
      GamePlatform(name: 'Nintendo DS', abbreviation: 'DS', rawgId: 9);
  static const GamePlatform nintendoDSi =
      GamePlatform(name: 'Nintendo DSi', abbreviation: 'DSi', rawgId: 13);
  static const GamePlatform nintendo3DS =
      GamePlatform(name: 'Nintendo 3DS', abbreviation: '3DS', rawgId: 8);
  static const GamePlatform virtualConsole3DS = GamePlatform(
      name: 'Virtual Console: 3DS', abbreviation: '3DS:VC', rawgId: 8);

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
