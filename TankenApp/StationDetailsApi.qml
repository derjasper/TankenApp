import QtQuick 2.0
import "api/api.js" as Api

Item {
    property string stationId: ""

    property bool loading: false

    property variant model: ({})

    property string api: ""

    property var apiProps: Api.apiindex[api]

    function refresh() {
        if (stationId=="")
            return;

        loading = true;

        Api.getDetails(api, stationId, function(m) {
            model = m;

            loading = false;
        });

    }

    onStationIdChanged: refresh()

    // TODO error handling
}


