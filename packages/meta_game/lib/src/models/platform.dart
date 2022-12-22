import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum Platform {
  // ######################################################################## //
  // ### PC/VR Platforms #################################################### //
  pcDefault(0, 'PC', 'PC', Color.fromRGBO(38, 50, 56, 1)),
  pcSteam(1, 'PC: Steam', 'Steam', Color.fromRGBO(38, 50, 56, 1)),
  pcGog(2, 'PC: Gog', 'Gog', Color.fromRGBO(38, 50, 56, 1)),
  pcUPlay(3, 'PC: U-Play', 'U-Play', Color.fromRGBO(38, 50, 56, 1)),
  pcEpic(4, 'PC: Epic', 'Epic', Color.fromRGBO(38, 50, 56, 1)),
  pcTwitch(5, 'PC: Twitch', 'Twitch', Color.fromRGBO(38, 50, 56, 1)),
  pcOrigin(6, 'PC: Origin', 'Origin', Color.fromRGBO(38, 50, 56, 1)),
  pcXBox(7, 'PC: XBox', 'XBox (PC)', Color.fromRGBO(38, 50, 56, 1)),
  vrSteam(8, 'VR: Steam', 'SteamVR', Color.fromRGBO(38, 50, 56, 1)),
  vrOculus(9, 'VR: Oculus', 'Oculus', Color.fromRGBO(38, 50, 56, 1)),

  // ######################################################################## //
  // ### Sony Platforms ##################################################### //
  playstation1(10, 'PlayStation', 'PS1', Color.fromRGBO(224, 224, 224, 1)),
  playstation2(11, 'PlayStation 2', 'PS2', Color.fromRGBO(66, 66, 66, 1)),
  playstation3(12, 'PlayStation 3', 'PS3', Color.fromRGBO(21, 101, 192, 1)),
  playstation4(13, 'PlayStation 4', 'PS4', Color.fromRGBO(30, 136, 229, 1)),
  // playstation4Plus(
  //     14, 'PlayStation 4 (PS+)', 'PS4 (PS+)', Color.fromRGBO(30, 136, 229, 1)),
  playstation5(15, 'PlayStation 5', 'PS5', Color.fromRGBO(250, 250, 250, 1)),
  // playstation5Plus(
  //     16, 'PlayStation 5 (PS+)', 'PS5 (PS+)', Color.fromRGBO(250, 250, 250, 1)),
  playstationPortable(
      17, 'PlayStation Portable', 'PSP', Color.fromRGBO(117, 117, 117, 1)),
  playstationVita(
      18, 'PlayStation Vita', 'PS Vita', Color.fromRGBO(66, 165, 245, 1)),
  playstationVR(19, 'PlayStation VR', 'PS VR', Color.fromRGBO(30, 136, 229, 1)),
  playstationVR2(
      20, 'PlayStation VR 2', 'PS VR 2', Color.fromRGBO(250, 250, 250, 1)),

  // ######################################################################## //
  // ### Microsoft Platforms ################################################ //
  xboxOriginal(21, 'XBox', 'XBox', Color.fromRGBO(129, 199, 132, 1)),
  xbox360(22, 'XBox 360', 'XBox 360', Colors.green),
  xboxOne(23, 'XBox One', 'XBox One', Color.fromRGBO(56, 142, 60, 1)),
  xboxSeriesXS(
      24, 'XBox Series S/X', 'XBox Series', Color.fromRGBO(27, 94, 32, 1)),

  // ######################################################################## //
  // ### Nintendo Platforms ################################################# //
  nintendoNES(25, 'Nintendo Entertainment System', 'NES', Colors.grey),
  nintendoSNES(
      26, 'Super Nintendo Entertainment System', 'SNES', Colors.purple),
  nintendo64(27, 'Nintendo 64', 'N64', Color.fromRGBO(245, 127, 23, 1)),
  nintendoGameCube(
      28, 'Nintendo GameCube', 'GCN', Color.fromRGBO(74, 20, 140, 1)),
  nintendoWii(29, 'Nintendo Wii', 'Wii', Colors.white),
  // nintendoWiiVirtualConsole(30, 'Virtual Console: Wii', 'Wii:VC', Colors.white),
  nintendoWiiU(31, 'Nintendo Wii U', 'Wii U', Colors.cyan),
  nintendoSwitch(32, 'Nintendo Switch', 'Switch', Colors.red),
  // nintendoSwitchOnline(33, 'Nintendo Switch Online', 'NSO', Colors.red),
  gameBoy(34, 'GameBoy', 'GB', Colors.blueGrey),
  gameBoyColor(35, 'GameBoy Color', 'GBC', Colors.lime),
  gameBoyAdvance(36, 'GameBoy Advance', 'GBA', Color.fromRGBO(123, 31, 162, 1)),
  nintendoDS(37, 'Nintendo DS', 'NDS', Color.fromRGBO(128, 222, 234, 1)),
  // nintendoDSi(38, 'Nintendo DSi', 'DSi', Color.fromRGBO(136, 14, 79, 1)),
  nintendo3DS(39, 'Nintendo 3DS', '3DS', Color.fromRGBO(79, 195, 247, 1));
  // nintendo2DSVirtualConsole(
  //     40, 'Virtual Console: 3DS', '3DS:VC', Color.fromRGBO(79, 195, 247, 1));

  // Platform Members
  final int code;
  final String name;
  final String abbreviation;
  final Color color;
  const Platform(this.code, this.name, this.abbreviation, this.color);
}
