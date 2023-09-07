const { resolve } = require("path");
const { ios } = require("../utils/platform");
const sharedConfig = require('./wdio.shared.conf');

global.platform = ios;

module.exports.config = {
    ...sharedConfig,
    capabilities: [
        {
            "platformName": "iOS",
            "appium:automationName": "Flutter",
            // Add your emulator or real device name here:
            "appium:deviceName": "iPhone 14",
            "appium:noReset": false,
            "appium:appPackage": "org.philippGuertler.pileOfShame",
            // This path is relative to the root of this npm-project
            "appium:app": resolve("../../build/ios/Debug-iphonesimulator/Runner.app"),
        }
    ]
}