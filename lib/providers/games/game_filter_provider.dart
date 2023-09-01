import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_filter_provider.g.dart';

@riverpod
class PlayStatusFilter extends _$PlayStatusFilter {
  @override
  List<PlayStatus> build() {
    return PlayStatus.values;
  }

  void setFilter(List<PlayStatus> filter) {
    state = filter;
  }
}

@riverpod
class GamePlatformFamilyFilter extends _$GamePlatformFamilyFilter {
  @override
  List<GamePlatformFamily> build() {
    return GamePlatformFamily.values;
  }

  void setFilter(List<GamePlatformFamily> filter) {
    state = filter;
  }
}

@riverpod
class GamePlatformFilter extends _$GamePlatformFilter {
  @override
  List<GamePlatform> build() {
    return GamePlatform.values;
  }

  void setFilter(List<GamePlatform> filter) {
    state = filter;
  }
}

@riverpod
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
