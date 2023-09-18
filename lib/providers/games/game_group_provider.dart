import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
import 'package:pile_of_shame/providers/mixins/persistable_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_group_provider.g.dart';

@Riverpod(keepAlive: true)
class GroupGames extends _$GroupGames with Persistable {
  static const String storageKey = "sorter";

  @override
  FutureOr<GameGrouping> build() async {
    final storedJSON = await loadFromStorage(storageKey);
    if (storedJSON != null) {
      return GameGrouping.fromJson(storedJSON);
    }
    return const GameGrouping();
  }

  Future<void> setGrouping(GameGrouping grouping) async {
    state = await AsyncValue.guard(() async {
      await persistJSON(storageKey, grouping.toJson());
      return grouping;
    });
  }
}

@riverpod
FutureOr<Map<String, List<Game>>> applyGameGroup(
    ApplyGameGroupRef ref, List<Game> games) async {
  final activeGroup = await ref.watch(groupGamesProvider.future);

  final l10n = ref.watch(l10nProvider);

  if (activeGroup.groupStrategy.grouper != null) {
    final grouper = activeGroup.groupStrategy.grouper!;
    final allValues = grouper.values();
    Map<String, List<Game>> result = Map.fromEntries(allValues
        .map((e) => MapEntry(grouper.groupToLocaleString(l10n, e), [])));
    for (var game in games) {
      for (var group in allValues) {
        if (grouper.matchesGroup(group, game)) {
          result[grouper.groupToLocaleString(l10n, group)]!.add(game);
        }
      }
    }
    result.removeWhere((key, value) => value.isEmpty);
    return result;
  } else {
    return {"": games};
  }
}
