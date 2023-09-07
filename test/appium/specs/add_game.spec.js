const find = require("appium-flutter-finder");
const { GamesScreen } = require("../features/games_screen");

describe("Add game", () => {
    const gameScreen = new GamesScreen();
    it("correctly opens the search and searches for a game", async () => {
        await gameScreen.toggleSearch();
        await gameScreen.enterGameSearchString("some test game");
        await driver.pause(1000)
        await gameScreen.toggleSearch();
        // await driver.pause(5000);
    });
    it("correctly opens and closes sorters", async () => {
        await gameScreen.openSorters();
        await gameScreen.closeSorters();
    });
    it("correctly opens and closes filters", async () => {
        await gameScreen.openFilters();
        await gameScreen.closeFilters();
    });

    it("correctly opens the add-game screen", async () => {
        await driver.execute("flutter:waitFor", find.byValueKey("root_games"));
        const addButton = find.byValueKey("add_game");
        await driver.elementClick(addButton);

        const addTitle = find.byText("Save");
        await driver.execute("flutter:waitFor", addTitle);
    });
});