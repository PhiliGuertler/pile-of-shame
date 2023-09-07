const find = require("appium-flutter-finder");
const { GamesScreen } = require("../features/games_screen");
const { AddGameScreen } = require("../features/add_game_screen");

describe("Add game", () => {
    const gameScreen = new GamesScreen();
    const addGameScreen = new AddGameScreen();
    it("correctly opens the search and searches for a game", async () => {
        await gameScreen.toggleSearch();
        await gameScreen.enterGameSearchString("some test game");
        await driver.pause(100)
        await gameScreen.toggleSearch();
    });
    it("correctly opens and closes sorters", async () => {
        await gameScreen.openSorters();
        await gameScreen.closeSorters();
    });
    it("correctly opens and closes filters", async () => {
        await gameScreen.openFilters();
        await gameScreen.closeFilters();
    });
    it("correctly opens the add-game screen and adds a game", async () => {
        await gameScreen.openAddGameScreen();
        
        const gameName = "test game";

        await addGameScreen.enterName(gameName);
        await addGameScreen.selectPlatform("PS5");
        await addGameScreen.selectStatus("PlayStatus.playing");
        await addGameScreen.enterPrice("19.99");
        await addGameScreen.selectAgeRating("USK.usk16");
        await addGameScreen.saveGame();

        await gameScreen.clickGameByName(gameName);
        await driver.pause(1000);
    });
});