import 'package:flutter/foundation.dart';
import 'package:pile_of_shame/src/models/game.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/network/igdb/igdb_api.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_platform.dart';

class IGDBScraper {
  Future<Map<GamePlatform, IGDBPlatform>> mapIGDBPlatforms() async {
    final api = IGDBApi();
    final igdbPlatforms = await api.getPlatforms();

    Map<GamePlatform, IGDBPlatform> map = Map();
    GamePlatforms.toList().forEach((platform) {
      // find the platform in igdb-platforms
      final matches = igdbPlatforms.where((igdbPlatform) {
        return platform.name.toLowerCase() == igdbPlatform.name.toLowerCase() ||
            platform.abbreviation.toLowerCase() ==
                igdbPlatform.abbreviation?.toLowerCase();
      });

      if (matches.length == 1) {
        map[platform] = matches.first;
      } else {
        debugPrint(platform.name);
      }
    });

    return map;
  }

  Future<List<IGDBGame>> scrapeGameInfos(Game game) async {
    final api = IGDBApi();
    // fetch all platforms of IGDB first and link them to the platforms of the application
    // final platforms = await mapIGDBPlatforms();

    // TODO: everything above should be performed upon initialization
    // Fetch game data from igdb
    // final gameResults = await api.getGameByNameAndPlatform(
    //     game.title, platforms[game.platforms.first]?.id);
    final gameResults = await api.getGameByNameAndPlatform(game.title, null);

    if (gameResults.isEmpty) {
      debugPrint("No matches found during scraping");
    }

    return gameResults;
  }
}
