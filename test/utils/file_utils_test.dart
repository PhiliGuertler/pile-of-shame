import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/utils/file_utils.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return null;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return null;
  }

  @override
  Future<String?> getLibraryPath() async {
    return null;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return "test_resources";
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return null;
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return null;
  }

  @override
  Future<String?> getDownloadsPath() async {
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePathProviderPlatform mockPathProviderPlatform;

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;
  });

  test(
      "correctly concatenates the path of a file to the application directory path",
      () async {
    final File result = await FileUtils().openFile("games_filled.json");

    expect(result.path, 'test_resources/games_filled.json');
    expect(result.readAsStringSync().replaceAll('\r', ""), """{
    "games": [
        {
            "id": "zelda-botw",
            "name": "The Legend of Zelda: Breath of the Wild",
            "platform": "Switch",
            "status": "playing",
            "lastModified": "2023-08-08",
            "price": 59.99,
            "usk": "usk12",
            "dlcs": [
                {
                    "name": "Die legendären Prüfungen",
                    "status": "playing",
                    "lastModified": "2023-08-08",
                    "price": 23.99,
                    "releaseDate": "2018-09-03"
                },
                {
                    "name": "Die Ballade der Recken",
                    "status": "playing",
                    "lastModified": "2023-08-08",
                    "price": 23.99,
                    "releaseDate": "2019-03-13"
                }
            ],
            "releaseDate": "2017-04-20",
            "coverArt": "https://cdn02.plentymarkets.com/qozbgypaugq8/item/images/1613/full/PSTR-ZELDA005.jpg"
        },
        {
            "id": "outer-wilds",
            "name": "Outer Wilds",
            "platform": "Steam",
            "status": "completed100Percent",
            "lastModified": "2023-08-04",
            "price": 29.95,
            "usk": "usk12",
            "dlcs": [
                {
                    "name": "Echoes of the Eye",
                    "status": "completed100Percent",
                    "lastModified": "2023-08-08",
                    "price": 16.99
                }
            ]
        },
        {
            "id": "sekiro",
            "name": "Sekiro",
            "platform": "PS4",
            "status": "completed",
            "lastModified": "2023-08-04",
            "price": 60.00,
            "usk": "usk18",
            "dlcs": []
        }
    ]
}""");
  });
}
