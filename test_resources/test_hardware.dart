import 'package:pile_of_shame/models/hardware.dart';

class TestHardware {
  const TestHardware._();

  static final console = VideoGameHardware(
    id: 'console',
    name: "Console",
    price: 499.99,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
  static final giftedConsole = VideoGameHardware(
    id: 'console-gift',
    name: "Gifted Console",
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
    wasGifted: true,
    notes: "This console was gifted to me!",
  );
  static final controllerRed = VideoGameHardware(
    id: 'controller-red',
    name: "Controller (red)",
    price: 49.95,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
  static final controllerBlue = VideoGameHardware(
    id: 'controller-blue',
    name: "Controller (blue)",
    price: 49.95,
    lastModified: DateTime(2023),
    createdAt: DateTime(2023),
  );
}
