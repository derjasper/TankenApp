.pragma library

Qt.include("apikeys.js")
Qt.include("apisettings.js")

/**
  API for getting fuel prices

  the called sub-API need to return objects as described in the functions below

  api keys should be stored in apikeys.js; name and description of an api should be stored in apiindex.js
*/

// import sub-APIs
var apis = {};
Qt.include("tankerkoenig.js");
apis["tankerkoenig"]=tankerkoenigApi;
Qt.include("mygasfeed.js");
apis["mygasfeed"]=mygasfeedApi;
Qt.include("spritpreisrechner.js");
apis["spritpreisrechner"]=spritpreisrechnerApi;
Qt.include("geoportalgasolineras.js");
apis["geoportalgasolineras"]=geoportalgasolinerasApi;
Qt.include("carburanti.js");
apis["carburanti"]=carburantiApi;


/**
  get a list of stations

  parameters:
  apiId: api to use
  lat: lat of center
  lng: lng of center
  rad: radius around center; km or miles (depends on api)
  type: fuel type; e5, e10, diesel, reg, mid, pre (depends on api)
  sort: sort by; price, dist
  callback: callback function

  calls the callback with a list of objects represting gas stations where each object has the keys:
  name: name
  lat: lat of station
  lng: lng of station
  brand: brand
  dist: distance to center
  dist_unit: unit of distance
  price: price of selected fuel type
  price_currency: currency of price
  id: id of gas station (dependent on api)
  address: street and house number
  postCode: address
  place: address
  state: state or region
  country: address
  lastUpdate: last update of pricing information; string that can be parsed with "new Date(dateString)"
  isOpen: true if station is open now

  if an information is not available, the key has "null" as value; all values are strings (except exceptions)

  on error, the callback is called with null
*/
function getList(apiId, lat, lng, rad, type, sort, callback) {
    apis[apiId].getList(apikey[apiId].key, apikey[apiId].url, lat, lng, rad, type, sort, callback);
}

/**
  get station details

  parameters:
  apiId: api to use
  id: station id
  callback: callback function

  calls the callback with an object containing the following keys:
  id: station id
  name: name
  brand: brand
  address: street and house number
  postCode: address
  place: address
  state: state or region
  country: address
  isOpen: true if station is open now
  lat: lat of station
  lng: lng of station
  openingTimes: [ (array of opening times)
    {
        text: description of weekday or sth like that; dependent on language and api
        start: start time in hh:mm:ss
        end: end time in hh:mm:ss
    }

  ]
  fuel: [
    {
      type: e5,e10,diesel,...
      price: price
      price_currency: currency of price
      lastUpdate: last update of pricing information; string that can be parsed with "new Date(dateString)"
    }
  ]


  if an information is not available, the key has "null" as value; all values are strings (except exceptions)

  on error, the callback is called with null
*/
function getDetails(apiId, id, callback) {
    apis[apiId].getDetails(apikey[apiId].key, apikey[apiId].url, id, callback);
}
