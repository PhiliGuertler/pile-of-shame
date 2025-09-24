// ignore_for_file: use_setters_to_change_properties

import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_filters.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter_provider.g.dart';

@Riverpod(keepAlive: true)
class GameFilter extends _$GameFilter with Persistable {
  static const String storageKey = "game-filters";

  @override
  FutureOr<GameFilters> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return GameFilters.fromJson(storedJSON);
    }
    return const GameFilters();
  }

  Future<void> setFilters(GameFilters filters) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, filters.toJson());
      return filters;
    });
  }
}

@riverpod
FutureOr<bool> isAnyFilterActive(Ref ref) async {
  final allPlatforms = await ref.watch(activeGamePlatformsProvider.future);
  final allPlatformFamilies =
      await ref.read(activeGamePlatformFamiliesProvider.future);

  final filters = await ref.watch(gameFilterProvider.future);

  final bool isPlatformFilterActive =
      !allPlatforms.every((element) => filters.platforms.contains(element));
  final bool isPlatformFamilyFilterActive = !allPlatformFamilies
      .every((element) => filters.platformFamilies.contains(element));

  return isPlatformFilterActive ||
      isPlatformFamilyFilterActive ||
      filters.playstatuses.length < PlayStatus.values.length ||
      filters.ageRatings.length < USK.values.length ||
      filters.isFavorite.length < 2 ||
      filters.hasNotes.length < 2 ||
      filters.hasDLCs.length < 2;
}

@riverpod
FutureOr<List<Game>> applyGameFilters(
  Ref ref,
  List<Game> games,
) async {
  final filters = await ref.watch(gameFilterProvider.future);

  final activeGamePlatforms =
      await ref.watch(activeGamePlatformsProvider.future);
  final activeGamePlatformFamilies =
      await ref.watch(activeGamePlatformFamiliesProvider.future);

  // use the platforms and families that are both in filters and actives
  List<GamePlatform> commonPlatforms = activeGamePlatforms
      .toSet()
      .intersection(filters.platforms.toSet())
      .toList();
  if (commonPlatforms.length == activeGamePlatforms.length) {
    commonPlatforms = GamePlatform.values;
  }
  List<GamePlatformFamily> commonPlatformFamilies = activeGamePlatformFamilies
      .toSet()
      .intersection(filters.platformFamilies.toSet())
      .toList();
  if (commonPlatformFamilies.length == activeGamePlatformFamilies.length) {
    commonPlatformFamilies = GamePlatformFamily.values;
  }

  final result = games.where((Game game) {
    return commonPlatforms.contains(game.platform) &&
        commonPlatformFamilies.contains(game.platform.family) &&
        filters.playstatuses.contains(game.status) &&
        filters.ageRatings.contains(game.usk) &&
        filters.isFavorite.contains(game.isFavorite) &&
        filters.hasNotes
            .contains(game.notes != null && game.notes!.isNotEmpty) &&
        filters.hasDLCs.contains(game.dlcs.isNotEmpty);
  }).toList();

  return result;
}
