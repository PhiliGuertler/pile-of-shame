import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/models/game_platform.dart';
import 'package:pile_of_shame/src/network/rawg/rawg_api.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/age_restrictions.dart';
import '../models/game.dart';
import 'edit_game_details.dart';

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class GameDetails extends StatefulWidget {
  const GameDetails({super.key, required this.game});

  final Game game;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  late Future<Game> mostRecentGame;

  Future<Game> scrapeGameData(String gameTitle, GamePlatform platform) async {
    Iterable<RawgGame> scrapedGames =
        await RawgApi().searchGameByNameAndPlatform(gameTitle, platform);
    // For now, just assume the first result is the match we want
    final RawgGame scrapy = scrapedGames.first;
    final Game scrapedGame = Game.from(widget.game);
    scrapedGame.backgroundImage =
        scrapedGame.backgroundImage ?? scrapy.backgroundImage;
    scrapedGame.releaseDate = scrapedGame.releaseDate ??
        (scrapy.released != null ? DateTime.parse(scrapy.released!) : null);
    scrapedGame.metacriticScore =
        scrapedGame.metacriticScore ?? scrapy.metacriticScore;
    scrapedGame.rawgGameId = scrapedGame.rawgGameId ?? scrapy.id;
    scrapedGame.wasScraped = true;

    await Storage().addOrUpdateGame(scrapedGame);

    if (!mounted) return scrapedGame;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('[Scraping] Zusätliche Informationen zu $gameTitle geladen.'),
      ),
    );

    return scrapedGame;
  }

  @override
  void initState() {
    super.initState();
    debugPrint(widget.game.toJson().toString());
    if (!widget.game.wasScraped) {
      // find the platforms for the currently selected game
      final platforms = GamePlatforms.toList()
          .where((element) => widget.game.platforms.contains(element.name));
      // Fetch game info here
      mostRecentGame = scrapeGameData(widget.game.title, platforms.first);
    } else {
      mostRecentGame = Future<Game>(() => widget.game);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    debugPrint(
        '${queryData.size.height.toString()} ${queryData.size.width.toString()}');

    void handleDelete() async {
      final gameTitle = widget.game.title;
      // close alert-dialog
      Navigator.pop(context, 'OK');
      // Delete the item
      final allGames = await Storage().readGames();
      final index = allGames.indexOf(widget.game);
      if (index == -1) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '[Löschen] Das Spiel $gameTitle konnte nicht gefunden werden.'),
          ),
        );
        return;
      }
      if (!allGames.remove(widget.game)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Ein Fehler ist beim Löschen von $gameTitle aufgetreten.'),
          ),
        );
      }
      await Storage().writeGames(allGames);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$gameTitle gelöscht.'),
        ),
      );

      // go back to main page
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Willst du das Spiel wirklich löschen?'),
                    content:
                        const Text('Es kann nicht wieder hergestellt werden.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: handleDelete,
                        child: const Text('Löschen'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Game>(
          future: mostRecentGame,
          builder: (context, snapshot) => Column(children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.6, 1.0],
                ).createShader(
                    Rect.fromLTRB(0, 0, bounds.width, bounds.height));
              },
              blendMode: BlendMode.dstIn,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: queryData.size.height > 900 ? 350 : 200,
                child:
                    (snapshot.hasData && snapshot.data!.backgroundImage != null)
                        ? FadeInImage.memoryNetwork(
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: kTransparentImage,
                            image: snapshot.data!.backgroundImage!,
                            fit: BoxFit.cover,
                          )
                        : Container(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameListItem(game: widget.game),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (snapshot.hasData) Pair('Name', snapshot.data!.title),
                      if (snapshot.hasData)
                        Pair('Plattform', snapshot.data!.platforms.join(', ')),
                      if (snapshot.hasData)
                        Pair('Preis',
                            '${snapshot.data!.price?.toStringAsFixed(2) ?? 0.toStringAsFixed(2)} €'),
                      if (snapshot.hasData)
                        Pair(
                            'Altersfreigabe',
                            AgeRestrictions.getAgeRestrictionText(
                                snapshot.data!.ageRestriction ??
                                    AgeRestriction.unknown)),
                      if (snapshot.hasData && snapshot.data!.notes != null)
                        Pair('Anmerkungen', snapshot.data!.notes!),
                      if (snapshot.hasData)
                        Pair('Favorisiert',
                            snapshot.data!.isFavourite ? 'Ja' : 'Nein'),
                      if (snapshot.hasData &&
                          snapshot.data!.releaseDate != null)
                        Pair(
                            'Erscheinungsdatum',
                            DateFormat.yMd()
                                .format(snapshot.data!.releaseDate!)),
                      if (snapshot.hasData &&
                          snapshot.data!.metacriticScore != null)
                        Pair('Metacritic Score',
                            '${snapshot.data!.metacriticScore!.toString()} / 100'),
                      if (snapshot.hasData && snapshot.data!.rawgGameId != null)
                        Pair('Scraping powered by RAWG.io',
                            'Game-ID ${snapshot.data!.rawgGameId!.toString()}'),
                      if (snapshot.hasData) Pair('UUID', snapshot.data!.uuid),
                    ]
                        .map((item) => ListTile(
                              title: Text(item.a),
                              subtitle: Text(item.b),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
