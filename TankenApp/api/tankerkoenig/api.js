var tankerkoenigApi = {};

tankerkoenigApi.getList = function(apikey, lat, lng, rad, type, sort, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", "https://creativecommons.tankerkoenig.de/json/list.php?lat="+lat+"&lng="+lng+"&rad="+rad+"&sort="+sort+"&type="+type+"&apikey="+apikey);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            callback(processList(xhr.responseText));
        }
    }
    xhr.send();

    function processList(jsonString) {
        var model = [];

        var data = JSON.parse(jsonString).stations;
        for ( var key in data ) {
            if (data[key].place != "Irgendwo") {
                data[key].country = "Deutschland";
                data[key].lastUpdate = null;
                data[key].state = null;

                model.push(data[key]);
            }
        }

        return model;
    }
};


tankerkoenigApi.getDetails = function(apikey, id, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", "https://creativecommons.tankerkoenig.de/json/detail.php?id="+id+"&apikey="+apikey);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            callback(processEntry(xhr.responseText));
        }
    }
    xhr.send();

    function processEntry(jsonString) {
        var data = JSON.parse(jsonString).station;
        data.lastUpdate = null;
        data.country = "Deutschland";
        data.state = processState(data.state);
        return data;
    }

    function processState(id) {
        if (id == null) return null;

        var states = {
            deBB: "Brandenburg",
            deBE: "Berlin",
            deBW: "Baden-Württemberg",
            deBY: "Bayern",
            deHB: "Bremen",
            deHE: "Hessen",
            deHH: "Hamburg",
            deMV: "Mecklenburg-Vorpommern",
            deNI: "Niedersachsen",
            deNW: "Nordrhein-Westfalen",
            deRP: "Rheinland-Pfalz",
            deSH: "Schleswig-Holstein",
            deSL: "Saarland",
            deSN: "Sachsen",
            deST: "Sachsen-Anhalt",
            deTH: "Thüringen"
        };

        return states[id];
    }
};
