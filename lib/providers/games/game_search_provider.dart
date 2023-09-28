import 'package:pile_of_shame/extensions/string_extensions.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
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

  final l10n = ref.watch(l10nProvider);

  final terms = searchTerm.prepareForCaseInsensitiveSearch().split(" ");

  final List<Game> result = List.from(games);
  return result.where((game) {
    return terms.every((term) {
      final bool matchesName =
          game.name.prepareForCaseInsensitiveSearch().contains(term);
      final bool matchesPlatformAbbreviation = game.platform.abbreviation
          .prepareForCaseInsensitiveSearch()
          .contains(term);

      final bool matchesPlatform = game.platform
          .localizedName(l10n)
          .prepareForCaseInsensitiveSearch()
          .contains(term);
      return matchesName || matchesPlatformAbbreviation || matchesPlatform;
    });
  }).toList();
}
