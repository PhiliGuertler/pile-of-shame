import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';
import 'package:pile_of_shame/models/game.dart';

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
    final difference = a.fullPrice() - b.fullPrice();
    if (difference.abs() < 0.01) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = a.fullPrice().compareTo(b.fullPrice()) * factor;
    return result;
  }
}

class GameSorterByBasePrice extends GameSorter {
  const GameSorterByBasePrice();

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

class GameSorterByTotalDLCPrice extends GameSorter {
  const GameSorterByTotalDLCPrice();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final aDLCPriceSum = a.dlcs
        .fold(0.0, (previousValue, element) => previousValue + element.price);
    final bDLCPriceSum = b.dlcs
        .fold(0.0, (previousValue, element) => previousValue + element.price);
    final difference = aDLCPriceSum - bDLCPriceSum;
    if (difference.abs() < 0.01) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    final factor = isAscending ? 1 : -1;
    final result = aDLCPriceSum.compareTo(bDLCPriceSum) * factor;
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

class GameSorterByCreatedAt extends GameSorter {
  const GameSorterByCreatedAt();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (a.createdAt.compareTo(b.createdAt)) * factor;
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

class GameSorterByHasNotes extends GameSorter {
  const GameSorterByHasNotes();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = (((a.notes != null && a.notes!.isNotEmpty) ? 0 : 1) -
            ((b.notes != null && b.notes!.isNotEmpty) ? 0 : 1)) *
        factor;
    if (result == 0) {
      return const GameSorterByName().compareGames(a, b, isAscending);
    }
    return result;
  }
}

class GameSorterByDLCCount extends GameSorter {
  const GameSorterByDLCCount();

  @override
  int compareGames(Game a, Game b, bool isAscending) {
    final factor = isAscending ? 1 : -1;
    final result = a.dlcs.length.compareTo(b.dlcs.length) * factor;
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
  byBasePrice(sorter: GameSorterByBasePrice()),
  byDLCPrice(sorter: GameSorterByTotalDLCPrice()),
  byAgeRating(sorter: GameSorterByAgeRating()),
  byPlatform(sorter: GameSorterByPlatform()),
  byLastModified(sorter: GameSorterByLastModified()),
  byCreatedAt(sorter: GameSorterByCreatedAt()),
  byFavorites(sorter: GameSorterByFavorites()),
  byHasNotes(sorter: GameSorterByHasNotes()),
  byDLCCount(sorter: GameSorterByDLCCount()),
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case SortStrategy.byName:
        return AppLocalizations.of(context)!.byName;
      case SortStrategy.byPlayStatus:
        return AppLocalizations.of(context)!.byStatus;
      case SortStrategy.byPrice:
        return AppLocalizations.of(context)!.byPrice;
      case SortStrategy.byBasePrice:
        return AppLocalizations.of(context)!.byBasePrice;
      case SortStrategy.byDLCPrice:
        return AppLocalizations.of(context)!.byDLCPrice;
      case SortStrategy.byAgeRating:
        return AppLocalizations.of(context)!.byAgeRating;
      case SortStrategy.byPlatform:
        return AppLocalizations.of(context)!.byPlatform;
      case SortStrategy.byLastModified:
        return AppLocalizations.of(context)!.byLastModified;
      case SortStrategy.byCreatedAt:
        return AppLocalizations.of(context)!.byCreatedAt;
      case SortStrategy.byFavorites:
        return AppLocalizations.of(context)!.byFavorites;
      case SortStrategy.byHasNotes:
        return AppLocalizations.of(context)!.byHasNotes;
      case SortStrategy.byDLCCount:
        return AppLocalizations.of(context)!.byDLCCount;
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
  const GameSorting._();

  factory GameSorting.fromJson(Map<String, dynamic> json) =>
      _$GameSortingFromJson(json);
}
