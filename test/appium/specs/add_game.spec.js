const find = require("appium-flutter-finder");

describe("Add game", () => {
    it("correctly opens the add-game screen", async () => {
        await driver.execute("flutter:waitFor", find.byValueKey("root_games"));
        const addButton = find.byValueKey("add_game");
        await driver.elementClick(addButton);

        const addTitle = find.byText("Save");
        await driver.execute("flutter:waitFor", addTitle);
    });
});