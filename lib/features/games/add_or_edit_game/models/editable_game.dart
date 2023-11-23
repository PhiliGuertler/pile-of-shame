import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/age_restriction.dart';
import 'package:pile_of_shame/models/game.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/play_status.dart';
import 'package:uuid/uuid.dart';

part 'editable_game.freezed.dart';

@freezed
class EditableDLC with _$EditableDLC {
  const factory EditableDLC({
    DateTime? createdAt,
    String? uuid,
    String? name,
    @Default(PlayStatus.onPileOfShame) PlayStatus status,
    double? price,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(PriceVariant.bought) PriceVariant priceVariant,
  }) = _EditableDLC;
  const EditableDLC._();

  factory EditableDLC.fromDLC(DLC dlc) {
    return EditableDLC(
      createdAt: dlc.createdAt,
      uuid: dlc.id,
      name: dlc.name,
      price: dlc.price,
      status: dlc.status,
      notes: dlc.notes,
      isFavorite: dlc.isFavorite,
      priceVariant: dlc.priceVariant,
    );
  }

  bool isValid() {
    return name != null;
  }

  DLC toDLC() {
    assert(isValid());

    return DLC(
      id: uuid ?? const Uuid().v4(),
      createdAt: createdAt ?? DateTime.now(),
      lastModified: DateTime.now(),
      name: name!.trim(),
      status: status,
      price: priceVariant == PriceVariant.gifted ? 0.0 : price ?? 0.0,
      notes: notes != null ? notes!.trim() : notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}

@freezed
class EditableGame with _$EditableGame {
  const factory EditableGame({
    DateTime? createdAt,
    String? uuid,
    String? name,
    GamePlatform? platform,
    @Default(PlayStatus.onPileOfShame) PlayStatus status,
    double? price,
    @Default(USK.usk0) USK usk,
    @Default([]) List<DLC> dlcs,
    String? notes,
    @Default(false) bool isFavorite,
    @Default(PriceVariant.bought) PriceVariant priceVariant,
  }) = _EditableGame;
  const EditableGame._();

  factory EditableGame.fromGame(Game game) {
    return EditableGame(
      createdAt: game.createdAt,
      uuid: game.id,
      name: game.name,
      platform: game.platform,
      price: game.price,
      status: game.status,
      usk: game.usk,
      dlcs: game.dlcs,
      notes: game.notes,
      isFavorite: game.isFavorite,
      priceVariant: game.priceVariant,
    );
  }

  bool isValid() {
    return name != null && platform != null;
  }

  Game toGame() {
    assert(
      isValid() &&
          dlcs.every((element) => EditableDLC.fromDLC(element).isValid()),
    );

    return Game(
      id: uuid ?? const Uuid().v4(),
      name: name!.trim(),
      platform: platform!,
      status: status,
      lastModified: DateTime.now(),
      createdAt: createdAt ?? DateTime.now(),
      price: priceVariant == PriceVariant.gifted ? 0.0 : price ?? 0.0,
      usk: usk,
      dlcs: dlcs,
      notes: notes != null ? notes!.trim() : notes,
      isFavorite: isFavorite,
      priceVariant: priceVariant,
    );
  }
}
