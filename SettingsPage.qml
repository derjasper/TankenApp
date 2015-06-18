import QtQuick 2.0
import Ubuntu.Components 1.2

Page {
    id: filter
    title: i18n.tr("Filter")

    signal settingsChanged

    property string type: "e5"
    property string sort: "price"
    property int radius: 5

    onActiveChanged: {
        if (!active)
            settingsChanged()
    }


    Column {
        anchors.fill: parent
        anchors.margins: units.gu(2)

        spacing: units.gu(4)

        OptionSelector {
            id: typeSelector
            text: i18n.tr("Fuel type")
            delegate: Component {
                OptionSelectorDelegate {
                    text: i18n.tr(label)
                    objectName: name
                }
            }
            model: ListModel {
                ListElement { name: "e5"; label: "e5" }
                ListElement { name: "e10"; label: "e10" }
                ListElement { name: "diesel"; label: "diesel" }
            }
            selectedIndex: decodeSelIdx(type);
            onSelectedIndexChanged: {
                type = model.get(selectedIndex).name
            }

            function decodeSelIdx(key) {
                if (key=="e5") return 0;
                if (key=="e10") return 1;
                if (key=="diesel") return 2;
                return 0;
            }
        }

        Column {
            width:parent.width
            Label {
                text: i18n.tr("Radius")
            }

            Slider {
                id: radiusSelector
                function formatValue(v) { return v.toFixed(0) + " km" }
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
            delegate: Component {
                OptionSelectorDelegate {
                    text: i18n.tr(label)
                    objectName: name
                }
            }
            model: ListModel {
                ListElement { name: "price"; label: "price" }
                ListElement { name: "dist"; label: "distance" }
            }
            selectedIndex: decodeSelIdx(sort);
            onSelectedIndexChanged: {
                sort = model.get(selectedIndex).name
            }

            function decodeSelIdx(key) {
                if (key=="price") return 0;
                if (key=="dist") return 1;
                return 0;
            }
        }
    }
}
