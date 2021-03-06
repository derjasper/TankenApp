var geoportalgasolinerasApi = {
  settings: {
      unit: {
          distance: "km"
      },
      features: {
          types: ["gpr","g98","goa","ngo","bio","bie","gnc"],
          sort: ["price","dist"]
      }
  }
};

geoportalgasolinerasApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {
    if (sort=="price") {
        sort="price_"+type;
    }

    rad*=1000;

    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+"?lat="+lat+"&lng="+lng+"&radius="+rad+"&sort="+sort);
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

        var data = JSON.parse(jsonString).features;
        for ( var key in data ) {
                model.push({
                    id: data[key].id,
                    name: "null",
                    lat: data[key].geometry.coordinates[1]+"",
                    lng: data[key].geometry.coordinates[0]+"",
                    brand: data[key].properties.brand,
                    dist: (data[key].properties.dist/1000).toFixed(1)+"",
                    dist_unit: "km",
                    price: data[key].properties["price_"+type]+"",
                    price_currency: "EUR",
                    address: data[key].properties.address+"",
                    postCode: "null",
                    place: data[key].properties.place+"",
                    state: data[key].properties.state+"",
                    country: "España",
                    lastUpdate: "null",
                    isOpen: "null"
                });
        }

        return model;
    }
};


geoportalgasolinerasApi.getDetails = function(apikey, url, id, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("GET", url+""+id);
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
        var data = JSON.parse(jsonString);

        var obj = {
            id: data.id,
            name: "null",
            brand: data.properties.brand+"",
            address: data.properties.address+"",
            postCode: "null",
            place: data.properties.place+"",
            state: data.properties.state+"",
            country: "España",
            isOpen: "null",
            lat: data.geometry.coordinates[1]+"",
            lng: data.geometry.coordinates[0]+"",
            openingTimes: [{
                text: data.properties.openingTimes+"",
                start: "null",
                end: "null"
            }],
            fuel: []
        };

        var types = ["gpr","g98","goa","ngo","bio","bie","gnc"];
        for (var i=0; i<types.length; i++) {
            if (data.properties["price_"+types[i]] != null) {
                obj.fuel.push({
                    type: types[i],
                    price: data.properties["price_"+types[i]],
                    price_currency: "EUR",
                    lastUpdate: "null"
                });
            }
        }

        return obj;
    }
};
