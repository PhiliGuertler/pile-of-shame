import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

part 'custom_game_display_settings.freezed.dart';
part 'custom_game_display_settings.g.dart';

enum GameDisplayLeading {
  platformIcon,
  playStatusIcon,
  ageRatingIcon,
  none,
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case GameDisplayLeading.platformIcon:
        return AppLocalizations.of(context)!.platform;
      case GameDisplayLeading.playStatusIcon:
        return AppLocalizations.of(context)!.status;
      case GameDisplayLeading.ageRatingIcon:
        return AppLocalizations.of(context)!.ageRating;
      case GameDisplayLeading.none:
        return AppLocalizations.of(context)!.none;
    }
  }
}

enum GameDisplayTrailing {
  priceAndLastModified,
  priceOnly,
  lastModifiedOnly,
  platformIcon,
  playStatusIcon,
  ageRatingIcon,
  none,
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case GameDisplayTrailing.ageRatingIcon:
        return AppLocalizations.of(context)!.ageRating;
      case GameDisplayTrailing.lastModifiedOnly:
        return AppLocalizations.of(context)!.lastModified;
      case GameDisplayTrailing.none:
        return AppLocalizations.of(context)!.none;
      case GameDisplayTrailing.platformIcon:
        return AppLocalizations.of(context)!.platform;
      case GameDisplayTrailing.playStatusIcon:
        return AppLocalizations.of(context)!.status;
      case GameDisplayTrailing.priceOnly:
        return AppLocalizations.of(context)!.price;
      case GameDisplayTrailing.priceAndLastModified:
        return AppLocalizations.of(context)!.priceAndLastModified;
    }
  }
}

enum GameDisplaySecondary {
  statusText,
  platformText,
  price,
  ageRatingText,
  none,
  ;

  String toLocaleString(BuildContext context) {
    switch (this) {
      case GameDisplaySecondary.platformText:
        return AppLocalizations.of(context)!.platform;
      case GameDisplaySecondary.statusText:
        return AppLocalizations.of(context)!.status;
      case GameDisplaySecondary.ageRatingText:
        return AppLocalizations.of(context)!.ageRating;
      case GameDisplaySecondary.price:
        return AppLocalizations.of(context)!.price;
      case GameDisplaySecondary.none:
        return AppLocalizations.of(context)!.none;
    }
  }
}

@freezed
class CustomGameDisplaySettings with _$CustomGameDisplaySettings {
  const CustomGameDisplaySettings._();

  const factory CustomGameDisplaySettings({
    @Default(GameDisplayLeading.platformIcon) GameDisplayLeading leading,
    @Default(GameDisplayTrailing.priceAndLastModified)
    GameDisplayTrailing trailing,
    @Default(GameDisplaySecondary.statusText) GameDisplaySecondary secondary,
    @Default(true) bool hasFancyAnimations,
    @Default(true) bool hasRepeatingAnimations,
  }) = _CustomGameDisplaySettings;

  factory CustomGameDisplaySettings.fromJson(Map<String, dynamic> json) =>
      _$CustomGameDisplaySettingsFromJson(json);
}
