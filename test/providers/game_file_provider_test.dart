import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:pile_of_shame/providers/games/game_file_provider.dart';
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
  late ProviderContainer container;

  setUp(() {
    mockPathProviderPlatform = FakePathProviderPlatform();
    PathProviderPlatform.instance = mockPathProviderPlatform;

    container = ProviderContainer();
  });

  test("correctly returns the game file", () async {
    final file = await container.read(gameFileProvider.future);
    expect(file.path, 'test_resources/game-store.json');
    expect(file.readAsStringSync().replaceAll("\r", ""), """{
    "games": [
        {
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
        }
    ]
}""");
  });
}
