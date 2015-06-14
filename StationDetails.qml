import QtQuick 2.0
import "JSON"

Item {
    property string stationId: ""
    property string apikey: "***REMOVED***"

    property bool loading: json.loading

    property variant model : json.model

    function refresh() {
        if (stationId!="")
        json.source = "https://creativecommons.tankerkoenig.de/json/detail.php?id="+stationId+"&apikey="+apikey;
        json.refresh()
    }

    Component.onCompleted: refresh()

    onStationIdChanged: refresh()

    JSONModel {
        id: json
        source: ""
        query: "$.station"
    }
}


