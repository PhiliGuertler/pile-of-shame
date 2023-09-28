import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pile_of_shame/l10n/generated/app_localizations.dart';

part 'custom_game_display_settings.freezed.dart';
part 'custom_game_display_settings.g.dart';

enum GameDisplayLeadingTrailing {
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
      case GameDisplayLeadingTrailing.ageRatingIcon:
        return AppLocalizations.of(context)!.ageRating;
      case GameDisplayLeadingTrailing.lastModifiedOnly:
        return AppLocalizations.of(context)!.lastModified;
      case GameDisplayLeadingTrailing.none:
        return AppLocalizations.of(context)!.none;
      case GameDisplayLeadingTrailing.platformIcon:
        return AppLocalizations.of(context)!.platform;
      case GameDisplayLeadingTrailing.playStatusIcon:
        return AppLocalizations.of(context)!.status;
      case GameDisplayLeadingTrailing.priceOnly:
        return AppLocalizations.of(context)!.price;
      case GameDisplayLeadingTrailing.priceAndLastModified:
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
  const factory CustomGameDisplaySettings({
    @Default(GameDisplayLeadingTrailing.playStatusIcon)
    GameDisplayLeadingTrailing leading,
    @Default(GameDisplayLeadingTrailing.priceAndLastModified)
    GameDisplayLeadingTrailing trailing,
    @Default(GameDisplaySecondary.platformText) GameDisplaySecondary secondary,
    @Default(true) bool hasFancyAnimations,
    @Default(false) bool hasRepeatingAnimations,
  }) = _CustomGameDisplaySettings;
  const CustomGameDisplaySettings._();

  factory CustomGameDisplaySettings.fromJson(Map<String, dynamic> json) =>
      _$CustomGameDisplaySettingsFromJson(json);
}
