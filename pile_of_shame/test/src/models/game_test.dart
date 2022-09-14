import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:test/test.dart';
import 'package:pile_of_shame/src/models/game.dart';

void main() {
  group('Game', () {
    test('JSON encoding works as intended', () {
      final Game game = Game(
        title: 'Test-Game',
        platforms: ['PC', 'Nintendo Switch'],
        ageRestriction: AgeRestriction.usk12,
        backgroundImage: 'https://some.url',
        isFavourite: false,
        metacriticScore: 99,
        price: 91.64,
        rawgGameId: 1234,
        releaseDate: DateTime.parse('1999-01-02'),
        wasScraped: true,
        notes: 'These are some noteworthy notes',
      );

      final result = game.toJson();

      expect(
        result,
        {
          'title': 'Test-Game',
          'platforms': ['PC', 'Nintendo Switch'],
          'ageRestriction': 3,
          'backgroundImage': 'https://some.url',
          'isFavourite': false,
          'metacriticScore': 99,
          'price': 91.64,
          'rawgGameId': 1234,
          'releaseDate': '1999-01-02T00:00:00.000',
          'wasScraped': true,
          'notes': 'These are some noteworthy notes',
        },
      );
    });
    test('JSON decoding works as intended', () {
      final jsonMap = {
        'title': 'Test-Game',
        'platforms': ['PC', 'Nintendo Switch'],
        'ageRestriction': 3,
        'backgroundImage': 'https://some.url',
        'isFavourite': false,
        'metacriticScore': 99,
        'price': 91.64,
        'rawgGameId': 1234,
        'releaseDate': '1999-01-02T00:00:00.000',
        'wasScraped': true,
        'notes': 'These are some noteworthy notes',
      };

      final Game expectedGame = Game(
        title: 'Test-Game',
        platforms: ['PC', 'Nintendo Switch'],
        ageRestriction: AgeRestriction.usk12,
        backgroundImage: 'https://some.url',
        isFavourite: false,
        metacriticScore: 99,
        price: 91.64,
        rawgGameId: 1234,
        releaseDate: DateTime.parse('1999-01-02'),
        wasScraped: true,
        notes: 'These are some noteworthy notes',
      );

      final result = Game.fromJson(jsonMap);

      expect(
        result,
        expectedGame,
      );
    });
  });
}
