import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/models/game_status.dart';
import 'package:test/test.dart';
import 'package:pile_of_shame/src/models/game.dart';

void main() {
  group('Game', () {
    test('JSON encoding works as intended', () {
      final Game game = Game.withUuid(
        uuid: '123456',
        title: 'Test-Game',
        gameState: GameState.completed,
        platforms: ['PC', 'Nintendo Switch'],
        ageRestriction: AgeRestriction.usk12,
        backgroundImage: 'https://some.url',
        isFavourite: false,
        onlineScore: 99,
        price: 91.64,
        externalGameId: 1234,
        releaseDate: DateTime.parse('1999-01-02'),
        notes: 'These are some noteworthy notes',
      );

      final result = game.toJson();

      expect(
        result,
        {
          'uuid': '123456',
          'title': 'Test-Game',
          'gameState': GameState.completed.index,
          'platforms': ['PC', 'Nintendo Switch'],
          'ageRestriction': AgeRestriction.usk12.index,
          'backgroundImage': 'https://some.url',
          'isFavourite': false,
          'metacriticScore': 99,
          'price': 91.64,
          'externalGameId': 1234,
          'releaseDate': '1999-01-02T00:00:00.000',
          'notes': 'These are some noteworthy notes',
        },
      );
    });
    test('JSON decoding works as intended', () {
      final jsonMap = {
        'uuid': '123456',
        'title': 'Test-Game',
        'gameState': GameState.completed.index,
        'platforms': ['PC', 'Nintendo Switch'],
        'ageRestriction': AgeRestriction.usk12.index,
        'backgroundImage': 'https://some.url',
        'isFavourite': false,
        'metacriticScore': 99,
        'price': 91.64,
        'externalGameId': 1234,
        'releaseDate': '1999-01-02T00:00:00.000',
        'notes': 'These are some noteworthy notes',
      };

      final Game expectedGame = Game.withUuid(
        uuid: '123456',
        title: 'Test-Game',
        gameState: GameState.completed,
        platforms: ['PC', 'Nintendo Switch'],
        ageRestriction: AgeRestriction.usk12,
        backgroundImage: 'https://some.url',
        isFavourite: false,
        onlineScore: 99,
        price: 91.64,
        externalGameId: 1234,
        releaseDate: DateTime.parse('1999-01-02'),
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
