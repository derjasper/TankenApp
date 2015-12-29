import QtQuick 2.0
import "api/api.js" as Api

Item {
    property string stationId: ""

    property bool loading: false
    property bool err: false

    property variant model: ({})

    property string api: ""

    property var apiProps: Api.apiindex[api]

    function refresh() {
        if (stationId=="")
            return;

        loading = true;

        Api.getDetails(api, stationId, function(m) {
            if (m == null) {
                model = {};
                err = true;
            }
            else {
                model = m;
                err = false;
            }

            loading = false;
        });

    }

    onStationIdChanged: refresh()
}


