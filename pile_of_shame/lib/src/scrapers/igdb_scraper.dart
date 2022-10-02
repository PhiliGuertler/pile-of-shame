import 'package:flutter/foundation.dart';
import 'package:pile_of_shame/src/models/game.dart';
import 'package:pile_of_shame/src/network/igdb/igdb_api.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';

import '../persistance/storage.dart';

class IGDBScraper {
  Stream<int> scrapeGameList(List<Game> games,
      {bool skipIfAlreadyScraped = true, int parallelRequests = 1}) async* {
    await Future.delayed(const Duration(milliseconds: 50));
    yield 0;
    for (int i = 0; i < games.length; i = i + parallelRequests) {
      yield i;
      List<Future<Game>> requestResponses = [];
      for (int k = 0; k < parallelRequests; ++k) {
        requestResponses.add(
          scrapeAndUpdateGame(games[i],
                  skipIfAlreadyScraped: skipIfAlreadyScraped)
              .then(
            (value) async {
              await Storage().addOrUpdateGame(value);
              return value;
            },
          ),
        );
      }
      await Future.wait(requestResponses);
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
    final gameResults = await api.getGameByExactName(game.title);
    if (gameResults.isEmpty) {
      debugPrint("No matches found during scraping");
    }

    return gameResults;
  }

  Future<Game> scrapeAndUpdateGame(Game game,
      {bool skipIfAlreadyScraped = true}) async {
    List<IGDBGame> games =
        await scrapeGameInfos(game, skipIfAlreadyScraped: skipIfAlreadyScraped);
    // TODO: prompt the user to select one of the game results, if there are more than one.
    if (games.isNotEmpty) {
      IGDBGame scrapingResult = games.first;
      Game modifiedGame = Game.from(game);
      const String coverSize = "cover_big";
      const String backgroundSize = "screenshot_big";

      // Set cover-image
      if (scrapingResult.cover != null) {
        modifiedGame.coverImage =
            "https://images.igdb.com/igdb/image/upload/t_$coverSize/${scrapingResult.cover!.imageId}.jpg";
      }
      // Set background-image
      if (scrapingResult.screenshots != null &&
          scrapingResult.screenshots!.isNotEmpty) {
        modifiedGame.backgroundImage =
            "https://images.igdb.com/igdb/image/upload/t_$backgroundSize/${scrapingResult.screenshots!.first.imageId}.jpg";
      }
      // Set release-date
      if (scrapingResult.firstReleaseDate != null) {
        modifiedGame.releaseDate = scrapingResult.firstReleaseDate;
      }
      // Set external-Game-id
      modifiedGame.externalGameId = scrapingResult.id;
      // Done, return the game
      return modifiedGame;
    }
    return game;
  }
}
