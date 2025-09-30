import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_search_provider.g.dart';

@Riverpod(keepAlive: true)
class GameSearch extends _$GameSearch {
  @override
  String build() {
    return '';
  }

  // ignore: use_setters_to_change_properties
  void setSearch(String search) {
    state = search;
  }
}

@Riverpod(keepAlive: true)
List<Game> applyGameSearch(Ref ref, List<Game> games) {
  final searchTerm = ref.watch(gameSearchProvider);

  if (searchTerm.isEmpty) {
    return games;
  }

  final term = searchTerm.prepareForCaseInsensitiveSearch();

  final fuzzySearchResultNames = fuzzy.extractAll<Game>(
    query: term,
    choices: games,
    getter: (game) => game.name.prepareForCaseInsensitiveSearch(),
    cutoff: minFuzzySearchScore,
  );

  final exactSearch = games.where(
    (element) => element.name
        .prepareForCaseInsensitiveSearch()
        .contains(searchTerm.prepareForCaseInsensitiveSearch()),
  );

  final Set<Game> resultingGames = {};
  resultingGames.addAll(fuzzySearchResultNames.map((e) => e.choice));
  resultingGames.addAll(exactSearch);

  return resultingGames.toList();
}
