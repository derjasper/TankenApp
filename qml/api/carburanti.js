var carburantiApi = {
  settings: {
    unit: {
      distance: "km"
    },
    features: {
      types: ["1-x", "1-1", "1-0", "2-x", "2-1", "2-0", "3-x", "4-x", "6-0", "6-1", "6-x", "10-0", "10-1", "14-0", "14-1", "20-0", "20-1"],
      sort: ["price"]
    }
  }
};

{

    function parseData(html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html);
        var main

        return obj;
    }

    function getPrice(carburanti, type) {
        var price = null;
        var carburante = type.split('-')[0];
        for ( var n in carburanti) {
            if (carburanti[n].idCarb == carburante){
                price = carburanti[n].prezzo;
            }
        }
        return price;
    }

    function calcolateDistance(lat1, lon1, lat2, lon2) {
        var R = 6371; // Radius of the earth in km
        var dLat = deg2rad(lat2-lat1);  // deg2rad below
        var dLon = deg2rad(lon2-lon1);
        var a =
                Math.sin(dLat/2) * Math.sin(dLat/2) +
                Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
                Math.sin(dLon/2) * Math.sin(dLon/2)
        ;
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        var d = R * c; // Distance in km
        return d.toFixed(2);
    }

    function deg2rad(deg) {
        return deg * (Math.PI/180)
    }

    carburantiApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {


        /**
        DEBUG ONLY
        **/
        console.log("ApiKey: " + apikey);
        console.log("Url: " + url);
        console.log("Lat: " + lat);
        console.log("Long: " + lng);
        console.log("Rad: " + rad);
        console.log("Type: " + type);
        console.log("Sort: " + sort);
        console.log("Callback: " + callback);

        if (sort == "price") {
            sort = "asc";
        } else {
            sort = "desc";
        }


        rad *= 1000;

        var params = "carb=" + type + "&ordPrice=" + sort + "&pointsListStr=" + lat + "-" + lng + "#";

        console.log("params: " + params);

        var xhr = new XMLHttpRequest;
        xhr.open("POST", url + "ricerca/position", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Content-length", params.length);
        xhr.setRequestHeader("Connection", "close");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                if (xhr.status == 200) {
                    callback(processList(xhr.responseText));
                }
            } else {
                callback(null);
            }
        }
        xhr.send(params);

        function processList(jsonString) {
            var model = [];

            var data = JSON.parse(jsonString);
            for (var key in data.array) {
                var zipcode = data.array[key].addr.match(/([0-9]{5})/);
                if (zipcode != null) {
                    zipcode = zipcode[0];
                }

                var address = data.array[key].addr.split('-')[0].replace(zipcode, '').trim();
                var state = data.array[key].addr.split('-')[1];
                state = state.split(' ')[state.split(' ').length - 1];
                var place = data.array[key].addr.split('-')[1].split(state)[0].trim();

                model.push({
                   id: data.array[key].name,
                   name: data.array[key].name,
                   lat: data.array[key].lat,
                   lng: data.array[key].lon,
                   brand: data.array[key].bnd,
                   dist: calcolateDistance(data.center.first, data.center.second, data.array[key].lat, data.array[key].lon),
                   dist_unit: "km",
                   price: getPrice(data.array[key].carburanti, type),
                   price_currency: "EUR",
                   address: address,
                   postCode: zipcode,
                   place: place,
                   state: state,
                   country: "Italia",
                   lastUpdate: data.array[key].dIns,
                   isOpen: "null"

                });
            }
            return model;
        }

    };


    carburantiApi.getDetails = function(apikey, url, id, callback) {
        console.log("Details url: " + url + "ricerca/areads");

        var params = "carb=&nameServiceArea=" + id;
        var xhr = new XMLHttpRequest;
        xhr.open("POST", url + "ricerca/areads", true);
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhr.setRequestHeader("Content-length", params.length);
        xhr.setRequestHeader("Connection", "close");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                if (xhr.status == 200) {
                    console.log(JSON.stringify(xhr.responseText, null, 4));
                    callback(processEntry(xhr.responseText));
                } else {
                    callback(null);
                }
            }
        }
        xhr.send(params);

        function processEntry(jsonString) {

            var data = JSON.parse(jsonString).array[0];
            console.log(data, null, 4);

            var zipcode = data.addr.match(/([0-9]{5})/);
            if (zipcode != null) {
                zipcode = zipcode[0];
            }

            var address = data.addr.split('-')[0].replace(zipcode, '').trim();
            var state = data.addr.split('-')[1];
            state = state.split(' ')[state.split(' ').length - 1];
            var place = data.addr.split('-')[1].split(state)[0].trim();


            var obj = {
                id: data.id,
                name: data.name,
                brand: data.bnd,
                address: address,
                postCode: zipcode,
                place: place,
                state: state,
                country: "Italia",
                isOpen: "null",
                lat: data.lat,
                lng: data.lon,
                openingTimes: "null",
                fuel: []
            };

            for ( var i in data.carburanti ) {
                obj.fuel.push({
                    type: data.carburanti[i].idCarb + '-' + data.carburanti[i].isSelf,
                    price: data.carburanti[i].prezzo,
                    price_currency: "EUR",
                    lastUpdate: data.dIns
                });
            }

            return obj;
        }
    };

}
