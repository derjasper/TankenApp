import QtQuick 2.0
import Ubuntu.Components 1.2
import QtLocation 5.3

Page {
    title: i18n.tr("Select Location")

    signal setCoord(double lat,double lng)

    head.contents: Row {
        width: parent.width
        spacing: units.gu(2)

        TextField {
            id: inputText
            placeholderText: i18n.tr("Enter a location")
            width: parent.width - button.width - units.gu(2)
        }

        Button {
            id: button
            text: i18n.tr("Search")
            color: UbuntuColors.orange
            onClicked: geocodeModel.update()
        }
    }


    head.actions: [
        Action {
            iconName: "gps"
            name: i18n.tr("Current Location")
            onTriggered: {
                setCoord(0,0)
                pageStack.pop()
            }
        }

    ]

    GeocodeModel {
        id: geocodeModel
        plugin: Plugin {
            preferred:["osm"]
        }
        autoUpdate: false
        query: inputText.text
    }

    ActivityIndicator {
        id: activity
        visible: geocodeModel.status == GeocodeModel.Loading
        anchors.centerIn: parent
    }

    ListView {
        anchors.fill: parent

        visible: geocodeModel.status == GeocodeModel.Ready

        model: geocodeModel
        delegate: ListItem {
            Label {
                text: locationData.address.text
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: units.gu(2)
            }

            onClicked: {
                setCoord(locationData.coordinate.latitude,locationData.coordinate.longitude)

                pageStack.pop()
            }
        }
    }


}
