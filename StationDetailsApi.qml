import QtQuick 2.0
import "api/api.js" as Api

Item {
    property string stationId: ""

    property bool loading: false

    property variant model: ({})

    function refresh() {
        if (stationId=="")
            return;

        loading = true;

        Api.getDetails("tankerkoenig", stationId, function(m) {
            model = m;

            loading = false;
        });

    }

    onStationIdChanged: refresh()
}


