// ignore_for_file: use_setters_to_change_properties

import 'package:pile_of_shame/features/games/add_or_edit_game/models/editable_game.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_game_provider.g.dart';

@riverpod
class AddGame extends _$AddGame {
  @override
  EditableGame build([EditableGame? initialValue, PlayStatus? initialStatus]) {
    if (initialValue == null && initialStatus != null) {
      return EditableGame(status: initialStatus);
    }
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
