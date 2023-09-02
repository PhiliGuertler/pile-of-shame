import 'package:pile_of_shame/features/games/add_game/models/editable_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_game_provider.g.dart';

@riverpod
class AddGame extends _$AddGame {
  @override
  EditableGame build([EditableGame? initialValue]) {
    return initialValue ?? const EditableGame();
  }

  void updateGame(EditableGame update) {
    state = update;
  }
}

@riverpod
class AddDLC extends _$AddDLC {
  @override
  EditableDLC build([EditableDLC? initialValue]) {
    return initialValue ?? const EditableDLC();
  }

  void updateDLC(EditableDLC update) {
    state = update;
  }
}