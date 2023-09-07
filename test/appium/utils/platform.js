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
}

const android = new Platform("Android");
const ios = new Platform("iOS");

module.exports = {
    ios,
    android
};
