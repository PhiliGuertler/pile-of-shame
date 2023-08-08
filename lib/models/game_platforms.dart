import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_platforms.g.dart';
part 'game_platforms.freezed.dart';

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
  ;
}

@freezed
class GamePlatform with _$GamePlatform {
  const GamePlatform._();

  const factory GamePlatform({
    required String assetPath,
    required String name,
    required String abbreviation,
    required GamePlatformType type,
    required GamePlatformFamily family,
  }) = _GamePlatform;

  String get iconPath => "$_iconBasePath/$assetPath";
  String get textLogoPath => "$_textLogoBasePath/$assetPath";

  factory GamePlatform.fromJson(Map<String, dynamic> json) =>
      _$GamePlatformFromJson(json);

  factory GamePlatform.sony({
    required String assetPath,
    required String name,
    required String abbreviation,
    required GamePlatformType type,
  }) =>
      GamePlatform(
        assetPath: "sony/$assetPath",
        name: name,
        abbreviation: abbreviation,
        type: type,
        family: GamePlatformFamily.sony,
      );

  factory GamePlatform.microsoft({
    required String assetPath,
    required String name,
    required String abbreviation,
    required GamePlatformType type,
  }) =>
      GamePlatform(
        assetPath: "microsoft/$assetPath",
        name: name,
        abbreviation: abbreviation,
        type: type,
        family: GamePlatformFamily.microsoft,
      );

  factory GamePlatform.nintendo({
    required String assetPath,
    required String name,
    required String abbreviation,
    required GamePlatformType type,
  }) =>
      GamePlatform(
        assetPath: "nintendo/$assetPath",
        name: name,
        abbreviation: abbreviation,
        type: type,
        family: GamePlatformFamily.nintendo,
      );

  factory GamePlatform.pc({
    required String assetPath,
    required String name,
    required String abbreviation,
    required GamePlatformType type,
  }) =>
      GamePlatform(
        assetPath: "pc/$assetPath",
        name: name,
        abbreviation: abbreviation,
        type: type,
        family: GamePlatformFamily.pc,
      );

