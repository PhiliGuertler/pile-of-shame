const String _iconBasePath = "assets/platforms/icons";
const String _textLogoBasePath = "assets/platforms/text_logos";

enum GamePlatforms {
  // Sony
  ps1(
    "sony/ps1.png",
    name: "PlayStation",
    abbreviation: "PSX",
  ),
  ps2(
    "sony/ps2.png",
    name: "PlayStation 2",
    abbreviation: "PS2",
  ),
  ps3(
    "sony/ps3.png",
    name: "PlayStation 3",
    abbreviation: "PS3",
  ),
  ps4(
    "sony/ps4.png",
    name: "PlayStation 4",
    abbreviation: "PS4",
  ),
  ps5(
    "sony/ps5.png",
    name: "PlayStation 5",
    abbreviation: "PS5",
  ),
  psp(
    "sony/psp.png",
    name: "PlayStation Portable",
    abbreviation: "PSP",
  ),
  psVita(
    "sony/ps_vita.png",
    name: "PlayStation Vita",
    abbreviation: "PS Vita",
  ),
  // Microsoft
  xbox(
    "microsoft/xbox.png",
    name: "XBox",
    abbreviation: "XBox",
  ),
  xbox360(
    "microsoft/xbox_360.png",
    name: "XBox 360",
    abbreviation: "XBox 360",
  ),
  xboxOne(
    "microsoft/xbox_one.png",
    name: "XBox One",
    abbreviation: "XBone",
  ),
  xboxSeries(
    "microsoft/xbox_series.png",
    name: "XBox Series",
    abbreviation: "XBox Series",
  ),
  // Nintendo
  gameAndWatch(
    "nintendo/game_and_watch.png",
    name: "Game & Watch",
    abbreviation: "Game & Watch",
  ),
  gameBoy(
    "nintendo/game_boy.png",
    name: "GameBoy",
    abbreviation: "GB",
  ),
  gameBoyColor(
    "nintendo/game_boy_color.png",
    name: "GameBoy Color",
    abbreviation: "GBC",
  ),
  nintendoDS(
    "nintendo/nintendo_ds.png",
    name: "Nintendo DS",
    abbreviation: "NDS",
  ),
  nintendoDSi(
    "nintendo/nintendo_dsi.png",
    name: "Nintendo DSi",
    abbreviation: "DSi",
  ),
  nintendo3DS(
    "nintendo/nintendo_3ds.png",
    name: "Nintendo 3DS",
    abbreviation: "3DS",
  ),
  newNintendo3DS(
    "nintendo/new_nintendo_3ds.png",
    name: "new Nintendo 3DS",
    abbreviation: "new 3DS",
  ),
  nes(
    "nintendo/nes.png",
    name: "Nintendo Entertainment System",
    abbreviation: "NES",
  ),
  snes(
    "nintendo/super_nes.png",
    name: "Super Nintendo Entertainment System",
    abbreviation: "SNES",
  ),
  nintendo64(
    "nintendo/nintendo_64.png",
    name: "Nintendo 64",
    abbreviation: "N64",
  ),
  gameCube(
    "nintendo/game_cube.png",
    name: "Nintendo Game Cube",
    abbreviation: "GCN",
  ),
  wii(
    "nintendo/wii.png",
    name: "Nintendo Wii",
    abbreviation: "Wii",
  ),
  wiiU(
    "nintendo/wii_u.png",
    name: "Nintendo Wii U",
    abbreviation: "Wii U",
  ),
  nintendoSwitch(
    "nintendo/nintendo_switch.png",
    name: "Nintendo Switch",
    abbreviation: "Switch",
  ),
  // PC
  pc(
    "pc/pc.png",
    name: "PC",
    abbreviation: "PC",
  ),
  gog(
    "pc/gog.png",
    name: "Gog",
    abbreviation: "Gog",
  ),
  origin(
    "pc/origin.png",
    name: "Origin",
    abbreviation: "Origin",
  ),
  steam(
    "pc/steam.png",
    name: "Steam",
    abbreviation: "Steam",
  ),
  ubisoftConnect(
    "pc/ubisoft_connect.png",
    name: "Ubisoft Connect",
    abbreviation: "Ubi",
  ),
  ;

  String get iconPath => "$_iconBasePath/$_filePath";
  String get textLogoPath => "$_textLogoBasePath/$_filePath";

  final String _filePath;
  final String abbreviation;
  final String name;

  const GamePlatforms(
    this._filePath, {
    required this.abbreviation,
    required this.name,
  });
}
