Qt.include("apikeys.js")
Qt.include("apiindex.js")

/**
  API for getting fuel prices

  the called sub-API need to return objects as described in the functions below

  api keys should be stored in apikeys.js; name and description of an api should be stored in apiindex.js
*/

// import sub-APIs
var apis = {};
Qt.include("tankerkoenig/api.js");
apis["tankerkoenig"]=tankerkoenigApi;

/**
  get a list of stations

  parameters:
  apiId: api to use
  lat: lat of center
  lng: lng of center
  rad: radius around center
  type: fuel type; e5, e10, diesel
  sort: sort by; price, dist
  callback: callback function

  calls the callback with a list of objects represting gas stations where each object has the keys:
  name: name
  lat: lat of station
  lng: lng of station
  brand: brand
  dist: distance to center
  price: price of selected fuel type
  currency: currency of price
  id: id of gas station (dependent on api)
  street: address
  houseNumber: address
  postCode: address
  place: address
  state: address
  country: address
  lastUpdate: last update of pricing information (YYYY-MM-DD hh:mm:ss)

  if an information is not available, the key has null as value

  on error, the callback is called with null
*/
function getList(apiId, lat, lng, rad, type, sort, callback) {
    apis[apiId].getList(apikey[apiId], lat, lng, rad, type, sort, callback);
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
  street: address
  houseNumber: address
  postCode: address
  place: address
  state: address
  country: address
  isOpen: true if station is open now
  price: { (object of prices; entries may be set to null if station does not sell the fuel type)
    e5: e5
    e10: e10
    diesel: diesel
  }
  lat: lat of station
  lng: lng of station
  openingTimes: [ (array of openign times)
    {
        text: description of weekday or sth like that; dependent on language and api
        start: start time in hh:mm:ss
        end: end time in hh:mm:ss
    }

  ]
  lastUpdate: last update of pricing information (YYYY-MM-DD hh:mm:ss)

  if an information is not available, the key has null as value

  on error, the callback is called with null
*/
function getDetails(apiId, id, callback) {
    apis[apiId].getDetails(apikey[apiId], id, callback);
}
