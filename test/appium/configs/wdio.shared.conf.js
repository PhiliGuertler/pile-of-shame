module.exports = {
    host: process.env.APPIUM_HOST || 'localhost',
    port: parseInt(process.env.APPIUM_PORT, 10) || 4723,
    runner: "local",
    logLevel: "debug",
    waitForTimeout: 30000,
    connectionRetryCount: 3,
    reporters: ['spec'],
    specs: ['../specs/**/*.spec.js'],
    mochaOpts: {
        timeout: 30000,
    },
    maxInstances: 1,
}