  // ##### Platforms ######################################################## //
  // #### Nintendo ########################################################## //
  // ### Handhelds ########################################################## //
  static final GamePlatform gameAndWatch = GamePlatform.nintendo(
    assetPath: "game_and_watch.png",
    name: "Game & Watch",
    abbreviation: "Game & Watch",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform gameBoy = GamePlatform.nintendo(
    assetPath: "game_boy.png",
    name: "GameBoy",
    abbreviation: "GB",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform gameBoyColor = GamePlatform.nintendo(
    assetPath: "game_boy_color.png",
    name: "GameBoy Color",
    abbreviation: "GBC",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform nintendoDS = GamePlatform.nintendo(
    assetPath: "nintendo_ds.png",
    name: "Nintendo DS",
    abbreviation: "NDS",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform nintendoDSi = GamePlatform.nintendo(
    assetPath: "nintendo_dsi.png",
    name: "Nintendo DSi",
    abbreviation: "DSi",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform nintendo3DS = GamePlatform.nintendo(
    assetPath: "nintendo_3ds.png",
    name: "Nintendo 3DS",
    abbreviation: "3DS",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform newNintendo3DS = GamePlatform.nintendo(
    assetPath: "new_nintendo_3ds.png",
    name: "new Nintendo 3DS",
    abbreviation: "new 3DS",
    type: GamePlatformType.handheld,
  );
  // ### Stationaries ####################################################### //
  static final GamePlatform nes = GamePlatform.nintendo(
    assetPath: "nes.png",
    name: "Nintendo Entertainment System",
    abbreviation: "NES",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform snes = GamePlatform.nintendo(
    assetPath: "super_nes.png",
    name: "Super Nintendo Entertainment System",
    abbreviation: "SNES",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform nintendo64 = GamePlatform.nintendo(
    assetPath: "nintendo_64.png",
    name: "Nintendo 64",
    abbreviation: "N64",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform gameCube = GamePlatform.nintendo(
    assetPath: "game_cube.png",
    name: "Nintendo GameCube",
    abbreviation: "GCN",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform wii = GamePlatform.nintendo(
    assetPath: "wii.png",
    name: "Nintendo Wii",
    abbreviation: "Wii",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform wiiU = GamePlatform.nintendo(
    assetPath: "wii_u.png",
    name: "Nintendo Wii U",
    abbreviation: "Wii U",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform nintendoSwitch = GamePlatform.nintendo(
    assetPath: "nintendo_switch.png",
    name: "Nintendo Switch",
    abbreviation: "Switch",
    type: GamePlatformType.stationary,
  );
  // #### Sony ############################################################## //
  // ### Handhelds ########################################################## //
  static final GamePlatform playStationPortable = GamePlatform.sony(
    assetPath: "psp.png",
    name: "PlayStation Portable",
    abbreviation: "PSP",
    type: GamePlatformType.handheld,
  );
  static final GamePlatform playStationVita = GamePlatform.sony(
    assetPath: "ps_vita.png",
    name: "PlayStation Vita",
    abbreviation: "PS Vita",
    type: GamePlatformType.handheld,
  );
  // ### Stationaries ####################################################### //
  static final GamePlatform playStation1 = GamePlatform.sony(
    assetPath: "ps1.png",
    name: "PlayStation",
    abbreviation: "PSX",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform playStation2 = GamePlatform.sony(
    assetPath: "ps2.png",
    name: "PlayStation 2",
    abbreviation: "PS2",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform playStation3 = GamePlatform.sony(
    assetPath: "ps3.png",
    name: "PlayStation 3",
    abbreviation: "PS3",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform playStation4 = GamePlatform.sony(
    assetPath: "ps4.png",
    name: "PlayStation 4",
    abbreviation: "PS4",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform playStation5 = GamePlatform.sony(
    assetPath: "ps5.png",
    name: "PlayStation 5",
    abbreviation: "PS5",
    type: GamePlatformType.stationary,
  );
  // #### Microsoft ######################################################### //
  // ### Stationaries ####################################################### //
  static final GamePlatform xbox = GamePlatform.microsoft(
    assetPath: "xbox.png",
    name: "XBox",
    abbreviation: "XBox",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform xbox360 = GamePlatform.microsoft(
    assetPath: "xbox_360.png",
    name: "XBox 360",
    abbreviation: "XBox 360",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform xboxOne = GamePlatform.microsoft(
    assetPath: "xbox_one.png",
    name: "XBox One",
    abbreviation: "XBone",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform xboxSeries = GamePlatform.microsoft(
    assetPath: "xbox_series.png",
    name: "XBox Series",
    abbreviation: "XBox Series",
    type: GamePlatformType.stationary,
  );
  // #### PC ################################################################ //
  // ### Stationaries ####################################################### //
  static final GamePlatform pcMisc = GamePlatform.pc(
    assetPath: "pc.png",
    name: "PC",
    abbreviation: "PC",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform gog = GamePlatform.pc(
    assetPath: "gog.png",
    name: "Gog",
    abbreviation: "Gog",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform origin = GamePlatform.pc(
    assetPath: "origin.png",
    name: "Origin",
    abbreviation: "EA",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform steam = GamePlatform.pc(
    assetPath: "steam.png",
    name: "Steam",
    abbreviation: "Steam",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform ubisoftConnect = GamePlatform.pc(
    assetPath: "ubisoft_connect.png",
    name: "Ubisoft Connect",
    abbreviation: "Ubi",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform epicGames = GamePlatform.pc(
    assetPath: "epic_games.png",
    name: "Epic",
    abbreviation: "Epic",
    type: GamePlatformType.stationary,
  );
  static final GamePlatform twitch = GamePlatform.pc(
    assetPath: "twitch.png",
    name: "Twitch",
    abbreviation: "Twitch",
    type: GamePlatformType.stationary,
  );

  static final List<GamePlatform> values = [
    gameAndWatch,
    gameBoy,
    gameBoyColor,
    nintendoDS,
    nintendoDSi,
    nintendo3DS,
    newNintendo3DS,
    nes,
    snes,
    nintendo64,
    gameCube,
    wii,
    wiiU,
    nintendoSwitch,
    playStationPortable,
    playStationVita,
    playStation1,
    playStation2,
    playStation3,
    playStation4,
    playStation5,
    xbox,
    xbox360,
    xboxOne,
    xboxSeries,
    pcMisc,
    gog,
    origin,
    steam,
    ubisoftConnect,
    epicGames,
    twitch,
  ];
}
