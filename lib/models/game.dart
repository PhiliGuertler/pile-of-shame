import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

import 'age_restriction.dart';

part 'game.g.dart';
part 'game.freezed.dart';

@freezed
class DLC with _$DLC {
  const DLC._();

  const factory DLC({
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    @Default(0.0) double price,
    DateTime? releaseDate,
  }) = _DLC;

  factory DLC.fromJson(Map<String, dynamic> json) => _$DLCFromJson(json);
}

@freezed
class Game with _$Game {
  const Game._();

  const factory Game({
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required double price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<DLC> dlcs,
    DateTime? releaseDate,
    String? coverArt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// accumulates the price of the base game and all of its dlcs
  double fullPrice() {
    double result = price;
    for (final dlc in dlcs) {
      result += dlc.price;
    }
    return result;
  }
}
