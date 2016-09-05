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
    },
    carburanti: {
      unit: {
        distance: "km"
      },
      features: {
        types: ["1-x", "1-1", "1-0", "2-x", "2-1", "2-0", "3-x", "4-x", "6-0", "6-1", "6-x", "10-0", "10-1", "14-0", "14-1", "20-0", "20-1"],
        sort: ["price"]
      }
    }
};
