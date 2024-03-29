import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/providers/database/database_file_provider.dart';

import '../test_utils/fake_path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePathProviderPlatform mockPathProviderPlatform;
  late ProviderContainer container;

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;

    container = ProviderContainer();
  });

  test("correctly returns the game file", () async {
    final file = await container.read(databaseFileProvider.future);
    expect(file.path, 'test_resources/game-store.json');
    expect(file.readAsStringSync().replaceAll("\r", ""), """
{
    "games": [
        {
            "id": "witcher-3",
            "name": "The Witcher 3: Wild Hunt",
            "platform": "Gog",
            "status": "completed",
            "lastModified": "2023-01-01T00:00:00.000",
            "createdAt": "2015-05-19T00:00:00.000",
            "price": 59.99,
            "usk": "usk18",
            "dlcs": [
                {
                    "id": "witcher-3-hearts-of-stone",
                    "name": "Hearts of Stone",
                    "status": "completed",
                    "lastModified": "2023-01-02T00:00:00.000",
                    "createdAt": "2015-10-13T00:00:00.000",
                    "price": 9.99,
                    "notes": "This one contains Gaunter O'Dim",
                    "isFavorite": false,
                    "wasGifted": false
                },
                {
                    "id": "witcher-3-blood-and-wine",
                    "name": "Hearts of Stone",
                    "status": "playing",
                    "lastModified": "2023-01-02T00:00:00.000",
                    "createdAt": "2016-05-31T00:00:00.000",
                    "price": 19.99,
                    "notes": "Let's head to Toussaint",
                    "isFavorite": true,
                    "wasGifted": false
                }
            ],
            "notes": null,
            "isFavorite": false,
            "wasGifted": false
        },
        {
            "id": "ssx-3",
            "name": "SSX 3",
            "platform": "PS2",
            "status": "completed100Percent",
            "lastModified": "2023-01-03T00:00:00.000",
            "createdAt": "2022-08-08T00:00:00.000",
            "price": 39.95,
            "usk": "usk6",
            "dlcs": [],
            "notes": null,
            "isFavorite": false,
            "wasGifted": false
        },
        {
            "id": "ori-and-the-blind-forest",
            "name": "Ori and the blind forest",
            "platform": "PS4",
            "status": "onPileOfShame",
            "lastModified": "2023-01-04T00:00:00.000",
            "createdAt": "2022-08-08T00:00:00.000",
            "price": 25.0,
            "usk": "usk12",
            "dlcs": [],
            "notes": null,
            "isFavorite": false,
            "wasGifted": false
        }
    ]
}""");
  });
}
