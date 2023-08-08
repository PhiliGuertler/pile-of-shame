enum PlayStatus {
  completed100Percent(isCompleted: true),
  completed(isCompleted: true),
  replaying(isCompleted: true),
  playing(isCompleted: false),
  cancelled(isCompleted: false),
  onPileOfShame(isCompleted: false),
  onWishList(isCompleted: false),
  ;

  final bool isCompleted;

  const PlayStatus({
    required this.isCompleted,
  });
}
