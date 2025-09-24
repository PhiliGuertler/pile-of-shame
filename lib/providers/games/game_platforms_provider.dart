import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/providers/games/game_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_platforms_provider.freezed.dart';
part 'game_platforms_provider.g.dart';

@freezed
abstract class GamePlatformList with _$GamePlatformList {
  const factory GamePlatformList({
    required List<GamePlatform> platforms,
  }) = _GamePlatformList;
  const GamePlatformList._();

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
        storageKey,
        GamePlatformList(platforms: platforms).toJson(),
      );
      return platforms;
    });
  }
}

@riverpod
FutureOr<List<GamePlatformFamily>> activeGamePlatformFamilies(
  Ref ref,
) async {
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);

  final Set<GamePlatformFamily> families = {};

  for (final platform in activePlatforms) {
    families.add(platform.family);
  }

  return families.toList();
}

@riverpod
Map<GamePlatformFamily, List<GamePlatform>> gamePlatformsByFamily(
  Ref ref,
) {
  final Map<GamePlatformFamily, List<GamePlatform>> result = {};

  for (final family in GamePlatformFamily.values) {
    result[family] = GamePlatform.values
        .where((platform) => platform.family == family)
        .toList();
  }
  result.removeWhere((key, value) => value.isEmpty);

  return result;
}

@riverpod
FutureOr<Map<GamePlatformFamily, List<GamePlatform>>>
    activeGamePlatformsByFamily(Ref ref) async {
  final activePlatforms = await ref.watch(activeGamePlatformsProvider.future);

  final Map<GamePlatformFamily, List<GamePlatform>> result = {};

  for (final family in GamePlatformFamily.values) {
    result[family] =
        activePlatforms.where((platform) => platform.family == family).toList();
  }
  result.removeWhere((key, value) => value.isEmpty);

  return result;
}

@riverpod
FutureOr<List<GamePlatformFamily>> gamePlatformFamiliesWithSavedGames(
  Ref ref,
) async {
  final games = await ref.watch(gamesProvider.future);

  final Set<GamePlatformFamily> result = {};
  for (final element in games) {
    result.add(element.platform.family);
  }

  return result.toList();
}
