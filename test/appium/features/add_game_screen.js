const find = require("appium-flutter-finder");

class AddGameScreen {
    constructor() {}

    async enterName(name) {
        const nameInput = find.byValueKey("game_name");
        await driver.elementClick(nameInput);
        await driver.elementSendKeys(nameInput, name);
    }

    async selectPlatform(platform) {
        const platformInput = find.byValueKey("game_platform_input");
        await driver.elementClick(platformInput);
        await driver.execute("flutter:scrollUntilVisible", find.byType("Column"), {
            item: find.byValueKey(platform),
            dxScroll: 0,
            dyScroll: -400,
            waitTimeoutMilliseconds: 10000
        });
        await driver.elementClick(find.byValueKey(platform));
    }

    async selectStatus(status) {
        const statusInput = find.byValueKey("play_status");
        await driver.elementClick(statusInput);
        const statusOption = find.byValueKey(status);
        await driver.execute("flutter:waitFor", statusOption)
        await driver.elementClick(statusOption);
    }

    async enterPrice(price) {
        const priceInput = find.byValueKey("price");
        await driver.elementClick(priceInput);
        await driver.elementSendKeys(priceInput, price);
    }

    async selectAgeRating(ageRating) {
        const ageRatingInput = find.byValueKey("age_rating");
        await driver.elementClick(ageRatingInput);
        const ageRatingOption = find.byValueKey(ageRating);
        await driver.execute("flutter:waitFor", ageRatingOption)
        await driver.elementClick(ageRatingOption);
    }

    async saveGame() {
        const saveButton = find.byValueKey("save_game");
        await driver.elementClick(saveButton);
    }
}

module.exports = {
    AddGameScreen
}