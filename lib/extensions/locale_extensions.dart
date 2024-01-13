import 'dart:ui';

extension LanguageName on Locale {
  String fullName() {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español (AI Generated)';
      case 'pt':
        return 'Português (AI Generated)';
      case 'ja':
        return '日本語 (AI Generated)';
      case 'ko':
        return '한국어 (AI Generated)';
      case 'ru':
        return 'Русский (AI Generated)';
      case 'fr':
        return 'Français (AI Generated)';
    }
    throw Exception("LanguageCode '$languageCode' is not supported");
  }
}

extension LanguageIcon on Locale {
  String countryAssetEmoji() {
    switch (languageCode) {
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      case 'pt':
        return '🇵🇹';
      case 'ru':
        return '🇷🇺';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      case 'en':
        return '🇬🇧';
    }
    throw Exception("Language '$languageCode' is not supported");
  }
}
