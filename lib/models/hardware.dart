import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

part 'hardware.freezed.dart';
part 'hardware.g.dart';

@freezed
class VideoGameConsole with _$VideoGameConsole {
  const factory VideoGameConsole({
    required String id,
    required String name,
    @Default(0.0) double price,
    required DateTime lastModified,
    required DateTime createdAt,
  }) = _VideoGameConsole;

  factory VideoGameConsole.fromJson(Map<String, dynamic> json) =>
      _$VideoGameConsoleFromJson(json);
}

@freezed
class VideoGameController with _$VideoGameController {
  const factory VideoGameController({
    required String id,
    required String name,
    @Default(0.0) double price,
    required DateTime lastModified,
    required DateTime createdAt,
  }) = _VideoGameController;

  factory VideoGameController.fromJson(Map<String, dynamic> json) =>
      _$VideoGameControllerFromJson(json);
}

@freezed
class VideoGameMiscHardware with _$VideoGameMiscHardware {
  const factory VideoGameMiscHardware({
    required String id,
    required String name,
    @Default(0.0) double price,
    required DateTime lastModified,
    required DateTime createdAt,
  }) = _VideoGameMiscHardware;

  factory VideoGameMiscHardware.fromJson(Map<String, dynamic> json) =>
      _$VideoGameMiscHardwareFromJson(json);
}

@freezed
class VideoGameHardware with _$VideoGameHardware {
  const factory VideoGameHardware({
    @Default([]) List<VideoGameConsole> consoles,
    @Default([]) List<VideoGameController> controllers,
    @Default([]) List<VideoGameMiscHardware> misc,
  }) = _VideoGameHardware;

  factory VideoGameHardware.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwareFromJson(json);
}

@freezed
class VideoGameHardwareMap with _$VideoGameHardwareMap {
  const factory VideoGameHardwareMap({
    required Map<GamePlatform, VideoGameHardware> hardwareByPlatform,
  }) = _VideoGameHardwareMap;

  factory VideoGameHardwareMap.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwareMapFromJson(json);
}
