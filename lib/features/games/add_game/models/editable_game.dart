import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:uuid/uuid.dart';

part 'editable_game.freezed.dart';

@freezed
class EditableDLC with _$EditableDLC {
  const EditableDLC._();

  const factory EditableDLC({
    String? name,
    @Default(PlayStatus.onPileOfShame) PlayStatus status,
    double? price,
  }) = _EditableDLC;

  bool isValid() {
    return name != null;
  }

  DLC toDLC() {
    assert(isValid());

    return DLC(
      id: const Uuid().v4(),
      lastModified: DateTime.now(),
      name: name!,
      status: status,
      price: price ?? 0.0,
    );
  }
}

@freezed
class EditableGame with _$EditableGame {
  const EditableGame._();

  const factory EditableGame({
    String? name,
    GamePlatform? platform,
    @Default(PlayStatus.onPileOfShame) PlayStatus status,
    double? price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<EditableDLC> dlcs,
  }) = _EditableGame;

  bool isValid() {
    return name != null && platform != null;
  }

  Game toGame() {
    assert(isValid() && dlcs.every((element) => element.isValid()));

    return Game(
      id: const Uuid().v4(),
      name: name!,
      platform: platform!,
      status: status,
      lastModified: DateTime.now(),
      price: price ?? 0.0,
      usk: usk,
      dlcs: dlcs.map((e) => e.toDLC()).toList(),
    );
  }
}
