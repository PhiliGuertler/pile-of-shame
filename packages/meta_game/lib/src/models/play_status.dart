import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum PlayStatus {
  none(0, '???'),
  currentlyPlaying(1, 'Aktiv'),
  onPileOfShame(2, 'Auf dem Pile of Shame'),
  completed100Percent(3, 'Durchgespielt zu 100%'),
  completed(4, 'Durchgespielt'),
  cancelled(5, 'Abgebrochen'),
  onWishList(6, 'Am raushängen'),
  unfinishable(7, 'Endlosspiel');

  final int code;
  final String description;
  const PlayStatus(this.code, this.description);
}
