import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class DLC with _$DLC {
  const factory DLC({
    required String id,
    required String name,
    required PlayStatus status,
    required DateTime lastModified,
    required DateTime createdAt,
    @Default(0.0) double price,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(false) bool wasGifted,
  }) = _DLC;
  const DLC._();

  factory DLC.fromJson(Map<String, dynamic> json) => _$DLCFromJson(json);
}

@freezed
class Game with _$Game {
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
    @Default(false) bool wasGifted,
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
}

// TODO: Refactor this class by renaming it, as it no longer only contains a list of games but also hardware!
@freezed
class GamesList with _$GamesList {
  const factory GamesList({
    required List<Game> games,
    @Default(VideoGameHardwareMap(hardwareByPlatform: {}))
    VideoGameHardwareMap hardware,
  }) = _GamesList;
  const GamesList._();

  factory GamesList.fromJson(Map<String, dynamic> json) =>
      _$GamesListFromJson(json);

  // ######################################################################## //
  // ### Games ############################################################## //

  /// Updates a game by overwriting it.
  /// If no game with the given id exists, an Exception is thrown.
  GamesList updateGame(String id, Game update) {
    final gameIndex = games.indexWhere((element) => element.id == id);
    assert(gameIndex != -1, "No Game with id '$id' found");

    final List<Game> updatedGames = List.from(games);

    updatedGames[gameIndex] = update;
    return copyWith(games: updatedGames);
  }

  /// Removes a game from the list by its id
  /// If no game with the same id exists, an Exception is thrown.
  GamesList removeGame(String id) {
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
  GamesList addGame(Game game) {
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
  GamesList updateGamesByLastModified(GamesList gamesList) {
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
  GamesList addMissingGames(GamesList gamesList) {
    GamesList updatedGames = this;

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
  GamesList addHardware(VideoGameHardware hardware, GamePlatform platform) {
    assert(
      (this.hardware.hardwareByPlatform[platform] ?? [])
          .every((element) => element.id != hardware.id),
      "Hardware with id '${hardware.id}' already exists for platform '${platform.abbreviation}'. Did you mean to update existing hardware?",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(this.hardware.hardwareByPlatform);
    if (update.containsKey(platform)) {
      update[platform]!.add(hardware);
    } else {
      update[platform] = [hardware];
    }

    return copyWith(hardware: VideoGameHardwareMap(hardwareByPlatform: update));
  }

  /// Updates existing hardware
  /// Throws an exception if no hardware with the same id already exists
  GamesList updateHardware(VideoGameHardware hardware, GamePlatform platform) {
    assert(
      (this.hardware.hardwareByPlatform[platform] ?? [])
          .any((h) => h.id == hardware.id),
      "Hardware with id '${hardware.id}' does not exist for platform '${platform.abbreviation}'. Did you mean to add new hardware?",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(this.hardware.hardwareByPlatform);
    final List<VideoGameHardware> updatedList = update[platform]!;
    final updateIndex = updatedList.indexWhere(
      (element) => element.id == hardware.id,
    );

    updatedList[updateIndex] = hardware;
    update[platform] = updatedList;

    return copyWith(hardware: VideoGameHardwareMap(hardwareByPlatform: update));
  }

  /// Removes existing hardware
  /// Throws an exception if no hardware with the same id already exists
  GamesList removeHardware(String id, GamePlatform platform) {
    assert(
      (hardware.hardwareByPlatform[platform] ?? []).any((h) => h.id == id),
      "Hardware with id '$id' does not exist for platform '${platform.abbreviation}'",
    );

    final Map<GamePlatform, List<VideoGameHardware>> update =
        Map.from(hardware.hardwareByPlatform);
    final List<VideoGameHardware> updatedList = update[platform]!;
    updatedList.removeWhere(
      (element) => element.id == id,
    );

    update[platform] = updatedList;

    return copyWith(hardware: VideoGameHardwareMap(hardwareByPlatform: update));
  }

  // TODO: Add functions like above for games that only update if the incoming hardware is newer, etc.
}
