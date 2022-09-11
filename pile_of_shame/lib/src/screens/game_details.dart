import 'package:flutter/material.dart';
import 'package:pile_of_shame/src/network/rawg/rawg_api.dart';
import 'package:pile_of_shame/src/widgets/game_list_item.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/game.dart';

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
          builder: ((context, snapshot) {
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
                    height: 250,
                    child: snapshot.hasData
                        ? FadeInImage.memoryNetwork(
                            fadeInDuration: const Duration(seconds: 1),
                            placeholder: kTransparentImage,
                            image: snapshot.data!.first.backgroundImage,
                            fit: BoxFit.fitHeight,
                          )
                        : null,
                    // if (snapshot.hasError) Text('${snapshot.error}'),
                  ),
                ),
              ],
            );
          }),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: GameListItem(game: widget.game),
        ),
      ]),
    );
  }
}
