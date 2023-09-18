import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_platforms_provider.freezed.dart';
part 'game_platforms_provider.g.dart';

@freezed
class GamePlatformList with _$GamePlatformList {
  const GamePlatformList._();

  const factory GamePlatformList({
    required List<GamePlatform> platforms,
  }) = _GamePlatformList;

  factory GamePlatformList.fromJson(Map<String, dynamic> json) =>
      _$GamePlatformListFromJson(json);
}

@Riverpod(keepAlive: true)
class ActiveGamePlatforms extends _$ActiveGamePlatforms with Persistable {
  static const String storageKey = "game-platforms";

  @override
  FutureOr<List<GamePlatform>> build() async {
    final json = await loadFromStorage(storageKey);
    if (json != null) {
      final GamePlatformList list = GamePlatformList.fromJson(json);
      return list.platforms;
    }
    return GamePlatform.values;
  }

  Future<void> updatePlatforms(List<GamePlatform> platforms) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(
          storageKey, GamePlatformList(platforms: platforms).toJson());
      return platforms;
    });
  }
}

@riverpod
FutureOr<List<GamePlatformFamily>> activeGamePlatformFamilies(
    ActiveGamePlatformFamiliesRef ref) async {
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);

  List<GamePlatformFamily> families = [];

  for (var platform in activePlatforms) {
    if (!families.contains(platform.family)) {
      families.add(platform.family);
    }
  }

  return families;
}

@riverpod
Map<GamePlatformFamily, List<GamePlatform>> gamePlatformsByFamily(
    GamePlatformsByFamilyRef ref) {
  Map<GamePlatformFamily, List<GamePlatform>> result = {};

  for (var family in GamePlatformFamily.values) {
    result[family] = GamePlatform.values
        .where((platform) => platform.family == family)
        .toList();
  }
  result.removeWhere((key, value) => value.isEmpty);

  return result;
}

@riverpod
FutureOr<Map<GamePlatformFamily, List<GamePlatform>>>
    activeGamePlatformsByFamily(ActiveGamePlatformsByFamilyRef ref) async {
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);

  Map<GamePlatformFamily, List<GamePlatform>> result = {};

  for (var family in GamePlatformFamily.values) {
    result[family] =
        activePlatforms.where((platform) => platform.family == family).toList();
  }
  result.removeWhere((key, value) => value.isEmpty);

  return result;
}