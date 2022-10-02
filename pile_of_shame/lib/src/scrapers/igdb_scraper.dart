import 'package:flutter/foundation.dart';
import 'package:pile_of_shame/src/models/game.dart';
import 'package:pile_of_shame/src/network/igdb/igdb_api.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';

import '../persistance/storage.dart';

class IGDBScraper {
  Stream<int> scrapeGameList(List<Game> games) async* {
    yield 0;
    for (int i = 0; i < games.length; ++i) {
      yield i;
      try {
        Game scrapedGame = await scrapeAndUpdateGame(games[i]);
        await Storage().addOrUpdateGame(scrapedGame);
      } catch (error) {
        // Ignore the error for now and continue with the next game
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
      // TODO: use that identifier
      // Skip that game for now
      return [];
    } else {
      final gameResults = await api.getGameByExactName(game.title);
      if (gameResults.isEmpty) {
        debugPrint("No matches found during scraping");
      }

      return gameResults;
    }
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
      const String backgroundSize = "screenshot_huge";

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
