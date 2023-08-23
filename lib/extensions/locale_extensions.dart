import 'dart:ui';

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
        return 'assets/languages/english.png';
      case 'de':
        return 'assets/languages/german.png';
    }
    throw Exception("Language '$languageCode' is not supported");
  }
}
