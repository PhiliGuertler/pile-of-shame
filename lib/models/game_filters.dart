import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'game_filters.freezed.dart';
part 'game_filters.g.dart';

@freezed
abstract class GameFilters with _$GameFilters {
  const factory GameFilters({
    @Default(PlayStatus.values) List<PlayStatus> playstatuses,
    @Default(GamePlatformFamily.values)
    List<GamePlatformFamily> platformFamilies,
    @Default(GamePlatform.values) List<GamePlatform> platforms,
    @Default(USK.values) List<USK> ageRatings,
    @Default([true, false]) List<bool> isFavorite,
    @Default([true, false]) List<bool> hasNotes,
    @Default([true, false]) List<bool> hasDLCs,
  }) = _GameFilters;

  const GameFilters._();

  factory GameFilters.fromJson(Map<String, dynamic> json) =>
      _$GameFiltersFromJson(json);
}
