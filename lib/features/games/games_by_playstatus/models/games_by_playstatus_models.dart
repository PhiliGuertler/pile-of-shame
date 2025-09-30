import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_sorting.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'games_by_playstatus_models.freezed.dart';
part 'games_by_playstatus_models.g.dart';

@freezed
abstract class GamesByPlayStatusSorters with _$GamesByPlayStatusSorters {
  const factory GamesByPlayStatusSorters({
    @Default({
      PlayStatus.cancelled: GameSorting(),
      PlayStatus.completed: GameSorting(),
      PlayStatus.completed100Percent: GameSorting(),
      PlayStatus.endlessGame: GameSorting(),
      PlayStatus.onPileOfShame: GameSorting(),
      PlayStatus.onWishList: GameSorting(),
      PlayStatus.playing: GameSorting(),
      PlayStatus.replaying: GameSorting(),
    })
    Map<PlayStatus, GameSorting> sorters,
  }) = _GamesByPlayStatusSorters;

  const GamesByPlayStatusSorters._();

  factory GamesByPlayStatusSorters.fromJson(Map<String, dynamic> json) =>
      _$GamesByPlayStatusSortersFromJson(json);
}
