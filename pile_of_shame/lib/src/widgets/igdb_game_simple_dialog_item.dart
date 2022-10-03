import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';
import 'package:transparent_image/transparent_image.dart';

import '../scrapers/igdb_scraper.dart';

class IGDBGameSimpleDialogItem extends StatelessWidget {
  const IGDBGameSimpleDialogItem(
      {super.key, required this.igdbGame, required this.onPressed});

  final IGDBGame igdbGame;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (igdbGame.cover != null)
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(
                IGDBScraper.generateIGDBImageUrl(
                    igdbGame.cover!.imageId, IGDBImageSizes.coverSmall),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (igdbGame.name != null)
                  Text(
                    igdbGame.name!,
                    style: const TextStyle(fontSize: 20),
                  ),
                if (igdbGame.firstReleaseDate != null)
                  Text(
                      "Erscheinungsdatum: ${DateFormat.yMd().format(igdbGame.firstReleaseDate!)}"),
                if (igdbGame.platforms != null)
                  Text(
                    igdbGame.platforms!.join(", "),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
