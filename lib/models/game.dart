import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

import 'age_restriction.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class DLC with _$DLC {
  const DLC._();

  const factory DLC({
    required String id,
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

@unfreezed
class GamesList with _$GamesList {
  const GamesList._();

  const factory GamesList({
    required final List<Game> games,
  }) = _GamesList;

  factory GamesList.fromJson(Map<String, dynamic> json) =>
      _$GamesListFromJson(json);

  void updateGame(String id, Game update) {
    final gameIndex = games.indexWhere((element) => element.id == id);
    assert(gameIndex != -1, "No Game with id '$id' found");

    games[gameIndex] = update;
  }

  void removeGame(String id) {
    games.removeWhere((element) => element.id == id);
  }

  void addGame(Game game) {
    assert(games.every((element) => element.id != game.id));
    games.add(game);
  }
}
