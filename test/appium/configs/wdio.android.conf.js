const { resolve } = require("path");
const { android } = require("../utils/platform");
const sharedConfig = require('./wdio.shared.conf');

global.platform = android;

module.exports.config = {
    ...sharedConfig,
    capabilities: [
        {
            "platformName": "Android",
            "appium:automationName": "Flutter",
            // Add your emulator or real device name here:
            "appium:deviceName": "Pixel 5 API 34",
            "appium:noReset": false,
            "appium:appPackage": "org.philipp_guertler.pile_of_shame",
            // This path is relative to the root of this npm-project
            "appium:app": resolve("../../build/app/outputs/apk/debug/app-debug.apk"),
        }
    ]
}