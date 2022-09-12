# Pile of Shame

## Introduction
This project is intended as a hands-on learning project for flutter.
It will result in an application that simply displays information about games the user has registered and played, as well as information about games the user intends to play.

## Implemented features
- Displaying a list of games on the main page is working fine.
- Persisting a list of games in a local file is working.
- Scraping data for single games using RAWG.io is working.

## TODOs
- Scraped data from RAWG.io should be cached and persisted in the Game objects themselves. This way, they do not have to request these informations everytime and just get extended automatically if the info is available.
- Adding Games (and persisting them) has to be implemented
- Editing Game-Info (and subsequent persisting) has to be implemented
- Filtering games by platform, series, age-restriction has to be implemented
- Sorting games by name, platform, price, age-restriction, release-date, favourite has to be implemented
