const find = require("appium-flutter-finder");

class GamesScreen {
    constructor() {
    }

    async openFilters() {
        const filterButton = find.byValueKey("filter_games");
        await driver.elementClick(filterButton);
    }

    async closeFilters() {
        await driver.execute("flutter:scroll", find.byType("Drawer"), {
            dx: 400, dy: 0, durationMilliseconds: 100, fequency: 30
        });
    }

    async openSorters() {
        const sorterButton = find.byValueKey("sort_games");
        await driver.elementClick(sorterButton);
    }

    async closeSorters() {
        await driver.execute("flutter:scroll", find.byType("Drawer"), {
            dx: -400, dy: 0, durationMilliseconds: 100, fequency: 30
        });
    }

    async toggleSearch() {
        const searchButton = find.byValueKey("toggle_game_search");
        await driver.elementClick(searchButton);
    }

    async enterGameSearchString(search) {
        const searchField = find.byValueKey("search_games");
        await driver.execute("flutter:waitFor", searchField);
        await driver.elementSendKeys(searchField, search);
    }

    async openAddGameScreen() {
        const addButton = find.byValueKey("add_game");
        await driver.elementClick(addButton);
    }

    async clickScreenTitle() {
        const title = find.byValueKey("games_screen_title");
        await driver.elementClick(title);
    }
}

module.exports = {
    GamesScreen
}