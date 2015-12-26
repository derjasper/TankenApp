var mygasfeedApi = {};

{
    function processLastUpdate(str) {
        var lastUpdate = null;
        var unit = str.split(" ")[1];
        var amount = str.split(" ")[0];
        var diff = null;

        if (unit == "seconds") {
            diff = amount * 1000;
        }
        else if (unit == "minutes") {
            diff = amount * 1000 * 60;
        }
        else if (unit == "hours") {
            diff = amount * 1000 * 60 * 60;
        }
        else if (unit == "days") {
            diff = amount * 1000 * 60 * 60 * 24;
        }
        else if (unit == "months") {
            diff = amount * 1000 * 60 * 60 * 24 * 28;
        }
        else if (unit == "years") {
            diff = amount * 1000 * 60 * 60 * 365;
        }

        if (diff != null)
            lastUpdate = new Date((new Date()).getTime() - diff);

        return lastUpdate;
    }

mygasfeedApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {
    if (sort == "dist")
        sort = "distance";

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+"stations/radius/"+lat+"/"+lng+"/"+rad+"/"+type+"/"+sort+"/"+apikey+".json");
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
            model.push({
                name: "null",
                lat: data[key].lat,
                lng: data[key].lng,
                brand: data[key].station,
                dist: data[key].distance.match(/[0-9\.]+/)[0],
                dist_unit: (data[key].distance.indexOf("km") > -1 ? "km" : "miles"),
                price: data[key][type+"_price"],
                price_currency: (data[key].country == "Canada" ? "CAD": "USD"),
                id: data[key].id,
                address: data[key].address,
                postCode: "null",
                place: data[key].city,
                state: data[key].region,
                country: data[key].country,
                lastUpdate: processLastUpdate(data[key][type+"_date"])
            });
        }

        return model;
    }
};

mygasfeedApi.getDetails = function(apikey, url, id, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+"/stations/details/"+id+"/"+apikey+".json");
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
        var data = JSON.parse(jsonString).details;

        var obj = {
            id: data.id,
            name: "null",
            brand: data.station_name,
            address: data.address,
            postCode: "null",
            place: data.city,
            state: data.region,
            country: data.country,
            isOpen: "null",
            lat: data.lat,
            lng: data.lng,
            openingTimes: "null",
            fuel: []
        };

        if (data.reg_price != null) {
            obj.fuel.push({
                type: "reg",
                price: data.reg_price,
                price_currency: (data.country == "Canada" ? "CAD": "USD"),
                lastUpdate: processLastUpdate(data.reg_date)
            });
        }
        if (data.mid_price != null) {
            obj.fuel.push({
                type: "mid",
                price: data.mid_price,
                price_currency: (data.country == "Canada" ? "CAD": "USD"),
                lastUpdate: processLastUpdate(data.mid_date)
            });
        }
        if (data.pre_price != null) {
            obj.fuel.push({
                type: "pre",
                price: data.pre_price,
                price_currency: (data.country == "Canada" ? "CAD": "USD"),
                lastUpdate: processLastUpdate(data.pre_date)
            });
        }
        if (data.diesel_price != null) {
            obj.fuel.push({
                type: "diesel",
                price: data.diesel_price,
                price_currency: (data.country == "Canada" ? "CAD": "USD"),
                lastUpdate: processLastUpdate(data.diesel_date)
            });
        }

        return obj;
    }
};

}
