import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/models/game_platforms.dart';
import 'package:pile_of_shame/models/hardware.dart';
import 'package:pile_of_shame/models/price_variant.dart';
import 'package:uuid/uuid.dart';

part 'editable_hardware.freezed.dart';

@freezed
abstract class EditableHardware with _$EditableHardware {
  const factory EditableHardware({
    String? uuid,
    String? name,
    double? price,
    String? notes,
    DateTime? createdAt,
    @Default(PriceVariant.bought) PriceVariant priceVariant,
    GamePlatform? platform,
  }) = _EditableHardware;
  const EditableHardware._();

  factory EditableHardware.fromHardware(
    VideoGameHardware hardware,
  ) {
    return EditableHardware(
      uuid: hardware.id,
      name: hardware.name,
      price: hardware.price,
      notes: hardware.notes,
      priceVariant: hardware.priceVariant,
      createdAt: hardware.createdAt,
      platform: hardware.platform,
    );
  }

  bool isValid() {
    return name != null && platform != null;
  }

  VideoGameHardware toHardware() {
    assert(isValid());

    return VideoGameHardware(
      id: uuid ?? const Uuid().v4(),
      name: name!.trim(),
      price: priceVariant != PriceVariant.bought ? 0.0 : price ?? 0.0,
      lastModified: DateTime.now(),
      createdAt: createdAt ?? DateTime.now(),
      notes: notes,
      priceVariant: priceVariant,
      platform: platform!,
    );
  }
}
