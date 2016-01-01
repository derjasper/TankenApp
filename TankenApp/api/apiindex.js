var apiindex = {
    tankerkoenig: {
        name: "Tankerkoenig.de",
        description: "official MTS-K data for Germany",
        license: "CC BY 4.0 - http://creativecommons.tankerkoenig.de",
        unit: {
            distance: "km"
        },
        features: {
            types: ["e5", "e10", "diesel"],
            sort: ["price","dist"]
        }
    },
    mygasfeed: {
        name: "myGasFeed.com",
        description: "user contributed data for USA",
        license: "http://www.mygasfeed.com/",
        unit: {
            distance: "miles"
        },
        features: {
            types: ["reg", "mid", "pre", "diesel"],
            sort: ["price","dist"]
        }
    },
    spritpreisrechner: {
        name: "spritpreisrechner.at",
        description: "official data for Austria",
        license: "http://spritpreisrechner.at/",
        unit: {
            distance: "km"
        },
        features: {
            types: ["diesel", "super95"],
            sort: ["price"]
        }
    }
};
