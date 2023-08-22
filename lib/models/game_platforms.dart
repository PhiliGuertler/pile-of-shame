import 'package:freezed_annotation/freezed_annotation.dart';

const String _iconBasePath = "assets/platforms/icons";
const String _textLogoBasePath = "assets/platforms/text_logos";

enum GamePlatformType {
  stationary,
  handheld,
  ;
}

enum GamePlatformFamily {
  sony,
  microsoft,
  nintendo,
  pc,
  misc,
  ;
}

@JsonEnum(valueField: 'abbreviation')
enum GamePlatform {
  // ##### Platforms ######################################################## //
  // #### Nintendo ########################################################## //
  // ### Handhelds ########################################################## //
  gameAndWatch(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_and_watch.png",
    name: "Game & Watch",
    abbreviation: "Game & Watch",
    type: GamePlatformType.handheld,
  ),
  gameBoy(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy.png",
    name: "GameBoy",
    abbreviation: "GB",
    type: GamePlatformType.handheld,
  ),
  gameBoyColor(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy_color.png",
    name: "GameBoy Color",
    abbreviation: "GBC",
    type: GamePlatformType.handheld,
  ),
  gameBoyAdvance(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy_advance.png",
    name: "GameBoy Advance",
    abbreviation: "GBA",
    type: GamePlatformType.handheld,
  ),
  nintendoDS(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_ds.png",
    name: "Nintendo DS",
    abbreviation: "NDS",
    type: GamePlatformType.handheld,
  ),
  nintendoDSi(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_dsi.png",
    name: "Nintendo DSi",
    abbreviation: "DSi",
    type: GamePlatformType.handheld,
  ),
  nintendo3DS(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_3ds.png",
    name: "Nintendo 3DS",
    abbreviation: "3DS",
    type: GamePlatformType.handheld,
  ),
  newNintendo3DS(
    family: GamePlatformFamily.nintendo,
    assetPath: "new_nintendo_3ds.png",
    name: "new Nintendo 3DS",
    abbreviation: "new 3DS",
    type: GamePlatformType.handheld,
  ),
  // ### Stationaries ####################################################### //
  nes(
    family: GamePlatformFamily.nintendo,
    assetPath: "nes.png",
    name: "Nintendo Entertainment System",
    abbreviation: "NES",
    type: GamePlatformType.stationary,
  ),
  snes(
    family: GamePlatformFamily.nintendo,
    assetPath: "super_nes.png",
    name: "Super Nintendo Entertainment System",
    abbreviation: "SNES",
    type: GamePlatformType.stationary,
  ),
  nintendo64(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_64.png",
    name: "Nintendo 64",
    abbreviation: "N64",
    type: GamePlatformType.stationary,
  ),
  gameCube(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_cube.png",
    name: "Nintendo GameCube",
    abbreviation: "GCN",
    type: GamePlatformType.stationary,
  ),
  wii(
    family: GamePlatformFamily.nintendo,
    assetPath: "wii.png",
    name: "Nintendo Wii",
    abbreviation: "Wii",
    type: GamePlatformType.stationary,
  ),
  wiiU(
    family: GamePlatformFamily.nintendo,
    assetPath: "wii_u.png",
    name: "Nintendo Wii U",
    abbreviation: "Wii U",
    type: GamePlatformType.stationary,
  ),
  nintendoSwitch(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_switch.png",
    name: "Nintendo Switch",
    abbreviation: "Switch",
    type: GamePlatformType.stationary,
  ),
  // #### Sony ############################################################## //
  // ### Handhelds ########################################################## //
  playStationPortable(
    family: GamePlatformFamily.sony,
    assetPath: "psp.png",
    name: "PlayStation Portable",
    abbreviation: "PSP",
    type: GamePlatformType.handheld,
  ),
  playStationVita(
    family: GamePlatformFamily.sony,
    assetPath: "ps_vita.png",
    name: "PlayStation Vita",
    abbreviation: "PS Vita",
    type: GamePlatformType.handheld,
  ),
  // ### Stationaries ####################################################### //
  playStation1(
    family: GamePlatformFamily.sony,
    assetPath: "ps1.png",
    name: "PlayStation",
    abbreviation: "PSX",
    type: GamePlatformType.stationary,
  ),
  playStation2(
    family: GamePlatformFamily.sony,
    assetPath: "ps2.png",
    name: "PlayStation 2",
    abbreviation: "PS2",
    type: GamePlatformType.stationary,
  ),
  playStation3(
    family: GamePlatformFamily.sony,
    assetPath: "ps3.png",
    name: "PlayStation 3",
    abbreviation: "PS3",
    type: GamePlatformType.stationary,
  ),
  playStation4(
    family: GamePlatformFamily.sony,
    assetPath: "ps4.png",
    name: "PlayStation 4",
    abbreviation: "PS4",
    type: GamePlatformType.stationary,
  ),
  playStation5(
    family: GamePlatformFamily.sony,
    assetPath: "ps5.png",
    name: "PlayStation 5",
    abbreviation: "PS5",
    type: GamePlatformType.stationary,
  ),
  // #### Microsoft ######################################################### //
  // ### Stationaries ####################################################### //
  xbox(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox.png",
    name: "XBox",
    abbreviation: "XBox",
    type: GamePlatformType.stationary,
  ),
  xbox360(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_360.png",
    name: "XBox 360",
    abbreviation: "XBox 360",
    type: GamePlatformType.stationary,
  ),
  xboxOne(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_one.png",
    name: "XBox One",
    abbreviation: "XBone",
    type: GamePlatformType.stationary,
  ),
  xboxSeries(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_series.png",
    name: "XBox Series",
    abbreviation: "XBox Series",
    type: GamePlatformType.stationary,
  ),
  // #### PC ################################################################ //
  // ### Stationaries ####################################################### //
  pcMisc(
    family: GamePlatformFamily.pc,
    assetPath: "pc.png",
    name: "PC",
    abbreviation: "PC",
    type: GamePlatformType.stationary,
  ),
  gog(
    family: GamePlatformFamily.pc,
    assetPath: "gog.png",
    name: "Gog",
    abbreviation: "Gog",
    type: GamePlatformType.stationary,
  ),
  origin(
    family: GamePlatformFamily.pc,
    assetPath: "origin.png",
    name: "Origin",
    abbreviation: "EA",
    type: GamePlatformType.stationary,
  ),
  steam(
    family: GamePlatformFamily.pc,
    assetPath: "steam.png",
    name: "Steam",
    abbreviation: "Steam",
    type: GamePlatformType.stationary,
  ),
  ubisoftConnect(
    family: GamePlatformFamily.pc,
    assetPath: "ubisoft_connect.png",
    name: "Ubisoft Connect",
    abbreviation: "Ubi",
    type: GamePlatformType.stationary,
  ),
  epicGames(
    family: GamePlatformFamily.pc,
    assetPath: "epic_games.png",
    name: "Epic",
    abbreviation: "Epic",
    type: GamePlatformType.stationary,
  ),
  twitch(
    family: GamePlatformFamily.pc,
    assetPath: "twitch.png",
    name: "Twitch",
    abbreviation: "Twitch",
    type: GamePlatformType.stationary,
  ),
  // #### Misc ############################################################## //
  unknown(
    abbreviation: 'unknown',
    family: GamePlatformFamily.misc,
    assetPath: 'unknown.png',
    name: 'unknown',
    type: GamePlatformType.stationary,
  ),
  ;

  final String assetPath;
  final String name;
  final String abbreviation;
  final GamePlatformType type;
  final GamePlatformFamily family;

  const GamePlatform({
    required this.assetPath,
    required this.name,
    required this.abbreviation,
    required this.type,
    required this.family,
  });

  String get iconPath => "$_iconBasePath/${family.name}/$assetPath";
  String get textLogoPath => "$_textLogoBasePath/${family.name}/$assetPath";
}
