var spritpreisrechnerApi = {
  settings: {
      unit: {
          distance: "km"
      },
      features: {
          types: ["diesel", "super95"],
          sort: ["price"]
      }
  }
};

{
    var dataCache = [];

    spritpreisrechnerApi.getList = function(apikey, url, lat, lng, rad, type, sort, callback) {
        if (type=="diesel")
            type = "DIE";
        else if (type == "super95")
            type = "SUP";

        // calculate square around current position
        // thanks to http://stackoverflow.com/questions/4000886/gps-coordinates-1km-square-around-a-point
        var lat1 = lat - (360/40075)*rad;
        var lat2 = lat + (360/40075)*rad;
        var lng1 = lng - 360/(Math.abs(Math.cos(lat))*40075)*rad;
        var lng2 = lng + 360/(Math.abs(Math.cos(lat))*40075)*rad;


        var xhr = new XMLHttpRequest;
        xhr.open("GET", url+'?data=["checked","'+type+'",'+lng1+','+lat1+','+lng2+','+lat2+']');
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                if (xhr.status == 200) {
                    callback(processList(xhr.responseText));
                    dataCache = JSON.parse(xhr.responseText);
                }
                else {
                    callback(null);
                }
            }
        }
        xhr.send();

        function processList(jsonString) {
            var model = [];

            var data = JSON.parse(jsonString);
            for ( var key in data ) {
                if (data[key].spritPrice[0] != undefined) {
                    model.push({
                            name: data[key].gasStationName,
                            lat: data[key].latitude+"",
                            lng: data[key].longitude+"",
                            brand: "null",
                            dist: data[key].distance+"",
                            dist_unit: "km",
                            price: data[key].spritPrice[0].amount != "" ? data[key].spritPrice[0].amount+"" : "null",
                            price_currency: "EUR",
                            id: key+"",
                            address: data[key].address,
                            postCode: data[key].postalCode,
                            place: data[key].city,
                            state: "null",
                            country: "Österreich",
                            lastUpdate: data[key].spritPrice[0].datAnounce,
                            isOpen: data[key].isOpen+""
                    });
                }
            }

            return model;
        }
    };

    spritpreisrechnerApi.getDetails = function(apikey, url, id, callback) {
        if (parseInt(id)<dataCache.length) {
            callback(processEntry(dataCache[parseInt(id)],id));
        }
        else {
            callback(null);
        }

        function processEntry(data,key) {
            var obj = {
                name: data.gasStationName,
                lat: data.latitude+"",
                lng: data.longitude+"",
                brand: "null",
                id: key,
                address: data.address,
                postCode: data.postalCode,
                place: data.city,
                state: "null",
                country: "Österreich",
                isOpen: data.isOpen+"",
                openingTimes: [],
                fuel: []
            };

            for (var i = 0; i<data.openingHours.length; i++) {
                obj.openingTimes.push({
                    text: data.openingHours[i].day.dayLabel,
                    start: data.openingHours[i].beginn,
                    end: data.openingHours[i].end
                });
            }

            if (data.spritPrice[0].spritId!="") {
                obj.fuel.push({
                    type: data.spritPrice[0].spritId == "DIE" ? "diesel" : "super95",
                    price: data.spritPrice[0].amount != "" ? data.spritPrice[0].amount+"" : "null",
                    price_currency: "EUR",
                    lastUpdate: data.spritPrice[0].datAnounce
                });
            }

            return obj;
        }
    };
}
