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
  late Future<Iterable<RawgGame>> gameInfos;

  @override
  void initState() {
    super.initState();
    // Fetch game info here
    gameInfos = RawgApi().searchGameByName(widget.game.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(children: [
        FutureBuilder<Iterable<RawgGame>>(
          future: gameInfos,
          builder: ((futureBuilderContext, snapshot) {
            return Stack(
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: snapshot.hasData
                        ? FadeInImage.memoryNetwork(
                            fadeInDuration: const Duration(milliseconds: 250),
                            placeholder: kTransparentImage,
                            image: snapshot.data!.first.backgroundImage,
                            fit: BoxFit.fitWidth,
                          )
                        : null,
                  ),
                ),
              ],
            );
          }),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GameListItem(game: widget.game),
              const Text('Bearbeitbare Informationen:'),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  var editableData = <Pair<String, String>>[
                    Pair('Name', widget.game.title),
                    Pair('Platform', widget.game.platform),
                    Pair('Preis',
                        '${widget.game.price?.toStringAsFixed(2) ?? 0.toStringAsFixed(2)} €'),
                    Pair(
                        'Altersfreigabe',
                        AgeRestrictions.getAgeRestrictionText(
                            widget.game.ageRestriction ??
                                AgeRestriction.unknown)),
                  ];
                  var item = editableData[index];
                  return ListTile(
                    title: Text(item.a),
                    subtitle: Text(item.b),
                  );
                },
              ),
              FutureBuilder<Iterable<RawgGame>>(
                future: gameInfos,
                builder: ((context, snapshot) {
                  var displayData = snapshot.hasData
                      ? <Pair<String, String>>[
                          Pair('Name', snapshot.data!.first.name),
                          Pair(
                              'Erscheinungsdatum',
                              DateFormat.yMd().format(DateTime.parse(
                                  snapshot.data!.first.released))),
                          Pair('Metacritic Wertung',
                              snapshot.data!.first.metacriticScore.toString()),
                        ]
                      : <Pair<String, String>>[];
                  if (snapshot.hasData) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RAWG.io Infos zum Spiel:'),
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: displayData.length,
                              itemBuilder: (context, index) {
                                var item = displayData[index];
                                return ListTile(
                                  title: Text(item.a),
                                  subtitle: Text(item.b),
                                );
                              }),
                        ]);
                  }
                  return Container();
                }),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
