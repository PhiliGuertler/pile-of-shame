class IGDBAuthorization {
  final String accessToken;
  final int expiresIn;
  final DateTime expirationDate;
  final String tokenType;

  IGDBAuthorization({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  }) : expirationDate = DateTime.now()..add(Duration(milliseconds: expiresIn));

  IGDBAuthorization.fromJson(Map<String, dynamic> json)
      : accessToken = json["access_token"],
        expiresIn = json["expires_in"],
        tokenType = json["token_type"],
        expirationDate = DateTime.now()
          ..add(
            Duration(
              milliseconds: json["expires_in"],
            ),
          );
}
