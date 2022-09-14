import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/network/rawg/rawg_api.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/age_restrictions.dart';
import '../models/game.dart';

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

  @override
  void initState() {
    super.initState();
    if (!widget.game.wasScraped) {
      // Fetch game info here
      mostRecentGame =
          RawgApi().searchGameByName(widget.game.title).then((value) {
        widget.game.backgroundImage = value.first.backgroundImage;
        widget.game.releaseDate = DateTime.parse(value.first.released);
        widget.game.metacriticScore = value.first.metacriticScore;
        widget.game.rawgGameId = value.first.id;

        // TODO: This should update the persisted game object!
        return widget.game;
      });
      widget.game.wasScraped = true;
    } else {
      mostRecentGame = Future<Game>(() => widget.game);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    debugPrint(
        '${queryData.size.height.toString()} ${queryData.size.width.toString()}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
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
                        Pair('Platform', snapshot.data!.platforms.join(', ')),
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
