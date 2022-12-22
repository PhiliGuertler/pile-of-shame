class IGDBImage {
  final int gameId;
  final int height;
  final int width;
  final String url;
  final String imageId;

  IGDBImage({
    required this.gameId,
    required this.height,
    required this.width,
    required this.url,
    required this.imageId,
  });

  IGDBImage.fromJson(Map<String, dynamic> json)
      : gameId = json["game"],
        height = json["height"],
        width = json["width"],
        url = json["url"],
        imageId = json["image_id"];
}
