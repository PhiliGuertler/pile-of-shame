import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

class TestGames {
  const TestGames._();

  // ### Dark Souls ######################################################### //
  static final dlcDarkSoulsArtorias = DLC(
    id: 'dark-souls-artorias-of-the-abyss',
    name: "Artorias of the Abyss",
    status: PlayStatus.onWishList,
    lastModified: DateTime(2013, 7, 10),
    createdAt: DateTime(2013, 7, 10),
    price: 9.99,
  );

  static final gameDarkSouls = Game(
    id: 'dark-souls',
    name: "Dark Souls",
    platform: GamePlatform.playStation4,
    status: PlayStatus.replaying,
    lastModified: DateTime(2023, 4, 20),
    createdAt: DateTime(2022, 8, 8),
    price: 39.99,
    usk: USK.usk16,
    isFavorite: true,
    dlcs: [
      dlcDarkSoulsArtorias,
    ],
    notes: "One of the best games of all time!",
  );
  // ### /Dark Souls ######################################################## //

  // ### Outer Wilds ######################################################## //
  static final DLC dlcOuterWildsEchoesOfTheEye = DLC(
    createdAt: DateTime(2022, 9, 28),
    id: 'outer-wilds-echoes-of-the-eye',
    name: 'Echoes of the Eye',
    lastModified: DateTime(2023, 1, 2),
    status: PlayStatus.playing,
    isFavorite: true,
    notes: "Kinda scary, ngl",
    price: 19.99,
  );

  static final Game gameOuterWilds = Game(
    id: 'outer-wilds',
    lastModified: DateTime(2023),
    createdAt: DateTime(2022, 8, 8),
    name: 'Outer Wilds',
    platform: GamePlatform.steam,
    price: 24.99,
    status: PlayStatus.completed,
    dlcs: [dlcOuterWildsEchoesOfTheEye],
    usk: USK.usk12,
    notes: "Outer Wilds can sadly only be played once...",
  );
  // ### /Outer Wilds ####################################################### //

  // ### The Witcher 3: Wild Hunt ########################################### //
  static final DLC dlcWitcher3HeartOfStone = DLC(
    createdAt: DateTime(2015, 10, 13),
    id: 'witcher-3-hearts-of-stone',
    name: 'Hearts of Stone',
    lastModified: DateTime(2023, 1, 2),
    status: PlayStatus.completed,
    notes: "This one contains Gaunter O'Dim",
    price: 9.99,
  );

  static final DLC dlcWitcher3BloodAndWine = DLC(
    createdAt: DateTime(2016, 5, 31),
    id: 'witcher-3-blood-and-wine',
    name: 'Hearts of Stone',
    lastModified: DateTime(2023, 1, 2),
    status: PlayStatus.playing,
    isFavorite: true,
    notes: "Let's head to Toussaint",
    price: 19.99,
  );

  static final Game gameWitcher3 = Game(
    id: 'witcher-3',
    lastModified: DateTime(2023),
    createdAt: DateTime(2015, 5, 19),
    name: 'The Witcher 3: Wild Hunt',
    platform: GamePlatform.gog,
    price: 59.99,
    status: PlayStatus.completed,
    dlcs: [
      dlcWitcher3HeartOfStone,
      dlcWitcher3BloodAndWine,
    ],
    usk: USK.usk18,
  );
  static const String gameWitcher3Json =
      '{"id":"witcher-3","name":"The Witcher 3: Wild Hunt","platform":"Gog","status":"completed","lastModified":"2023-01-01T00:00:00.000","createdAt":"2015-05-19T00:00:00.000","price":59.99,"usk":"usk18","dlcs":[{"id":"witcher-3-hearts-of-stone","name":"Hearts of Stone","status":"completed","lastModified":"2023-01-02T00:00:00.000","createdAt":"2015-10-13T00:00:00.000","price":9.99,"notes":"This one contains Gaunter O\'Dim","isFavorite":false,"priceVariant":"bought"},{"id":"witcher-3-blood-and-wine","name":"Hearts of Stone","status":"playing","lastModified":"2023-01-02T00:00:00.000","createdAt":"2016-05-31T00:00:00.000","price":19.99,"notes":"Let\'s head to Toussaint","isFavorite":true,"priceVariant":"bought"}],"notes":null,"isFavorite":false,"priceVariant":"bought"}';
  // ### /The Witcher 3: Wild Hunt ########################################## //

  static final Game gameDistance = Game(
    id: 'distance',
    lastModified: DateTime(2023, 1, 2),
    createdAt: DateTime(2022, 8, 8),
    name: 'Distancé',
    platform: GamePlatform.steam,
    price: 19.99,
    status: PlayStatus.playing,
    dlcs: [],
  );

  static final Game gameSsx3 = Game(
    id: 'ssx-3',
    lastModified: DateTime(2023, 1, 3),
    createdAt: DateTime(2022, 8, 8),
    name: 'SSX 3',
    platform: GamePlatform.playStation2,
    price: 39.95,
    status: PlayStatus.completed100Percent,
    dlcs: [],
    usk: USK.usk6,
  );

  static final Game gameOriAndTheBlindForest = Game(
    id: 'ori-and-the-blind-forest',
    lastModified: DateTime(2023, 1, 4),
    createdAt: DateTime(2022, 8, 8),
    name: 'Ori and the blind forest',
    platform: GamePlatform.playStation4,
    price: 25,
    status: PlayStatus.onPileOfShame,
    dlcs: [],
    usk: USK.usk12,
  );
}
