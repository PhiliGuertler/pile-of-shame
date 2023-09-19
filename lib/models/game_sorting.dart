import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

import 'game.dart';

part 'game_sorting.freezed.dart';
part 'game_sorting.g.dart';

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
    if (a.status == b.status) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = (a.status.index - b.status.index) * factor;
    return result;
  }
}

class GameSorterByPrice extends GameSorter {
  const GameSorterByPrice();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final difference = a.price - b.price;
    if (difference.abs() < 0.01) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = a.price.compareTo(b.price) * factor;
    return result;
  }
}

class GameSorterByAgeRating extends GameSorter {
  const GameSorterByAgeRating();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    if (a.usk == b.usk) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = (a.usk.index - b.usk.index) * factor;
    return result;
  }
}

class GameSorterByPlatform extends GameSorter {
  const GameSorterByPlatform();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    if (a.platform == b.platform) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = (a.platform.index - b.platform.index) * factor;
    return result;
  }
}

class GameSorterByLastModified extends GameSorter {
  const GameSorterByLastModified();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (a.lastModified.compareTo(b.lastModified)) * factor;
    if (result == 0) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

class GameSorterByFavorites extends GameSorter {
  const GameSorterByFavorites();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = ((a.isFavorite ? 0 : 1) - (b.isFavorite ? 0 : 1)) * factor;
    if (result == 0) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

enum SortStrategy {
  byName(sorter: GameSorterByName()),
  byPlayStatus(sorter: GameSorterByPlayStatus()),
  byPrice(sorter: GameSorterByPrice()),
  byAgeRating(sorter: GameSorterByAgeRating()),
  byPlatform(sorter: GameSorterByPlatform()),
  byLastModified(sorter: GameSorterByLastModified()),
  byFavorites(sorter: GameSorterByFavorites()),
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
      case SortStrategy.byFavorites:
        return AppLocalizations.of(context)!.byFavorites;
    }
  }

  final GameSorter sorter;

  const SortStrategy({
    required this.sorter,
  });
}

@freezed
class GameSorting with _$GameSorting {
  const GameSorting._();

  const factory GameSorting({
    @Default(true) bool isAscending,
    @Default(SortStrategy.byName) SortStrategy sortStrategy,
  }) = _GameSorting;

  factory GameSorting.fromJson(Map<String, dynamic> json) =>
      _$GameSortingFromJson(json);
}
