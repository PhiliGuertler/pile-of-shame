import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/models/price_variant.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class DLC with _$DLC {
  const factory DLC({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    @Default(0.0) double price,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(PriceVariant.bought) PriceVariant priceVariant,
  }) = _DLC;
  const DLC._();

  factory DLC.fromJson(Map<String, dynamic> json) => _$DLCFromJson(json);
}

@freezed
abstract class Game with _$Game {
  const factory Game({
    required String id,
    required String name,
    required GamePlatform platform,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    required double price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<DLC> dlcs,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(PriceVariant.bought) PriceVariant priceVariant,
  }) = _Game;
  const Game._();

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// accumulates the price of the base game and all of its dlcs
  double fullPrice() {
    double result = price;
    for (final dlc in dlcs) {
      result += dlc.price;
    }
    return result;
  }

  double fullPriceNonWishlist() {
    double result = price;
    for (final dlc in dlcs) {
      if (dlc.status != PlayStatus.onWishList) {
        result += dlc.price;
      }
    }
    return result;
  }
}
