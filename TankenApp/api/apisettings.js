var apisettings = {
    tankerkoenig: {
        unit: {
            distance: "km"
        },
        features: {
            types: ["e5", "e10", "diesel"],
            sort: ["price","dist"]
        }
    },
    mygasfeed: {
        unit: {
            distance: "miles"
        },
        features: {
            types: ["reg", "mid", "pre", "diesel"],
            sort: ["price","dist"]
        }
    },
    spritpreisrechner: {
        unit: {
            distance: "km"
        },
        features: {
            types: ["diesel", "super95"],
            sort: ["price"]
        }
    },
    geoportalgasolineras: {
        unit: {
            distance: "km"
        },
        features: {
            types: ["gpr","g98","goa","ngo","bio","bie","gnc"],
            sort: ["price","dist"]
        }
    }
};

