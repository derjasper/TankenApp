import QtQuick 2.0
import "JSON"

Item {
    property double lat: 0.0
    property double lng: 0.0
    property int rad: 5 // <= 25
    property string sort: "price" // price, dist
    property string type: "diesel" // e5, e10, diesel
    property string apikey: "***REMOVED***"

    property bool loading: json.loading

    property ListModel model : json.model

    function refresh() {
        if (lat==0 && lng==0) return;
        json.source = "https://creativecommons.tankerkoenig.de/json/list.php?lat="+lat+"&lng="+lng+"&rad="+rad+"&sort="+sort+"&type="+type+"&apikey="+apikey;
        json.refresh()
    }

    Component.onCompleted: refresh()

    onRadChanged: refresh()
    onSortChanged: refresh()
    onTypeChanged: refresh()


    JSONListModel {
        id: json
        source: ""
        query: "$.stations[*]"
    }
}


