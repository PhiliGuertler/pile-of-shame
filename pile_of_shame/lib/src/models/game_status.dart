enum GameState {
  none,
  currentlyPlaying,
  onPileOfShame,
  completed100Percent,
  completed,
  cancelled,
  onWishList,
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
