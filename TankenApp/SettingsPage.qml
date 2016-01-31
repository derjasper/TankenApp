import QtQuick 2.0
import Ubuntu.Components 1.3
import "api/api.js" as Api
import "helper.js" as Helper

Page {
    id: filter
    title: i18n.tr("Filter")

    signal settingsChanged

    property string type: "diesel"
    property string sort: "price"
    property double radius: 5

    property string api

    onActiveChanged: {
        if (!active)
            settingsChanged()
        else {
            radiusSelector.value = radius;
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(2)
        spacing: units.gu(2)

        OptionSelector {
            id: typeSelector
            text: i18n.tr("Fuel type")
            model: makeModel(Api.apisettings[api].features.types)
            selectedIndex: keyToIndex(type);
            onSelectedIndexChanged: {
                type = indexToKey(selectedIndex)
            }

            function keyToIndex(key) {
                for (var i=0; i<Api.apisettings[api].features.types.length; i++) {
                    if (Api.apisettings[api].features.types[i]==key)
                        return i;
                }

                return 0;
            }

            function indexToKey(idx) {
                if (Api.apisettings[api].features.types.length<=idx)
                    return 0;
                return Api.apisettings[api].features.types[idx];
            }

            function makeModel(list) {
                var model = [];

                for (var i=0; i<list.length; i++) {
                    model.push(Helper.fuelKeyToString(api,list[i]));
                }

                return model;
            }
        }

        Column {
            width:parent.width
            Label {
                text: i18n.tr("Radius")
            }

            Slider {
                id: radiusSelector
                function formatValue(v) {
                    return v.toFixed(0) + " " +  Api.apisettings[api].unit.distance
                }
                minimumValue: 1
                maximumValue: 25
                live: false
                onValueChanged: {
                    radius = value
                }
                width:parent.width
            }
        }

        OptionSelector {
            id: sortSelector
            text: i18n.tr("sort by")
            model: makeModel(Api.apisettings[api].features.sort)
            selectedIndex: keyToIndex(type);
            onSelectedIndexChanged: {
                sort = indexToKey(selectedIndex)
            }

            function keyToIndex(key) {
                for (var i=0; i<Api.apisettings[api].features.sort.length; i++) {
                    if (Api.apisettings[api].features.sort[i]==key)
                        return i;
                }

                return 0;
            }

            function indexToKey(idx) {
                if (Api.apisettings[api].features.sort.length<=idx)
                    return 0;
                return Api.apisettings[api].features.sort[idx];
            }

            function makeModel(list) {
                var model = [];

                for (var i=0; i<list.length; i++) {
                    model.push(Helper.sortKeyToString(list[i]));
                }

                return model;
            }
        }
    }
}
