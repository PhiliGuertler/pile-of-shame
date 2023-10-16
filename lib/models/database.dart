import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/hardware.dart';

part 'database.freezed.dart';
part 'database.g.dart';

@freezed
class Database with _$Database {
  const factory Database({
    required List<Game> games,
    required List<VideoGameHardware> hardware,
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

  // ######################################################################## //
  // ### Hardware ########################################################### //

  /// Adds hardware to the list
  /// Throws an exception if hardware with the same id already exists
  Database addHardware(VideoGameHardware hardware) {
    assert(
      this.hardware.every((element) => element.id != hardware.id),
      "Hardware with id '${hardware.id}' already exists. Did you mean to update existing hardware?",
    );

    final List<VideoGameHardware> update = List.from(this.hardware);
    update.add(hardware);

    return copyWith(hardware: update);
  }

  /// Updates existing hardware
  /// Throws an exception if no hardware with the same id already exists
  Database updateHardware(VideoGameHardware hardware) {
    assert(
      this.hardware.any((h) => h.id == hardware.id),
      "Hardware with id '${hardware.id}' does not exist. Did you mean to add new hardware?",
    );

    final List<VideoGameHardware> update = List.from(this.hardware);
    final updateIndex = update.indexWhere(
      (element) => element.id == hardware.id,
    );

    update[updateIndex] = hardware;

    return copyWith(hardware: update);
  }

  /// Removes existing hardware
  /// Throws an exception if no hardware with the same id already exists
  Database removeHardware(String id) {
    assert(
      hardware.any((h) => h.id == id),
      "Hardware with id '$id' does not exist",
    );

    final List<VideoGameHardware> update = List.from(hardware);
    update.removeWhere(
      (element) => element.id == id,
    );

    return copyWith(hardware: update);
  }

  // ######################################################################## //
  // ### Update Database #################################################### //

  /// Updates games that are marked as more recent by their lastModified member.
  /// Games with the same id but with the same lastModified or more recent will not be altered.
  /// If no game matches the id of an input game it won't be added, instead nothing happens.
  Database updateDatabaseByLastModified(Database database) {
    final List<Game> updatedGames = List.from(games);
    final List<VideoGameHardware> updatedHardware = List.from(hardware);

    // update games
    for (int i = 0; i < updatedGames.length; ++i) {
      final Game game = updatedGames[i];
      final int possibleUpdateIndex =
          database.games.indexWhere((update) => update.id == game.id);
      if (possibleUpdateIndex == -1) continue;
      final Game update = database.games[possibleUpdateIndex];
      if (update.lastModified.compareTo(game.lastModified) > 0) {
        updatedGames[i] = update;
      }
    }

    // update hardware
    for (int i = 0; i < updatedHardware.length; ++i) {
      final VideoGameHardware hardware = updatedHardware[i];

      final int possibleUpdateIndex =
          database.hardware.indexWhere((element) => element.id == hardware.id);
      if (possibleUpdateIndex == -1) continue;
      final VideoGameHardware update = database.hardware[possibleUpdateIndex];
      if (update.lastModified.compareTo(hardware.lastModified) > 0) {
        updatedHardware[i] = update;
      }
    }

    return copyWith(games: updatedGames, hardware: updatedHardware);
  }

  /// Adds missing games to the list.
  /// A game is considered missing if there is no game with the same id yet.
  Database addMissingDatabaseEntries(Database database) {
    Database updatedDatabase = this;

    // update games
    for (int i = 0; i < database.games.length; ++i) {
      final Game possibleNewGame = database.games[i];
      final int index =
          games.indexWhere((element) => element.id == possibleNewGame.id);
      if (index == -1) {
        updatedDatabase = updatedDatabase.addGame(possibleNewGame);
      }
    }

    // update hardware
    for (int i = 0; i < database.hardware.length; ++i) {
      final VideoGameHardware possibleNewHardware = database.hardware[i];
      final int index = hardware
          .indexWhere((element) => element.id == possibleNewHardware.id);
      if (index == -1) {
        updatedDatabase = updatedDatabase.addHardware(possibleNewHardware);
      }
    }

    return updatedDatabase;
  }
}
