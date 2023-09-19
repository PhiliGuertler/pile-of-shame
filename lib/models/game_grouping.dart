import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';

part 'game_grouping.freezed.dart';
part 'game_grouping.g.dart';

abstract class GameGrouper<T> {
  const GameGrouper();

  bool matchesGroup(T group, Game game);

  List<T> values();

  String groupToLocaleString(AppLocalizations l10n, T group);
}

class GameGrouperByPlatform extends GameGrouper<GamePlatform> {
  const GameGrouperByPlatform();

  @override
  bool matchesGroup(GamePlatform group, Game game) {
    return game.platform == group;
  }

  @override
  List<GamePlatform> values() {
    return GamePlatform.values;
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, GamePlatform group) {
    return group.localizedName(l10n);
  }
}

class GameGrouperByPlatformFamily extends GameGrouper<GamePlatformFamily> {
  const GameGrouperByPlatformFamily();

  @override
  bool matchesGroup(GamePlatformFamily group, Game game) {
    return game.platform.family == group;
  }

  @override
  List<GamePlatformFamily> values() {
    return GamePlatformFamily.values;
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, GamePlatformFamily group) {
    return group.toLocale(l10n);
  }
}

class GameGrouperByPlayStatus extends GameGrouper<PlayStatus> {
  const GameGrouperByPlayStatus();

  @override
  bool matchesGroup(PlayStatus group, Game game) {
    return game.status == group;
  }

  @override
  List<PlayStatus> values() {
    return PlayStatus.values;
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, PlayStatus group) {
    return group.toLocaleString(l10n);
  }
}

class GameGrouperByAgeRating extends GameGrouper<USK> {
  const GameGrouperByAgeRating();

  @override
  bool matchesGroup(USK group, Game game) {
    return game.usk == group;
  }

  @override
  List<USK> values() {
    return USK.values;
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, USK group) {
    return group.toRatedString(l10n);
  }
}

class GameGrouperByIsFavorite extends GameGrouper<bool> {
  const GameGrouperByIsFavorite();

  @override
  bool matchesGroup(bool group, Game game) {
    return game.isFavorite == group;
  }

  @override
  List<bool> values() {
    return [true, false];
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, bool group) {
    return group ? l10n.isFavorite : l10n.isNotFavorite;
  }
}

class GameGrouperByHasNotes extends GameGrouper<bool> {
  const GameGrouperByHasNotes();

  @override
  bool matchesGroup(bool group, Game game) {
    return (game.notes != null && game.notes!.isNotEmpty) == group;
  }

  @override
  List<bool> values() {
    return [true, false];
  }

  @override
  String groupToLocaleString(AppLocalizations l10n, bool group) {
    return group ? l10n.hasNotes : l10n.hasNoNotes;
  }
}

enum GroupStrategy {
  byPlatform(grouper: GameGrouperByPlatform()),
  byPlatformFamily(grouper: GameGrouperByPlatformFamily()),
  byPlayStatus(grouper: GameGrouperByPlayStatus()),
  byAgeRating(grouper: GameGrouperByAgeRating()),
  byIsFavorite(grouper: GameGrouperByIsFavorite()),
  byHasNotes(grouper: GameGrouperByHasNotes()),
  byNone(grouper: null),
  ;

  final GameGrouper? grouper;

  const GroupStrategy({required this.grouper});

  String toLocaleString(AppLocalizations l10n) {
    switch (this) {
      case GroupStrategy.byPlatform:
        return l10n.byPlatform;
      case GroupStrategy.byPlatformFamily:
        return l10n.byPlatformFamily;
      case GroupStrategy.byPlayStatus:
        return l10n.byStatus;
      case GroupStrategy.byAgeRating:
        return l10n.byAgeRating;
      case GroupStrategy.byIsFavorite:
        return l10n.byFavorites;
      case GroupStrategy.byHasNotes:
        return l10n.byHasNotes;
      case GroupStrategy.byNone:
        return l10n.byNone;
    }
  }
}

@freezed
class GameGrouping with _$GameGrouping {
  const GameGrouping._();

  const factory GameGrouping({
    @Default(GroupStrategy.byNone) GroupStrategy groupStrategy,
  }) = _GameGrouping;

  factory GameGrouping.fromJson(Map<String, dynamic> json) =>
      _$GameGroupingFromJson(json);
}
