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

  /// Updates a game by overwriting it.
  /// If no game with the given id exists, an Exception is thrown.
  GamesList updateGame(String id, Game update) {
    final gameIndex = games.indexWhere((element) => element.id == id);
    assert(gameIndex != -1, "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);

    updatedGames[gameIndex] = update;
    return GamesList(games: updatedGames);
  }

  /// Removes a game from the list by its id
  /// If no game with the same id exists, an Exception is thrown.
  GamesList removeGame(String id) {
    assert(games.indexWhere((element) => element.id == id) != -1,
        "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);
    updatedGames.removeWhere((element) => element.id == id);
    return GamesList(games: updatedGames);
  }

  /// Adds a game to the list
  /// If a game with the same id already exists, an Exception is thrown.
  GamesList addGame(Game game) {
    assert(games.every((element) => element.id != game.id),
        "Game with id '${game.id}' already exists. Did you mean to update an existing Game?");

    final List<Game> updatedGames = List.from(games);
    updatedGames.add(game);
    return GamesList(games: updatedGames);
  }

  /// Updates games that are marked as more recent by their lastModified member.
  /// Games with the same id but with the same lastModified or more recent will not be altered.
  /// If no game matches the id of an input game it won't be added, instead nothing happens.
  GamesList updateGamesByLastModified(GamesList gamesList) {
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

  /// Adds missing games to the list.
  /// A game is considered missing if there is no game with the same id yet.
  GamesList addMissingGames(GamesList gamesList) {
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
