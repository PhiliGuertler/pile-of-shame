import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/models/game.dart';
import 'package:pile_of_shame/src/network/igdb/igdb_api.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';

import '../persistance/storage.dart';
import '../widgets/igdb_game_simple_dialog_item.dart';

class IGDBImageSizes {
  IGDBImageSizes._();

  static const String coverSmall = "cover_small";
  static const String coverBig = "cover_big";
  static const String screenshotMed = "screenshot_med";
  static const String screenshotBig = "screenshot_big";
  static const String screenshotHuge = "screenshot_huge";
  static const String logoMed = "logo_med";
  static const String thumb = "thumb";
  static const String thumbMicro = "micro";
}

class IGDBScraper {
  static String generateIGDBImageUrl(String imageName, String igdbImageSize) {
    return "https://images.igdb.com/igdb/image/upload/t_$igdbImageSize/$imageName.jpg";
  }

  Stream<int> scrapeGameList(List<Game> games,
      {bool skipIfAlreadyScraped = true}) async* {
    await Future.delayed(const Duration(milliseconds: 50));
    yield 0;
    for (int i = 0; i < games.length; i++) {
      yield i;
      try {
        Game? game = await scrapeAndUpdateGame(games[i],
            skipIfAlreadyScraped: skipIfAlreadyScraped);
        if (game != null) {
          await Storage().addOrUpdateGame(game);
        }
      } catch (error) {
        debugPrint(error.toString());
      }
    }
    yield games.length;
  }

  Future<List<IGDBGame>> scrapeGameInfos(Game game,
      {bool skipIfAlreadyScraped = true}) async {
    final api = IGDBApi();
    if (game.externalGameId != null && skipIfAlreadyScraped) {
      // this game has an external identifier set, which means it has already been scraped before.
      final gameResults = await api.getGameById(game.externalGameId!);
      if (gameResults.isEmpty) {
        debugPrint(
            "No matches found during scraping with id ${game.externalGameId}");
      } else {
        return gameResults;
      }
    }
    List<IGDBGame> gameResults = await api.getGameByExactName(game.title);
    if (gameResults.isEmpty ||
        gameResults.length > 1 ||
        (gameResults.first.name != null &&
            (gameResults.first.name!.toLowerCase() !=
                game.title.toLowerCase()))) {
      debugPrint(
          "No exact matches found during scraping. Trying to search for it");
      gameResults.addAll(await api.getGameBySearchName(game.title));
    }

    return gameResults;
  }

  Future<Game> _updateGameFromIGDBGame(Game game, IGDBGame igdbGame) async {
    Game modifiedGame = Game.from(game);

    // Set cover-image
    if (igdbGame.cover != null) {
      modifiedGame.coverImage = IGDBScraper.generateIGDBImageUrl(
        igdbGame.cover!.imageId,
        IGDBImageSizes.coverBig,
      );
    }
    // Set background-image
    if (igdbGame.screenshots != null && igdbGame.screenshots!.isNotEmpty) {
      modifiedGame.backgroundImage = IGDBScraper.generateIGDBImageUrl(
        igdbGame.screenshots!.first.imageId,
        IGDBImageSizes.screenshotBig,
      );
    }
    // Set online rating
    if (igdbGame.rating != null) {
      modifiedGame.onlineScore = igdbGame.rating!.toInt();
    }
    // Set release-date
    if (igdbGame.firstReleaseDate != null) {
      modifiedGame.releaseDate = igdbGame.firstReleaseDate;
    }
    // Set external-Game-id
    modifiedGame.externalGameId = igdbGame.id;
    // Done, return the game
    await Storage().addOrUpdateGame(modifiedGame);

    return modifiedGame;
  }

  Future<Game?> scrapeAndUpdateGame(Game game,
      {BuildContext? context,
      void Function(Game)? onGameSelected,
      bool skipIfAlreadyScraped = true}) async {
    List<IGDBGame> games =
        await scrapeGameInfos(game, skipIfAlreadyScraped: skipIfAlreadyScraped);
    if (games.length > 1 && context != null) {
      // Prompt the user to select one of the game results, if there are more than one.
      return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Treffer wählen"),
            children: games.map(
              (igdbGame) {
                return IGDBGameSimpleDialogItem(
                  igdbGame: igdbGame,
                  onPressed: () async {
                    Game updated =
                        await _updateGameFromIGDBGame(game, igdbGame);
                    if (onGameSelected != null) {
                      onGameSelected(updated);
                    }
                  },
                );
              },
            ).toList(),
          );
        },
      );
    }
    if (games.isNotEmpty) {
      return await _updateGameFromIGDBGame(game, games.first);
    }
    // return the unmodified game as no match was found
    return game;
  }
}
