import QtQuick 2.0
import "api/api.js" as Api

Item {
    property double lat: 0.0
    property double lng: 0.0
    property int rad: 5 // <= 25
    property string sort: "price" // price, dist
    property string type: "diesel" // e5, e10, diesel

    property string api: ""

    property var apiProps: Api.apisettings[api]

    property bool loading: false
    property bool err: false

    property ListModel model : ListModel { id: jsonModel }

    function refresh() {
        if (lat==0 && lng==0) return;

        loading = true;

        try {
            Api.getList(api,lat,lng,rad,type,sort,function(m) {

                model.clear();

                if (m == null) {
                    err = true;
                }
                else {
                    for ( var key in m ) {
                        model.append(m[key]);
                    }

                    err = false;
                }
            });
        }
        catch(ex) {
            err = true;
            throw ex;
        }
        finally {
            loading = false;
        }
    }
}


