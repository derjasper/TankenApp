import QtQuick 2.0
import Ubuntu.Components 1.3
import "api/api.js" as Api

Page {
    id: filter
    title: i18n.tr("Filter")

    signal settingsChanged

    property string type: "e5"
    property string sort: "price"
    property int radius: 5

    property string api

    onActiveChanged: {
        if (!active)
            settingsChanged()
    }

    Column {
        anchors.fill: parent
        anchors.margins: units.gu(2)
        spacing: units.gu(2)

        OptionSelector {
            id: typeSelector
            text: i18n.tr("Fuel type")
            model: makeModel(Api.apiindex[api].features.types)
            selectedIndex: keyToIndex(type);
            onSelectedIndexChanged: {
                type = indexToKey(selectedIndex)
            }

            function keyToIndex(key) {
                for (var i=0; i<model.length; i++) {
                    if (model[i].name==key)
                        return i;
                }

                return 0;
            }

            function indexToKey(idx) {
                if (model.length<=idx)
                    return 0;
                return model[idx];
            }

            function makeModel(list) {
                var model = [];

                for (var i=0; i<list.length; i++) {
                    model.push(i18n.tr(list[i]));
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
                    return v.toFixed(0) + " " +  Api.apiindex[api].unit.distance
                }
                minimumValue: 1
                maximumValue: 25
                value: radius
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
            model: makeModel(Api.apiindex[api].features.sort)
            selectedIndex: keyToIndex(type);
            onSelectedIndexChanged: {
                sort = indexToKey(selectedIndex)
            }

            function keyToIndex(key) {
                for (var i=0; i<model.length; i++) {
                    if (model[i].name==key)
                        return i;
                }

                return 0;
            }

            function indexToKey(idx) {
                if (model.length<=idx)
                    return 0;
                return model[idx];
            }

            function makeModel(list) {
                var model = [];

                for (var i=0; i<list.length; i++) {
                    model.push(i18n.tr(list[i]));
                }

                return model;
            }
        }
    }
}
