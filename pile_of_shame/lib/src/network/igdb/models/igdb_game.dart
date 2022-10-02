import 'package:pile_of_shame/src/network/igdb/models/igdb_image.dart';

class IGDBGame {
  final int id;
  final List<int>? alternativeNameIds;
  final IGDBImage? cover;
  final DateTime? firstReleaseDate;
  final String? name;
  final List<int>? platformIds;
  final List<IGDBImage>? screenshots;
  final String? slug;
  final double? rating;

  IGDBGame({
    required this.id,
    this.alternativeNameIds,
    this.cover,
    this.firstReleaseDate,
    this.name,
    this.platformIds,
    this.screenshots,
    this.slug,
    this.rating,
  });

  IGDBGame.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        rating = json["rating"],
        alternativeNameIds = json["alternative_names"] != null
            ? List<int>.from(json["alternative_names"] as List)
            : null,
        cover =
            json["cover"] != null ? IGDBImage.fromJson(json["cover"]) : null,
        firstReleaseDate = json["first_release_date"] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                json["first_release_date"] * 1000)
            : null,
        name = json["name"],
        platformIds = json["platforms"] != null
            ? List<int>.from(json["platforms"] as List)
            : null,
        screenshots = json["screenshots"] != null
            ? (json["screenshots"] as List)
                .map((screenshot) => IGDBImage.fromJson(screenshot))
                .toList()
            : null,
        slug = json["slug"];
}
