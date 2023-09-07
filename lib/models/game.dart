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

@freezed
class GamesList with _$GamesList {
  const GamesList._();

  const factory GamesList({
    required List<Game> games,
  }) = _GamesList;

  factory GamesList.fromJson(Map<String, dynamic> json) =>
      _$GamesListFromJson(json);

  GamesList updateGame(String id, Game update) {
    final gameIndex = games.indexWhere((element) => element.id == id);
    assert(gameIndex != -1, "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);

    updatedGames[gameIndex] = update;
    return GamesList(games: updatedGames);
  }

  GamesList removeGame(String id) {
    assert(games.indexWhere((element) => element.id == id) != -1,
        "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);
    updatedGames.removeWhere((element) => element.id == id);
    return GamesList(games: updatedGames);
  }

  GamesList addGame(Game game) {
    assert(games.every((element) => element.id != game.id),
        "Game with id '${game.id}' already exists. Did you mean to update an existing Game?");

    final List<Game> updatedGames = List.from(games);
    updatedGames.add(game);
    return GamesList(games: updatedGames);
  }

  GamesList updateGames(GamesList gamesList) {
    final List<Game> updatedGames = List.from(games);

    for (int i = 0; i < updatedGames.length; ++i) {
      Game game = updatedGames[i];
      int possibleUpdateIndex =
          gamesList.games.indexWhere((update) => update.id == game.id);
      if (possibleUpdateIndex == -1) {
        continue;
      }
      Game update = gamesList.games[possibleUpdateIndex];
      if (update.lastModified.compareTo(game.lastModified) > 0) {
        updatedGames[i] = update;
      }
    }

    return GamesList(games: updatedGames);
  }

  GamesList addGames(GamesList gamesList) {
    GamesList updatedGames = this;

    for (int i = 0; i < gamesList.games.length; ++i) {
      Game possibleNewGame = gamesList.games[i];
      int index =
          games.indexWhere((element) => element.id == possibleNewGame.id);
      if (index == -1) {
        updatedGames = addGame(possibleNewGame);
      }
    }

    return updatedGames;
  }
}
