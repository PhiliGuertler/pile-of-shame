import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:pile_of_shame/providers/games/game_platforms_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter_provider.g.dart';

@Riverpod(keepAlive: true)
class PlayStatusFilter extends _$PlayStatusFilter {
  @override
  List<PlayStatus> build() {
    return PlayStatus.values;
  }

  void setFilter(List<PlayStatus> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class GamePlatformFamilyFilter extends _$GamePlatformFamilyFilter {
  @override
  List<GamePlatformFamily> build() {
    return GamePlatformFamily.values;
  }

  void setFilter(List<GamePlatformFamily> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class GamePlatformFilter extends _$GamePlatformFilter {
  @override
  List<GamePlatform> build() {
    return GamePlatform.values;
  }

  void setFilter(List<GamePlatform> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class AgeRatingFilter extends _$AgeRatingFilter {
  @override
  List<USK> build() {
    return USK.values;
  }

  void setFilter(List<USK> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class FavoriteFilter extends _$FavoriteFilter {
  @override
  List<bool> build() {
    return [true, false];
  }

  void setFilter(List<bool> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class HasNotesFilter extends _$HasNotesFilter {
  @override
  List<bool> build() {
    return [true, false];
  }

  void setFilter(List<bool> filter) {
    state = filter;
  }
}

@Riverpod(keepAlive: true)
class HasDLCsFilter extends _$HasDLCsFilter {
  @override
  List<bool> build() {
    return [true, false];
  }

  void setFilter(List<bool> filter) {
    state = filter;
  }
}

@riverpod
bool isAnyFilterActive(IsAnyFilterActiveRef ref) {
  final allPlatforms = ref.watch(activeGamePlatformsProvider);
  int numAllPlatforms = allPlatforms.maybeWhen(
    data: (data) => data.length,
    orElse: () => GamePlatform.values.length,
  );
  final platformFilter = ref.watch(gamePlatformFilterProvider);
  final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);
  final playStatusFilter = ref.watch(playStatusFilterProvider);
  final ageRatingFilter = ref.watch(ageRatingFilterProvider);
  final favoriteFilter = ref.watch(favoriteFilterProvider);
  final hasNotesFilter = ref.watch(hasNotesFilterProvider);
  final hasDLCsFilter = ref.watch(hasDLCsFilterProvider);

  return (platformFilter.length < numAllPlatforms ||
      platformFamilyFilter.length < GamePlatformFamily.values.length ||
      playStatusFilter.length < PlayStatus.values.length ||
      ageRatingFilter.length < USK.values.length ||
      favoriteFilter.length < 2 ||
      hasNotesFilter.length < 2 ||
      hasDLCsFilter.length < 2);
}

@riverpod
List<Game> applyGameFilters(ApplyGameFiltersRef ref, List<Game> games) {
  final platformFilter = ref.watch(gamePlatformFilterProvider);
  final allPlatforms = ref.watch(activeGamePlatformsProvider);
  final allLogicalPlatforms = allPlatforms.maybeWhen(
    data: (data) => data.length == platformFilter.length
        ? GamePlatform.values
        : platformFilter,
    orElse: () => platformFilter,
  );
  final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);
  final playStatusFilter = ref.watch(playStatusFilterProvider);
  final ageRatingFilter = ref.watch(ageRatingFilterProvider);
  final favoriteFilter = ref.watch(favoriteFilterProvider);
  final hasNotesFilter = ref.watch(hasNotesFilterProvider);
  final hasDLCsFilter = ref.watch(hasDLCsFilterProvider);

  final result = games.where((Game game) {
    return allLogicalPlatforms.contains(game.platform) &&
        platformFamilyFilter.contains(game.platform.family) &&
        playStatusFilter.contains(game.status) &&
        ageRatingFilter.contains(game.usk) &&
        favoriteFilter.contains(game.isFavorite) &&
        hasNotesFilter.contains(game.notes != null && game.notes!.isNotEmpty) &&
        hasDLCsFilter.contains(game.dlcs.isNotEmpty);
  }).toList();

  return result;
}
