import 'package:pile_of_shame/models/custom_game_display_settings.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_game_display.g.dart';

@Riverpod(keepAlive: true)
class CustomizeGameDisplays extends _$CustomizeGameDisplays with Persistable {
  static const String storageKey = "custom-game-displays";

  @override
  FutureOr<CustomGameDisplaySettings> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return CustomGameDisplaySettings.fromJson(storedJSON);
    }
    return const CustomGameDisplaySettings();
  }

  Future<void> setCustomGameDisplay(CustomGameDisplaySettings settings) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, settings.toJson());
      return settings;
    });
  }
}
