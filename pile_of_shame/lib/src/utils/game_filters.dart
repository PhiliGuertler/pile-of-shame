import 'dart:core';

import 'package:pile_of_shame/src/models/age_restrictions.dart';
import 'package:pile_of_shame/src/models/game_status.dart';

import '../models/game.dart';
import '../models/game_platform.dart';

enum SortStrategy {
  none,
  byDateOfAddition,
  byAlphabet,
  byAgeRestriction,
  byPrice,
  byPlatform,
  byFavourite,
  byStatus,
}

class GameFilters {
  GameFilters({
    this.sortStrategy = SortStrategy.byDateOfAddition,
    this.isDescending = true,
    this.platformFilter,
    this.ageRestrictionFilter,
    this.isFavouriteFilter,
    this.gameStateFilter,
  });

  GameFilters.from(GameFilters filters)
      : sortStrategy = filters.sortStrategy,
        isDescending = filters.isDescending,
        platformFilter = filters.platformFilter,
        ageRestrictionFilter = filters.ageRestrictionFilter,
        isFavouriteFilter = filters.isFavouriteFilter,
        gameStateFilter = filters.gameStateFilter;

  // Sorting
  SortStrategy sortStrategy;
  bool isDescending;

  // Filtering
  GamePlatform? platformFilter;
  AgeRestriction? ageRestrictionFilter;
  bool? isFavouriteFilter;
  GameState? gameStateFilter;

  // ######################################################################## //
  // ### Sorting functions ################################################## //
  // ######################################################################## //

  List<Game> _sortByDateOfAddition(List<Game> gamesList) {
    // TODO: This probably needs a more sophisticated implementation.
    // For now, we just change the order of elements depending on isAscending
    if (!isDescending) {
      return gamesList;
    } else {
      return gamesList.reversed.toList();
    }
  }

  List<Game> _sortByAlphabet(List<Game> gamesList) {
    gamesList.sort(
      (a, b) {
        if (!isDescending) {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        } else {
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        }
      },
    );
    return gamesList;
  }

  List<Game> _sortByAgeRestriction(List<Game> gamesList) {
    gamesList.sort(
      (a, b) {
        if (!isDescending) {
          return AgeRestrictions.compareAgeRestrictions(
              a.ageRestriction ?? AgeRestriction.unknown,
              b.ageRestriction ?? AgeRestriction.unknown);
        } else {
          return AgeRestrictions.compareAgeRestrictions(
              b.ageRestriction ?? AgeRestriction.unknown,
              a.ageRestriction ?? AgeRestriction.unknown);
        }
      },
    );
    return gamesList;
  }

  List<Game> _sortByPrice(List<Game> gamesList) {
    gamesList.sort(
      (a, b) {
        if (!isDescending) {
          return (a.price ?? 0).compareTo(b.price ?? 0);
        } else {
          return (b.price ?? 0).compareTo(a.price ?? 0);
        }
      },
    );
    return gamesList;
  }

  List<Game> _sortByPlatform(List<Game> gamesList) {
    List<GamePlatform> platforms = GamePlatforms.toList();
    if (!isDescending) {
      platforms = platforms.reversed.toList();
    }
    gamesList.sort(
      (a, b) {
        // find the lowest index of the game's platforms
        List<int> aIndices = a.platforms.map((gamePlatform) {
          return platforms
              .indexWhere((platform) => platform.name == gamePlatform);
        }).toList();
        int aLowestIndex = aIndices
            .reduce((value, element) => value > element ? element : value);
        List<int> bIndices = b.platforms.map((gamePlatform) {
          return platforms
              .indexWhere((platform) => platform.name == gamePlatform);
        }).toList();
        int bLowestIndex = bIndices
            .reduce((value, element) => value > element ? element : value);

        return aLowestIndex.compareTo(bLowestIndex);
      },
    );
    return gamesList;
  }

  List<Game> _sortByFavourite(List<Game> gamesList) {
    gamesList.sort(
      (a, b) {
        int aFavourite = a.isFavourite ? 1 : 0;
        int bFavourite = b.isFavourite ? 1 : 0;
        if (!isDescending) {
          return aFavourite.compareTo(bFavourite);
        } else {
          return bFavourite.compareTo(aFavourite);
        }
      },
    );
    return gamesList;
  }

  List<Game> _sortByStatus(List<Game> gamesList) {
    gamesList.sort(
      (a, b) {
        if (!isDescending) {
          return a.gameState.index.compareTo(b.gameState.index);
        } else {
          return b.gameState.index.compareTo(a.gameState.index);
        }
      },
    );
    return gamesList;
  }

  // ######################################################################## //
  // ### Filtering functions ################################################ //
  // ######################################################################## //

  List<Game> _filterByPlatform(List<Game> gamesList, GamePlatform platform) {
    return gamesList.where((game) {
      return game.platforms
          .where((element) => element == platform.name)
          .isNotEmpty;
    }).toList();
  }

  List<Game> _filterByStatus(List<Game> gamesList, GameState state) {
    return gamesList.where((game) {
      return game.gameState == state;
    }).toList();
  }

  List<Game> _filterByAgeRestriction(
      List<Game> gamesList, AgeRestriction ageRestriction) {
    return gamesList.where((game) {
      return game.ageRestriction == ageRestriction;
    }).toList();
  }

  List<Game> _filterByFavourite(List<Game> gamesList, bool isFavourite) {
    return gamesList.where((game) {
      return game.isFavourite == isFavourite;
    }).toList();
  }

  List<Game> _applySortStrategy(List<Game> gamesList) {
    switch (sortStrategy) {
      case SortStrategy.byDateOfAddition:
        return _sortByDateOfAddition(gamesList);
      case SortStrategy.byAlphabet:
        return _sortByAlphabet(gamesList);
      case SortStrategy.byAgeRestriction:
        return _sortByAgeRestriction(_sortByAlphabet(gamesList));
      case SortStrategy.byPrice:
        return _sortByPrice(_sortByAlphabet(gamesList));
      case SortStrategy.byPlatform:
        return _sortByPlatform(_sortByAlphabet(gamesList));
      case SortStrategy.byFavourite:
        return _sortByFavourite(_sortByAlphabet(gamesList));
      case SortStrategy.byStatus:
        return _sortByStatus(_sortByAlphabet(gamesList));
      default:
        return gamesList;
    }
  }

  List<Game> filter(List<Game> gamesList) {
    List<Game> sortedGames = _applySortStrategy(gamesList);

    if (platformFilter != null) {
      sortedGames = _filterByPlatform(sortedGames, platformFilter!);
    }
    if (ageRestrictionFilter != null) {
      sortedGames = _filterByAgeRestriction(sortedGames, ageRestrictionFilter!);
    }
    if (isFavouriteFilter != null) {
      sortedGames = _filterByFavourite(sortedGames, isFavouriteFilter!);
    }
    if (gameStateFilter != null) {
      sortedGames = _filterByStatus(sortedGames, gameStateFilter!);
    }

    return sortedGames;
  }
}
