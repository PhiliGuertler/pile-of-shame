import 'package:flutter_test/flutter_test.dart';

import 'package:meta_game/meta_game.dart';

void main() {
  group("Game class", () {
    test('Game serializes to JSON correctly', () {
      Game testGame = Game(
        playStatus: PlayStatus.onPileOfShame,
        platforms: [
          Platform.gameBoy,
          Platform.gameBoyColor,
        ],
        title: 'Test-Game XVII',
        ageRestriction: AgeRestriction.usk12,
        backgroundImage: Uri.parse('file://some/place/to/file.jpg'),
        coverImage: Uri.parse('file://some/place/to/file.jpg'),
        externalGameId: -1,
        isFavourite: true,
        lastUpdated: DateTime.parse('2022-12-22T15:45:24.000'),
        releaseDate: DateTime.parse('2020-10-04T00:00:00.000'),
        notes: 'These are some wild notes',
        onlineScore: 94,
        price: 59.99,
      );

      final json = testGame.toJson();
      expect(json['playStatus'], PlayStatus.onPileOfShame.code);
      expect(json['platforms'],
          [Platform.gameBoy.code, Platform.gameBoyColor.code]);
      expect(json['title'], 'Test-Game XVII');
      expect(json['ageRestriction'], AgeRestriction.usk12.code);
      expect(json['backgroundImage'], 'file://some/place/to/file.jpg');
      expect(json['coverImage'], 'file://some/place/to/file.jpg');
      expect(json['externalGameId'], -1);
      expect(json['isFavourite'], true);
      expect(json['lastUpdated'], '2022-12-22T15:45:24.000');
      expect(json['releaseDate'], '2020-10-04T00:00:00.000');
      expect(json['notes'], 'These are some wild notes');
      expect(json['onlineScore'], 94);
      expect(json['price'], 59.99);
    });
    test('Game deserializes from JSON correctly', () {
      Map<String, dynamic> json = {};
      json['playStatus'] = PlayStatus.onPileOfShame.code;
      json['platforms'] = [Platform.gameBoy.code, Platform.gameBoyColor.code];
      json['title'] = 'Test-Game XVII';
      json['ageRestriction'] = AgeRestriction.usk12.code;
      json['backgroundImage'] = 'file://some/place/to/file.jpg';
      json['coverImage'] = 'file://some/place/to/file.jpg';
      json['externalGameId'] = -1;
      json['isFavourite'] = true;
      json['lastUpdated'] = '2022-12-22T15:45:24.000';
      json['releaseDate'] = '2020-10-04T00:00:00.000';
      json['notes'] = 'These are some wild notes';
      json['onlineScore'] = 94;
      json['price'] = 59.99;
      json['uuid'] = 'abcde-fghij';

      final Game testGame = Game.fromJson(json);
      expect(testGame.playStatus, PlayStatus.onPileOfShame);
      expect(testGame.platforms, [Platform.gameBoy, Platform.gameBoyColor]);
      expect(testGame.title, 'Test-Game XVII');
      expect(testGame.ageRestriction, AgeRestriction.usk12);
      expect(
          testGame.backgroundImage, Uri.parse('file://some/place/to/file.jpg'));
      expect(testGame.coverImage, Uri.parse('file://some/place/to/file.jpg'));
      expect(testGame.externalGameId, -1);
      expect(testGame.isFavourite, true);
      expect(testGame.lastUpdated, DateTime.parse('2022-12-22T15:45:24.000'));
      expect(testGame.releaseDate, DateTime.parse('2020-10-04T00:00:00.000'));
      expect(testGame.notes, 'These are some wild notes');
      expect(testGame.onlineScore, 94);
      expect(testGame.price, 59.99);
    });
  });
}
