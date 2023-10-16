import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';

part 'database.freezed.dart';
part 'database.g.dart';

@freezed
class Database with _$Database {
  const factory Database({
    required List<Game> games,
    required Map<GamePlatform, List<VideoGameHardware>> hardware,
  }) = _Database;
  const Database._();

  factory Database.fromJson(Map<String, dynamic> json) =>
      _$DatabaseFromJson(json);

  // ######################################################################## //
  // ### Games ############################################################## //

  /// Updates a game by overwriting it.
  /// If no game with the given id exists, an Exception is thrown.
  Database updateGame(String id, Game update) {
    final gameIndex = games.indexWhere((element) => element.id == id);
    assert(gameIndex != -1, "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);

    updatedGames[gameIndex] = update;
    return copyWith(games: updatedGames);
  }

  /// Removes a game from the list by its id
  /// If no game with the same id exists, an Exception is thrown.
  Database removeGame(String id) {
    assert(
      games.indexWhere((element) => element.id == id) != -1,
      "No Game with id '$id' found",
    );

    final List<Game> updatedGames = List.from(games);
    updatedGames.removeWhere((element) => element.id == id);
    return copyWith(games: updatedGames);
  }

  /// Adds a game to the list
  /// If a game with the same id already exists, an Exception is thrown.
  Database addGame(Game game) {
    assert(
      games.every((element) => element.id != game.id),
      "Game with id '${game.id}' already exists. Did you mean to update an existing Game?",
    );

    final List<Game> updatedGames = List.from(games);
    updatedGames.add(game);
    return copyWith(games: updatedGames);
  }

  /// Updates games that are marked as more recent by their lastModified member.
  /// Games with the same id but with the same lastModified or more recent will not be altered.
  /// If no game matches the id of an input game it won't be added, instead nothing happens.
  Database updateGamesByLastModified(Database gamesList) {
    final List<Game> updatedGames = List.from(games);

    for (int i = 0; i < updatedGames.length; ++i) {
      final Game game = updatedGames[i];
      final int possibleUpdateIndex =
          gamesList.games.indexWhere((update) => update.id == game.id);
      if (possibleUpdateIndex == -1) {
        continue;
      }
      final Game update = gamesList.games[possibleUpdateIndex];
      if (update.lastModified.compareTo(game.lastModified) > 0) {
        updatedGames[i] = update;
      }
    }

    return copyWith(games: updatedGames);
  }

  /// Adds missing games to the list.
  /// A game is considered missing if there is no game with the same id yet.
  Database addMissingGames(Database gamesList) {
    Database updatedGames = this;

    for (int i = 0; i < gamesList.games.length; ++i) {
      final Game possibleNewGame = gamesList.games[i];
      final int index =
          games.indexWhere((element) => element.id == possibleNewGame.id);
      if (index == -1) {
        updatedGames = addGame(possibleNewGame);
      }
    }

    return updatedGames;
  }

  // ######################################################################## //
  // ### Hardware ########################################################### //

  /// Adds hardware to the list
  /// Throws an exception if hardware with the same id already exists
  Database addHardware(VideoGameHardware hardware, GamePlatform platform) {
    assert(
      (this.hardware[platform] ?? [])
          .every((element) => element.id != hardware.id),
      "Hardware with id '${hardware.id}' already exists for platform '${platform.abbreviation}'. Did you mean to update existing hardware?",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(this.hardware);
    if (update.containsKey(platform)) {
      update[platform]!.add(hardware);
    } else {
      update[platform] = [hardware];
    }

    return copyWith(hardware: update);
  }

  /// Updates existing hardware
  /// Throws an exception if no hardware with the same id already exists
  Database updateHardware(VideoGameHardware hardware, GamePlatform platform) {
    assert(
      (this.hardware[platform] ?? []).any((h) => h.id == hardware.id),
      "Hardware with id '${hardware.id}' does not exist for platform '${platform.abbreviation}'. Did you mean to add new hardware?",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(this.hardware);
    final List<VideoGameHardware> updatedList = update[platform]!;
    final updateIndex = updatedList.indexWhere(
      (element) => element.id == hardware.id,
    );

    updatedList[updateIndex] = hardware;
    update[platform] = updatedList;

    return copyWith(hardware: update);
  }

  /// Removes existing hardware
  /// Throws an exception if no hardware with the same id already exists
  Database removeHardware(String id, GamePlatform platform) {
    assert(
      (hardware[platform] ?? []).any((h) => h.id == id),
      "Hardware with id '$id' does not exist for platform '${platform.abbreviation}'",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(hardware);
    final List<VideoGameHardware> updatedList = update[platform]!;
    updatedList.removeWhere(
      (element) => element.id == id,
    );

    update[platform] = updatedList;

    return copyWith(hardware: update);
  }

  // TODO: Add functions like above for games that only update if the incoming hardware is newer, etc.
}
