import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:pile_of_shame/extensions/string_extensions.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
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

@riverpod
List<Game> applyGameSearch(ApplyGameSearchRef ref, List<Game> games) {
  final searchTerm = ref.watch(gameSearchProvider);

  if (searchTerm.isEmpty) {
    return games;
  }

  final term = searchTerm.prepareForCaseInsensitiveSearch();

  final l10n = ref.watch(l10nProvider);

  final fuzzySearchResultNames = fuzzy.extractAll<Game>(
    query: term,
    choices: games,
    getter: (game) => game.name.prepareForCaseInsensitiveSearch(),
    cutoff: minFuzzySearchScore,
  );

  final fuzzySearchResultPlatformAbbreviations = fuzzy.extractAll<Game>(
    query: term,
    choices: games,
    getter: (game) => game.platform
        .localizedAbbreviation(l10n)
        .prepareForCaseInsensitiveSearch(),
    cutoff: minFuzzySearchScore,
  );

  final fuzzySearchResultPlatforms = fuzzy.extractAll(
    query: term,
    choices: games,
    getter: (game) =>
        game.platform.localizedName(l10n).prepareForCaseInsensitiveSearch(),
    cutoff: minFuzzySearchScore,
  );

  final exactSearch = games.where(
    (element) => element.name
        .prepareForCaseInsensitiveSearch()
        .contains(searchTerm.prepareForCaseInsensitiveSearch()),
  );

  final Set<Game> resultingGames = {};
  resultingGames.addAll(fuzzySearchResultNames.map((e) => e.choice));
  resultingGames.addAll(fuzzySearchResultPlatforms.map((e) => e.choice));
  resultingGames
      .addAll(fuzzySearchResultPlatformAbbreviations.map((e) => e.choice));
  resultingGames.addAll(exactSearch);

  return resultingGames.toList();
}
