import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';

class TestHardware {
  const TestHardware._();

  static final console = VideoGameHardware(
    id: 'console',
    name: "Console",
    platform: GamePlatform.playStation5,
    price: 499.99,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
  static const String consoleJson =
      '{"id":"console","name":"Console","platform":"PS5","price":499.99,"lastModified":"2023-01-01T00:00:00.000","createdAt":"2023-01-01T00:00:00.000","notes":null,"wasGifted":false}';
  static final giftedConsole = VideoGameHardware(
    id: 'console-gift',
    name: "Gifted Console",
    platform: GamePlatform.playStation5,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
    wasGifted: true,
    notes: "This console was gifted to me!",
  );
  static final controllerRed = VideoGameHardware(
    id: 'controller-red',
    name: "Controller (red)",
    platform: GamePlatform.playStation5,
    price: 49.95,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
  static final controllerBlue = VideoGameHardware(
    id: 'controller-blue',
    name: "Controller (blue)",
    platform: GamePlatform.playStation5,
    price: 49.95,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
}
