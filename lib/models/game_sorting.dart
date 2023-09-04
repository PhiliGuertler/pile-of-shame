import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

import 'game.dart';

part 'game_sorting.freezed.dart';

abstract class GameSorter {
  const GameSorter();

  int compareGames(Game a, Game b, bool isAscending);
}

class GameSorterByName extends GameSorter {
  const GameSorterByName();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase()) * factor;
  }
}

class GameSorterByPlayStatus extends GameSorter {
  const GameSorterByPlayStatus();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return (a.status.index - b.status.index) * factor;
  }
}

class GameSorterByPrice extends GameSorter {
  const GameSorterByPrice();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return a.price.compareTo(b.price) * factor;
  }
}

class GameSorterByAgeRating extends GameSorter {
  const GameSorterByAgeRating();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return (a.usk.index - b.usk.index) * factor;
  }
}

class GameSorterByPlatform extends GameSorter {
  const GameSorterByPlatform();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return (a.platform.index - b.platform.index) * factor;
  }
}

class GameSorterByLastModified extends GameSorter {
  const GameSorterByLastModified();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    return (a.lastModified.compareTo(b.lastModified)) * factor;
  }
}

enum SortStrategy {
  byName(sorter: GameSorterByName()),
  byPlayStatus(sorter: GameSorterByPlayStatus()),
  byPrice(sorter: GameSorterByPrice()),
  byAgeRating(sorter: GameSorterByAgeRating()),
  byPlatform(sorter: GameSorterByPlatform()),
  byLastModified(sorter: GameSorterByLastModified()),
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case SortStrategy.byName:
        return AppLocalizations.of(context)!.byName;
      case SortStrategy.byPlayStatus:
        return AppLocalizations.of(context)!.byStatus;
      case SortStrategy.byPrice:
        return AppLocalizations.of(context)!.byPrice;
      case SortStrategy.byAgeRating:
        return AppLocalizations.of(context)!.byAgeRating;
      case SortStrategy.byPlatform:
        return AppLocalizations.of(context)!.byPlatform;
      case SortStrategy.byLastModified:
        return AppLocalizations.of(context)!.byLastModified;
    }
  }

  final GameSorter sorter;

  const SortStrategy({
    required this.sorter,
  });
}

@freezed
class GameSorting with _$GameSorting {
  const factory GameSorting({
    @Default(true) bool isAscending,
    @Default(SortStrategy.byName) SortStrategy sortStrategy,
  }) = _GameSorting;
}
