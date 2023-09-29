import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/assets.dart';

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
  sega,
  misc,
  ;

  String toLocale(AppLocalizations l10n) {
    switch (this) {
      case GamePlatformFamily.sony:
        return l10n.sony;
      case GamePlatformFamily.microsoft:
        return l10n.microsoft;
      case GamePlatformFamily.nintendo:
        return l10n.nintendo;
      case GamePlatformFamily.pc:
        return l10n.pc;
      case GamePlatformFamily.sega:
        return l10n.sega;
      case GamePlatformFamily.misc:
        return l10n.misc;
    }
  }
}

@JsonEnum(valueField: 'abbreviation')
enum GamePlatform {
  // ##### Platforms ######################################################## //
  // #### Nintendo ########################################################## //
  // ### Handhelds ########################################################## //
  gameAndWatch(
    family: GamePlatformFamily.nintendo,
    name: "Game & Watch",
    abbreviation: "Game & Watch",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerGameAndWatch,
    icon: ImageAssets.iconGameAndWatch,
  ),
  gameBoy(
    family: GamePlatformFamily.nintendo,
    name: "GameBoy",
    abbreviation: "GB",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerGameBoy,
    icon: ImageAssets.iconGameBoy,
  ),
  gameBoyColor(
    family: GamePlatformFamily.nintendo,
    name: "GameBoy Color",
    abbreviation: "GBC",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerGameBoyColor,
    icon: ImageAssets.iconGameBoyColor,
  ),
  gameBoyAdvance(
    family: GamePlatformFamily.nintendo,
    name: "GameBoy Advance",
    abbreviation: "GBA",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerGameBoyAdvance,
    icon: ImageAssets.iconGameBoyAdvance,
  ),
  nintendoDS(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo DS",
    abbreviation: "NDS",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerNintendoDS,
    icon: ImageAssets.iconNintendoDS,
  ),
  nintendoDSi(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo DSi",
    abbreviation: "DSi",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerNintendoDSi,
    icon: ImageAssets.iconNintendoDSi,
  ),
  nintendo3DS(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo 3DS",
    abbreviation: "3DS",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerNintendo3DS,
    icon: ImageAssets.iconNintendo3DS,
  ),
  newNintendo3DS(
    family: GamePlatformFamily.nintendo,
    name: "new Nintendo 3DS",
    abbreviation: "new 3DS",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerNewNintendo3DS,
    icon: ImageAssets.iconNewNintendo3DS,
  ),
  // ### Stationaries ####################################################### //
  nes(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo Entertainment System",
    abbreviation: "NES",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerNES,
    icon: ImageAssets.iconNES,
  ),
  snes(
    family: GamePlatformFamily.nintendo,
    name: "Super Nintendo Entertainment System",
    abbreviation: "SNES",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerSNES,
    icon: ImageAssets.iconSNES,
  ),
  nintendo64(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo 64",
    abbreviation: "N64",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerNintendo64,
    icon: ImageAssets.iconNintendo64,
  ),
  gameCube(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo GameCube",
    abbreviation: "GCN",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerGameCube,
    icon: ImageAssets.iconGameCube,
  ),
  wii(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo Wii",
    abbreviation: "Wii",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerNintendoWii,
    icon: ImageAssets.iconNintendoWii,
  ),
  wiiU(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo Wii U",
    abbreviation: "Wii U",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerNintendoWiiU,
    icon: ImageAssets.iconNintendoWiiU,
  ),
  nintendoSwitch(
    family: GamePlatformFamily.nintendo,
    name: "Nintendo Switch",
    abbreviation: "Switch",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerNintendoSwitch,
    icon: ImageAssets.iconNintendoSwitch,
  ),
  // #### Sony ############################################################## //
  // ### Handhelds ########################################################## //
  playStationPortable(
    family: GamePlatformFamily.sony,
    name: "PlayStation Portable",
    abbreviation: "PSP",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerPSP,
    icon: ImageAssets.iconPSP,
  ),
  playStationVita(
    family: GamePlatformFamily.sony,
    name: "PlayStation Vita",
    abbreviation: "PS Vita",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerPSVita,
    icon: ImageAssets.iconPSVita,
  ),
  // ### Stationaries ####################################################### //
  playStation1(
    family: GamePlatformFamily.sony,
    name: "PlayStation",
    abbreviation: "PSX",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPS1,
    icon: ImageAssets.iconPS1,
  ),
  playStation2(
    family: GamePlatformFamily.sony,
    name: "PlayStation 2",
    abbreviation: "PS2",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPS2,
    icon: ImageAssets.iconPS2,
  ),
  playStation3(
    family: GamePlatformFamily.sony,
    name: "PlayStation 3",
    abbreviation: "PS3",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPS3,
    icon: ImageAssets.iconPS3,
  ),
  playStation4(
    family: GamePlatformFamily.sony,
    name: "PlayStation 4",
    abbreviation: "PS4",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPS4,
    icon: ImageAssets.iconPS4,
  ),
  playStation5(
    family: GamePlatformFamily.sony,
    name: "PlayStation 5",
    abbreviation: "PS5",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPS5,
    icon: ImageAssets.iconPS5,
  ),
  // #### Microsoft ######################################################### //
  // ### Stationaries ####################################################### //
  xbox(
    family: GamePlatformFamily.microsoft,
    name: "XBox",
    abbreviation: "XBox",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerXBox,
    icon: ImageAssets.iconXBox,
  ),
  xbox360(
    family: GamePlatformFamily.microsoft,
    name: "XBox 360",
    abbreviation: "XBox 360",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerXBox360,
    icon: ImageAssets.iconXBox360,
  ),
  xboxOne(
    family: GamePlatformFamily.microsoft,
    name: "XBox One",
    abbreviation: "XBone",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerXBoxOne,
    icon: ImageAssets.iconXBoxOne,
  ),
  xboxSeries(
    family: GamePlatformFamily.microsoft,
    name: "XBox Series",
    abbreviation: "XBox Series",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerXBoxSeries,
    icon: ImageAssets.iconXBoxSeries,
  ),
  // #### SEGA ############################################################## //
  // ### Stationaries ####################################################### //
  segaMegaDrive(
    family: GamePlatformFamily.sega,
    name: "SEGA Mega Drive",
    abbreviation: "SMD",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerSegaMegaDrive,
    icon: ImageAssets.iconSegaMegaDrive,
  ),
  segaGameGear(
    family: GamePlatformFamily.sega,
    name: "SEGA Game Gear",
    abbreviation: "SGG",
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerSegaGameGear,
    icon: ImageAssets.iconSegaGameGear,
  ),
  segaSaturn(
    family: GamePlatformFamily.sega,
    name: "SEGA Saturn",
    abbreviation: "SS",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerSegaSaturn,
    icon: ImageAssets.iconSegaSaturn,
  ),
  segaDreamcast(
    family: GamePlatformFamily.sega,
    name: "SEGA Dreamcast",
    abbreviation: "SD",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerSegaDreamcast,
    icon: ImageAssets.iconSegaDreamcast,
  ),
  // #### PC ################################################################ //
  // ### Stationaries ####################################################### //
  pcMisc(
    family: GamePlatformFamily.pc,
    name: "PC",
    abbreviation: "PC",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerPC,
    icon: ImageAssets.iconPC,
  ),
  gog(
    family: GamePlatformFamily.pc,
    name: "Gog",
    abbreviation: "Gog",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerGog,
    icon: ImageAssets.iconGog,
  ),
  origin(
    family: GamePlatformFamily.pc,
    name: "Origin",
    abbreviation: "EA",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerOrigin,
    icon: ImageAssets.iconOrigin,
  ),
  steam(
    family: GamePlatformFamily.pc,
    name: "Steam",
    abbreviation: "Steam",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerSteam,
    icon: ImageAssets.iconSteam,
  ),
  ubisoftConnect(
    family: GamePlatformFamily.pc,
    name: "Ubisoft Connect",
    abbreviation: "Ubi",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerUbisoftConnect,
    icon: ImageAssets.iconUbisoftConnect,
  ),
  epicGames(
    family: GamePlatformFamily.pc,
    name: "Epic",
    abbreviation: "Epic",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerEpic,
    icon: ImageAssets.iconEpic,
  ),
  twitch(
    family: GamePlatformFamily.pc,
    name: "Twitch",
    abbreviation: "Twitch",
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerTwitch,
    icon: ImageAssets.iconTwitch,
  ),
  // #### Misc ############################################################## //
  smartphone(
    family: GamePlatformFamily.misc,
    abbreviation: 'phone',
    name: 'Smartphone',
    type: GamePlatformType.handheld,
    controller: ImageAssets.controllerSmartphone,
    icon: ImageAssets.iconSmartphone,
  ),
  unknown(
    abbreviation: 'unknown',
    family: GamePlatformFamily.misc,
    name: 'unknown',
    type: GamePlatformType.stationary,
    controller: ImageAssets.controllerUnknown,
    icon: ImageAssets.iconUnknown,
  ),
  ;

  final String name;
  final String abbreviation;
  final GamePlatformType type;
  final GamePlatformFamily family;
  final ImageAssets controller;
  final ImageAssets icon;

  const GamePlatform({
    required this.name,
    required this.abbreviation,
    required this.type,
    required this.family,
    required this.controller,
    required this.icon,
  });

  String get iconPath => icon.value;

  String get controllerLogoPath => controller.value;

  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case GamePlatform.unknown:
        return l10n.misc;
      default:
        return name;
    }
  }

  String localizedAbbreviation(AppLocalizations l10n) {
    switch (this) {
      case GamePlatform.unknown:
        return l10n.misc;
      case GamePlatform.smartphone:
        return l10n.phone;
      default:
        return abbreviation;
    }
  }
}
