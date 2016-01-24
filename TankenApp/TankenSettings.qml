import QtQuick 2.0
import Qt.labs.settings 1.0

import "api/api.js" as Api

Settings {
    id: settings

    property string type: "diesel"
    property string sort: "price"
    property string rad: "5"
    property double lat: 0
    property double lng: 0
    property string api: "tankerkoenig"
    property bool firstStart: true

    onApiChanged: {
        if (Api.apisettings[api].features.types.indexOf(type) == -1)
            type = Api.apisettings[api].features.types[0];

        if (Api.apisettings[api].features.sort.indexOf(sort) == -1)
            sort = Api.apisettings[api].features.sort[0];
    }
}



