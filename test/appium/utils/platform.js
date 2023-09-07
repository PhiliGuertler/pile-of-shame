const find = require("appium-flutter-finder");

class Platform {
    constructor(name) {
        this.name = name;
    }

    get isAndroid() {
        return this.name === "Android";
    }

    get isIos() {
        return this.name === "iOS";
    }

    async back() {
        const appBar = find.byType("AppBar");
        const back = find.descendant({
            of: appBar,
            matching: find.byType("BackButton"),
            firstMatchOnly: true,
        });

        await driver.elementClick(back);
        await driver.pause(3000);
    }
}

const android = new Platform("Android");
const ios = new Platform("iOS");

module.exports = {
    ios,
    android
};
