import 'dart:ui';

import 'package:pile_of_shame/models/assets.dart';

extension LanguageName on Locale {
  String fullName() {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
    }
    throw Exception("LanguageCode '$languageCode' is not supported");
  }
}

extension LanguageIcon on Locale {
  ImageAssets countryAsset() {
    switch (languageCode) {
      case 'en':
        return ImageAssets.languageEnglish;
      case 'de':
        return ImageAssets.languageGerman;
    }
    throw Exception("Language '$languageCode' is not supported");
  }
}
