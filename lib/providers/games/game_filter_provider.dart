import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
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

@riverpod
bool isAnyFilterActive(IsAnyFilterActiveRef ref) {
  final platformFilter = ref.watch(gamePlatformFilterProvider);
  final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);
  final playStatusFilter = ref.watch(playStatusFilterProvider);
  final ageRatingFilter = ref.watch(ageRatingFilterProvider);

  return (platformFilter.length != GamePlatform.values.length ||
      platformFamilyFilter.length != GamePlatformFamily.values.length ||
      playStatusFilter.length != PlayStatus.values.length ||
      ageRatingFilter.length != USK.values.length);
}

@riverpod
List<Game> applyGameFilters(ApplyGameFiltersRef ref, List<Game> games) {
  final platformFilter = ref.watch(gamePlatformFilterProvider);
  final platformFamilyFilter = ref.watch(gamePlatformFamilyFilterProvider);
  final playStatusFilter = ref.watch(playStatusFilterProvider);
  final ageRatingFilter = ref.watch(ageRatingFilterProvider);

  final result = games.where((Game game) {
    return platformFilter.contains(game.platform) &&
        platformFamilyFilter.contains(game.platform.family) &&
        playStatusFilter.contains(game.status) &&
        ageRatingFilter.contains(game.usk);
  }).toList();

  return result;
}
