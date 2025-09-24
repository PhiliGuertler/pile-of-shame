import 'package:misc_utils/misc_utils.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_grouping.dart';
import 'package:pile_of_shame/providers/l10n_provider.dart';
import 'package:pile_of_shame/utils/grouper_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_group_provider.g.dart';

@Riverpod(keepAlive: true)
class GroupGames extends _$GroupGames with Persistable {
  static const String storageKey = "grouper";

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
  Ref ref,
  List<Game> games,
) async {
  final activeGroup = await ref.watch(groupGamesProvider.future);

  final l10n = ref.watch(l10nProvider);

  final GameGrouperUtils grouperUtils = GameGrouperUtils(l10n: l10n);
  return grouperUtils.groupGames(games, activeGroup.groupStrategy);
}
