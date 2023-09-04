import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_search_provider.g.dart';

@riverpod
class GameSearch extends _$GameSearch {
  @override
  String build() {
    return '';
  }

  void setSearch(String search) {
    state = search;
  }
}
