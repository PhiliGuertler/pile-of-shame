# Pile of Shame

## Introduction
This project is intended as a hands-on learning project for flutter.
It will result in an application that simply displays information about games the user has registered and played, as well as information about games the user intends to play.

## Implemented features
- Displaying a list of games on the main page is working fine.
- Persisting a list of games in a local file is working.
- Adding a new game to the list of existing games is working.
- Scraping data for single games using RAWG.io is working.

## TODOs
- Scraped data from RAWG.io should be cached and persisted in the Game objects themselves. This way, they do not have to request these informations everytime and just get extended automatically if the info is available.
- Editing Game-Info (and subsequent persisting) has to be implemented
- Filtering games by platform, series, age-restriction has to be implemented
- Sorting games by name, platform, price, age-restriction, release-date, favourite has to be implemented
- Deleting games has to be implemented.
- Saving platforms entered by the user in a json file and retrieving them from there has to be implemented. The list/file should be initialized with a bunch of known platforms (see game_addition.dart)

## Known issues
- Sometimes the app crashes at special keyboard-inputs like the arrow-keys or backspace when adding a game (sporadically)
- Adding the first game might not work correctly, this has to be thoroughly investigated.
