import 'package:json_annotation/json_annotation.dart';

enum GameState {
  @JsonValue(0)
  none,
  @JsonValue(1)
  currentlyPlaying,
  @JsonValue(2)
  onPileOfShame,
  @JsonValue(3)
  completed100Percent,
  @JsonValue(4)
  completed,
  @JsonValue(5)
  cancelled,
  @JsonValue(6)
  onWishList,
  @JsonValue(7)
  unfinishable,
}

class GameStates {
  GameStates._();

  static String gameStateToString(GameState state) {
    switch (state) {
      case GameState.onPileOfShame:
        return 'Auf dem Pile of Shame';
      case GameState.onWishList:
        return 'Am raushängen';
      case GameState.completed:
        return 'Durchgespielt';
      case GameState.completed100Percent:
        return 'Durchgespielt zu 100 %';
      case GameState.currentlyPlaying:
        return 'Aktiv';
      case GameState.cancelled:
        return 'Abgebrochen';
      case GameState.unfinishable:
        return 'Endlosspiel';
      default:
        return '???';
    }
  }
}
