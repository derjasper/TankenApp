/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 *
 * Modified and extended for TankenApp
 */

import QtQuick 2.0
import "jsonpath.js" as JSONPath
import "debounce.js" as Debounce // TODO ?

Item {
    property string source: ""
    property string json: ""
    property string query: ""

    property bool loading: false

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    onSourceChanged: refresh()

    //property var refresh: Debounce.debounce(refreshNow,200)

    function refresh() {
        if (loading) return;

        loading = true;

        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                json = xhr.responseText;
                loading = false;
            }
        }
        xhr.send();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);
        for ( var key in objectArray ) {
            var jo = objectArray[key];
            if (jo.place != "Irgendwo") {
                jsonModel.append( jo );
            }
        }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var objectArray = JSON.parse(jsonString);
        if ( jsonPathQuery !== "" )
            objectArray = JSONPath.jsonPath(objectArray, jsonPathQuery);

        return objectArray;
    }
}
