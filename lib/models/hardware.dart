import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';

part 'hardware.freezed.dart';
part 'hardware.g.dart';

@freezed
class VideoGameHardware with _$VideoGameHardware {
  const factory VideoGameHardware({
    required String id,
    required String name,
    required GamePlatform platform,
    @Default(0.0) double price,
    required DateTime lastModified,
    required DateTime createdAt,
    String? notes,
    @Default(false) bool wasGifted,
  }) = _VideoGameHardware;

  factory VideoGameHardware.fromJson(Map<String, dynamic> json) =>
      _$VideoGameHardwareFromJson(json);
}
