# pile_of_shame

A simple offline list for games you want to play, are playing, or played in the past.
Written in Flutter.

## Setup
Make sure to generate some files before hitting run.
For conveninence, the script `scripts/init_project.py` will perform these actions in the order listed here.
1. Fetch the dependencies of the project by running `flutter pub get`
2. Generate localizations using `flutter gen-l10n`

## Localization (l10n)
Localization uses flutter's l10n generator.
To add or update the localization of the application, edit the .arb-File of your desired language in `lib/l10n`.
New keys have to be added to all supported languages.

Once the text has been updated, generate the localization using
```bash
flutter gen-l10n
```