import 'package:pile_of_shame/extensions/string_extensions.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_search_provider.g.dart';

@Riverpod(keepAlive: true)
class GameSearch extends _$GameSearch {
  @override
  String build() {
    return '';
  }

  void setSearch(String search) {
    state = search;
  }
}

@riverpod
List<Game> applyGameSearch(ApplyGameSearchRef ref, List<Game> games) {
  final searchTerm = ref.watch(gameSearchProvider);

  final terms = searchTerm.prepareForCaseInsensitiveSearch().split(" ");

  List<Game> result = List.from(games);
  result = result.where((game) {
    return terms.every((term) {
      bool matchesName =
          game.name.prepareForCaseInsensitiveSearch().contains(term);
      bool matchesPlatformAbbreviation = game.platform.abbreviation
          .prepareForCaseInsensitiveSearch()
          .contains(term);
      bool matchesPlatform =
          game.platform.name.prepareForCaseInsensitiveSearch().contains(term);
      return matchesName || matchesPlatformAbbreviation || matchesPlatform;
    });
  }).toList();

  return result;
}
