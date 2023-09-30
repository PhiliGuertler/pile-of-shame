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
  String countryAssetPath() {
    switch (languageCode) {
      case 'en':
        return ImageAssets.languageEnglish.value;
      case 'de':
        return ImageAssets.languageGerman.value;
    }
    throw Exception("Language '$languageCode' is not supported");
  }
}
