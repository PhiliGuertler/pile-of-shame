import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

const String _iconBasePath = "assets/platforms/icons";
const String _textLogoBasePath = "assets/platforms/text_logos";
const String _controllerBasePath = "assets/platforms/controllers";

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
    assetPath: "game_and_watch",
    name: "Game & Watch",
    abbreviation: "Game & Watch",
    type: GamePlatformType.handheld,
  ),
  gameBoy(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy",
    name: "GameBoy",
    abbreviation: "GB",
    type: GamePlatformType.handheld,
  ),
  gameBoyColor(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy_color",
    name: "GameBoy Color",
    abbreviation: "GBC",
    type: GamePlatformType.handheld,
  ),
  gameBoyAdvance(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_boy_advance",
    name: "GameBoy Advance",
    abbreviation: "GBA",
    type: GamePlatformType.handheld,
  ),
  nintendoDS(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_ds",
    name: "Nintendo DS",
    abbreviation: "NDS",
    type: GamePlatformType.handheld,
  ),
  nintendoDSi(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_dsi",
    name: "Nintendo DSi",
    abbreviation: "DSi",
    type: GamePlatformType.handheld,
  ),
  nintendo3DS(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_3ds",
    name: "Nintendo 3DS",
    abbreviation: "3DS",
    type: GamePlatformType.handheld,
  ),
  newNintendo3DS(
    family: GamePlatformFamily.nintendo,
    assetPath: "new_nintendo_3ds",
    name: "new Nintendo 3DS",
    abbreviation: "new 3DS",
    type: GamePlatformType.handheld,
  ),
  // ### Stationaries ####################################################### //
  nes(
    family: GamePlatformFamily.nintendo,
    assetPath: "nes",
    name: "Nintendo Entertainment System",
    abbreviation: "NES",
    type: GamePlatformType.stationary,
  ),
  snes(
    family: GamePlatformFamily.nintendo,
    assetPath: "super_nes",
    name: "Super Nintendo Entertainment System",
    abbreviation: "SNES",
    type: GamePlatformType.stationary,
  ),
  nintendo64(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_64",
    name: "Nintendo 64",
    abbreviation: "N64",
    type: GamePlatformType.stationary,
  ),
  gameCube(
    family: GamePlatformFamily.nintendo,
    assetPath: "game_cube",
    name: "Nintendo GameCube",
    abbreviation: "GCN",
    type: GamePlatformType.stationary,
  ),
  wii(
    family: GamePlatformFamily.nintendo,
    assetPath: "wii",
    name: "Nintendo Wii",
    abbreviation: "Wii",
    type: GamePlatformType.stationary,
  ),
  wiiU(
    family: GamePlatformFamily.nintendo,
    assetPath: "wii_u",
    name: "Nintendo Wii U",
    abbreviation: "Wii U",
    type: GamePlatformType.stationary,
  ),
  nintendoSwitch(
    family: GamePlatformFamily.nintendo,
    assetPath: "nintendo_switch",
    name: "Nintendo Switch",
    abbreviation: "Switch",
    type: GamePlatformType.stationary,
  ),
  // #### Sony ############################################################## //
  // ### Handhelds ########################################################## //
  playStationPortable(
    family: GamePlatformFamily.sony,
    assetPath: "psp",
    name: "PlayStation Portable",
    abbreviation: "PSP",
    type: GamePlatformType.handheld,
  ),
  playStationVita(
    family: GamePlatformFamily.sony,
    assetPath: "ps_vita",
    name: "PlayStation Vita",
    abbreviation: "PS Vita",
    type: GamePlatformType.handheld,
  ),
  // ### Stationaries ####################################################### //
  playStation1(
    family: GamePlatformFamily.sony,
    assetPath: "ps1",
    name: "PlayStation",
    abbreviation: "PSX",
    type: GamePlatformType.stationary,
  ),
  playStation2(
    family: GamePlatformFamily.sony,
    assetPath: "ps2",
    name: "PlayStation 2",
    abbreviation: "PS2",
    type: GamePlatformType.stationary,
  ),
  playStation3(
    family: GamePlatformFamily.sony,
    assetPath: "ps3",
    name: "PlayStation 3",
    abbreviation: "PS3",
    type: GamePlatformType.stationary,
  ),
  playStation4(
    family: GamePlatformFamily.sony,
    assetPath: "ps4",
    name: "PlayStation 4",
    abbreviation: "PS4",
    type: GamePlatformType.stationary,
  ),
  playStation5(
    family: GamePlatformFamily.sony,
    assetPath: "ps5",
    name: "PlayStation 5",
    abbreviation: "PS5",
    type: GamePlatformType.stationary,
  ),
  // #### Microsoft ######################################################### //
  // ### Stationaries ####################################################### //
  xbox(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox",
    name: "XBox",
    abbreviation: "XBox",
    type: GamePlatformType.stationary,
  ),
  xbox360(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_360",
    name: "XBox 360",
    abbreviation: "XBox 360",
    type: GamePlatformType.stationary,
  ),
  xboxOne(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_one",
    name: "XBox One",
    abbreviation: "XBone",
    type: GamePlatformType.stationary,
  ),
  xboxSeries(
    family: GamePlatformFamily.microsoft,
    assetPath: "xbox_series",
    name: "XBox Series",
    abbreviation: "XBox Series",
    type: GamePlatformType.stationary,
  ),
  // #### PC ################################################################ //
  // ### Stationaries ####################################################### //
  pcMisc(
    family: GamePlatformFamily.pc,
    assetPath: "pc",
    name: "PC",
    abbreviation: "PC",
    type: GamePlatformType.stationary,
  ),
  gog(
    family: GamePlatformFamily.pc,
    assetPath: "gog",
    name: "Gog",
    abbreviation: "Gog",
    type: GamePlatformType.stationary,
  ),
  origin(
    family: GamePlatformFamily.pc,
    assetPath: "origin",
    name: "Origin",
    abbreviation: "EA",
    type: GamePlatformType.stationary,
  ),
  steam(
    family: GamePlatformFamily.pc,
    assetPath: "steam",
    name: "Steam",
    abbreviation: "Steam",
    type: GamePlatformType.stationary,
  ),
  ubisoftConnect(
    family: GamePlatformFamily.pc,
    assetPath: "ubisoft_connect",
    name: "Ubisoft Connect",
    abbreviation: "Ubi",
    type: GamePlatformType.stationary,
  ),
  epicGames(
    family: GamePlatformFamily.pc,
    assetPath: "epic_games",
    name: "Epic",
    abbreviation: "Epic",
    type: GamePlatformType.stationary,
  ),
  twitch(
    family: GamePlatformFamily.pc,
    assetPath: "twitch",
    name: "Twitch",
    abbreviation: "Twitch",
    type: GamePlatformType.stationary,
  ),
  // #### Misc ############################################################## //
  unknown(
    abbreviation: 'unknown',
    family: GamePlatformFamily.misc,
    assetPath: 'unknown',
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

  String get iconPath => "$_iconBasePath/${family.name}/$assetPath.webp";
  String get textLogoPath =>
      "$_textLogoBasePath/${family.name}/$assetPath.webp";
  String get controllerLogoPathLight =>
      "$_controllerBasePath/${family.name}/${assetPath}_light.webp";
  String get controllerLogoPathDark =>
      "$_controllerBasePath/${family.name}/${assetPath}_dark.webp";

  String controllerLogoPath(BuildContext context) {
    final theme = Theme.of(context);
    if (theme.brightness == Brightness.light) {
      return controllerLogoPathLight;
    }
    return controllerLogoPathDark;
  }
}
