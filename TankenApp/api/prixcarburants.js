var prixcarburantsApi = {
  settings: {
      unit: {
          distance: "km"
      },
      features: {
          types: ["gazole","sp95","sp98","gplc","e10","e85"],
          sort: ["price","dist"]
      }
  }
};

prixcarburantsApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {
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
                name: data[key].properties.address+"",
                lat: data[key].geometry.coordinates[1]+"",
                lng: data[key].geometry.coordinates[0]+"",
                brand: "null",
                dist: (data[key].properties.dist/1000).toFixed(1)+"",
                dist_unit: "km",
                price: data[key].properties["price_"+type]+"",
                price_currency: "EUR",
                address: data[key].properties.address+"",
                postCode: data[key].properties.postCode+"",
                place: data[key].properties.place+"",
                state: "null",
                country: "France",
                lastUpdate: data[key].properties["lastUpdate_"+type]+"",
                isOpen: "null"
            });
        }

        return model;
    }
};


prixcarburantsApi.getDetails = function(apikey, url, id, callback) {
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
            name: data.properties.address+"",
            brand: "null",
            address: data.properties.address+"",
            postCode: data.properties.postCode+"",
            place: data.properties.place+"",
            state: "null",
            country: "France",
            isOpen: "null",
            lat: data.geometry.coordinates[1]+"",
            lng: data.geometry.coordinates[0]+"",
            openingTimes: data.properties.openingTimes,
            fuel: []
        };

        var types = ["gazole","sp95","sp98","gplc","e10","e85"];
        for (var i=0; i<types.length; i++) {
            if (data.properties["price_"+types[i]] != null) {
                obj.fuel.push({
                    type: types[i],
                    price: data.properties["price_"+types[i]],
                    price_currency: "EUR",
                    lastUpdate: data.properties["lastUpdate_"+types[i]]
                });
            }
        }

        return obj;
    }
};
