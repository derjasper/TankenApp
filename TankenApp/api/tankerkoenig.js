var tankerkoenigApi = {};

tankerkoenigApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+"json/list.php?lat="+lat+"&lng="+lng+"&rad="+rad+"&sort="+sort+"&type="+type+"&apikey="+apikey);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                callback(processList(xhr.responseText));
            }
            else {
                callback(null);
            }
        }
    }
    xhr.send();

    function processList(jsonString) {
        var model = [];

        var data = JSON.parse(jsonString).stations;
        for ( var key in data ) {
            if (data[key].place != "Irgendwo") {
                model.push({
                    name: data[key].name,
                    lat: data[key].lat+"",
                    lng: data[key].lng+"",
                    brand: (data[key].brand != null ? data[key].brand : "null"),
                    dist: data[key].dist+"",
                    dist_unit: "km",
                    price: data[key].price+"",
                    price_currency: "EUR",
                    id: data[key].id,
                    address: data[key].street + (data[key].houseNumber==undefined ? "" : " "+data[key].houseNumber ),
                    postCode: data[key].postCode != null ? data[key].postCode+"" : "null",
                    place: data[key].place,
                    state: "null",
                    country: "Deutschland",
                    lastUpdate: "null",
                    isOpen: "null"
                });
            }
        }

        return model;
    }
};


tankerkoenigApi.getDetails = function(apikey, url, id, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+"json/detail.php?id="+id+"&apikey="+apikey);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                callback(processEntry(xhr.responseText));
            }
            else {
                callback(null);
            }
        }
    }
    xhr.send();

    function processEntry(jsonString) {
        var data = JSON.parse(jsonString).station;

        var obj = {
            id: data.id,
            name: data.name,
            brand: data.brand+"",
            address: data.street + (data.houseNumber==undefined ? "" : " "+data.houseNumber ),
            postCode: data.postCode+"",
            place: data.place,
            state: processState(data.state),
            country: "Deutschland",
            isOpen: data.isOpen+"",
            lat: data.lat,
            lng: data.lng,
            openingTimes: data.openingTimes,
            fuel: []
        };

        if (data.e5 != null) {
            obj.fuel.push({
                type: "e5",
                price: data.e5,
                price_currency: "EUR",
                lastUpdate: "null"
            });
        }
        if (data.e10 != null) {
            obj.fuel.push({
                type: "e10",
                price: data.e10,
                price_currency: "EUR",
                lastUpdate: "null"
            });
        }
        if (data.diesel != null) {
            obj.fuel.push({
                type: "diesel",
                price: data.diesel,
                price_currency: "EUR",
                lastUpdate: "null"
            });
        }

        return obj;
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
