import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:pile_of_shame/src/persistance/storage.dart';
import 'package:pile_of_shame/src/scrapers/igdb_scraper.dart';
import 'package:pile_of_shame/src/widgets/game_displays/game_details_header.dart';
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
  const GameDetails({super.key, required this.originalGame});

  final Game originalGame;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  late Future<Game> mostRecentGame;
  bool isScraping = false;

  void refreshGame() {
    setState(() {
      mostRecentGame = Storage().getGameByUuid(widget.originalGame.uuid);
    });
    mostRecentGame.then((value) {
      setState(() {
        isScraping = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    mostRecentGame = Future.value(widget.originalGame);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: Builder(
            builder: (context) {
              return isScraping ? const LinearProgressIndicator() : Container();
            },
          ),
        ),
        actions: [
          FutureBuilder<Game>(
            builder: (context, snapshot) => IconButton(
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
                        onPressed: () async {
                          final gameTitle = snapshot.hasData
                              ? snapshot.data!.title
                              : 'Unbekanntes Spiel';
                          // close alert-dialog
                          Navigator.pop(context, 'OK');
                          // Delete the item
                          bool isDeletionSuccessful = await Storage()
                              .deleteGameByUuid(widget.originalGame.uuid);
                          if (!isDeletionSuccessful) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Ein Fehler ist beim Löschen von $gameTitle aufgetreten.',
                                ),
                              ),
                            );
                            return;
                          }
                          if (isDeletionSuccessful) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('$gameTitle erfolgreich gelöscht.'),
                              ),
                            );
                          }
                          // go back to main page
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        child: const Text('Löschen'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          FutureBuilder<Game>(
            future: mostRecentGame,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) =>
                            EditGameDetails(game: snapshot.data!)),
                      ),
                    );
                    refreshGame();
                  },
                  icon: const Icon(Icons.edit),
                );
              } else {
                return Container();
              }
            },
          ),
          FutureBuilder<Game>(
            future: mostRecentGame,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  onPressed: () async {
                    setState(() {
                      isScraping = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lade Informationen via IGDB"),
                      ),
                    );

                    IGDBScraper scraper = IGDBScraper();
                    Game? scrapedGame = await scraper.scrapeAndUpdateGame(
                      snapshot.data!,
                      context: context,
                      onGameSelected: (game) {
                        // close the dialog and store the game in scrapedGame
                        Navigator.pop(context, game);
                      },
                      skipIfAlreadyScraped: false,
                    );
                    debugPrint("Scraping done");
                    // update the game in storage and display a message
                    if (scrapedGame != null) {
                      await Storage().addOrUpdateGame(scrapedGame);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Informationen aktualisiert."),
                        ),
                      );
                      // refresh display
                      refreshGame();
                    } else {
                      debugPrint("Dialog Cancelled");
                    }
                    setState(() {
                      isScraping = false;
                    });
                  },
                  icon: const Icon(Icons.cloud_download),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              child: FutureBuilder<Game>(
                future: mostRecentGame,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: queryData.size.height > 900 ? 350 : 200,
                      child: (snapshot.hasData &&
                              snapshot.data!.backgroundImage != null)
                          ? FadeInImage.memoryNetwork(
                              fadeInDuration: const Duration(milliseconds: 250),
                              placeholder: kTransparentImage,
                              image: snapshot.data!.backgroundImage!,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    );
                  }
                  return Container();
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameDetailsHeader(
                  game: widget.originalGame,
                  coverOffsetY: -50,
                  coverScale: 2.0,
                ),
                FutureBuilder<Game>(
                  future: mostRecentGame,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            if (snapshot.hasData)
                              Pair('Name', snapshot.data!.title),
                            if (snapshot.hasData)
                              Pair(
                                'Status',
                                GameStates.gameStateToString(
                                    snapshot.data!.gameState),
                              ),
                            if (snapshot.hasData)
                              Pair('Plattform',
                                  snapshot.data!.platforms.join(', ')),
                            if (snapshot.hasData)
                              Pair('Preis',
                                  '${snapshot.data!.price?.toStringAsFixed(2) ?? 0.toStringAsFixed(2)} €'),
                            if (snapshot.hasData)
                              Pair(
                                  'Altersfreigabe',
                                  AgeRestrictions.getAgeRestrictionText(
                                      snapshot.data!.ageRestriction ??
                                          AgeRestriction.unknown)),
                            if (snapshot.hasData &&
                                snapshot.data!.notes != null)
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
                                snapshot.data!.onlineScore != null)
                              Pair('Online Score',
                                  '${snapshot.data!.onlineScore!.toString()} / 100'),
                            if (snapshot.hasData &&
                                snapshot.data!.externalGameId != null)
                              Pair('Externe Game-ID',
                                  snapshot.data!.externalGameId!.toString()),
                            if (snapshot.hasData &&
                                snapshot.data!.coverImage != null)
                              Pair('Coverbild-URL',
                                  snapshot.data!.coverImage!.toString()),
                            if (snapshot.hasData &&
                                snapshot.data!.backgroundImage != null)
                              Pair('Hintergrundbild-URL',
                                  snapshot.data!.backgroundImage!.toString()),
                            if (snapshot.hasData)
                              Pair('UUID', snapshot.data!.uuid),
                          ]
                              .map((item) => ListTile(
                                    title: Text(item.a),
                                    subtitle: Text(item.b),
                                  ))
                              .toList(),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
