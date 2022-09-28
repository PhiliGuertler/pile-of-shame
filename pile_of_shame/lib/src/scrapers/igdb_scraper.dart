import 'package:flutter/foundation.dart';
import 'package:pile_of_shame/src/models/game.dart';
import 'package:pile_of_shame/src/network/igdb/igdb_api.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';

class IGDBScraper {
  Future<List<IGDBGame>> scrapeGameInfos(Game game) async {
    final api = IGDBApi();
    final gameResults = await api.getGameByNameAndPlatform(game.title, null);

    if (gameResults.isEmpty) {
      debugPrint("No matches found during scraping");
    }

    return gameResults;
  }

  Future<Game> scrapeAndUpdateGame(Game game) async {
    List<IGDBGame> games = await scrapeGameInfos(game);
    debugPrint(games.toString());
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
      // Set scraped-flag
      modifiedGame.wasScraped = true;
      // Done, return the game
      return modifiedGame;
    } else {
      throw Exception("Keine Informationen zu ${game.title} gefunden.");
    }
  }
}
