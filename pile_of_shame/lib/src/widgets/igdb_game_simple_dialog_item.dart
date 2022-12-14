import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pile_of_shame/src/network/igdb/models/igdb_game.dart';

import '../scrapers/igdb_scraper.dart';

class IGDBGameSimpleDialogItem extends StatelessWidget {
  const IGDBGameSimpleDialogItem(
      {super.key, required this.igdbGame, required this.onPressed});

  final IGDBGame igdbGame;
  final VoidCallback onPressed;

  static const double imageWidth = 60.0;
  static const double imageHeight = imageWidth * 4 / 3;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: igdbGame.cover != null
                ? Image(
                    image: CachedNetworkImageProvider(
                      IGDBScraper.generateIGDBImageUrl(
                          igdbGame.cover!.imageId, IGDBImageSizes.coverSmall),
                    ),
                  )
                : Container(),
          ),
          Expanded(
            child: Padding(
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
                    Text(DateFormat.yMd().format(igdbGame.firstReleaseDate!)),
                  if (igdbGame.platforms != null)
                    Text(
                      igdbGame.platforms!.join(", "),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
