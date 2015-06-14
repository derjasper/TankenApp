import QtQuick 2.0
import Ubuntu.Components 1.2
import QtLocation 5.3

Page {
    title: i18n.tr("Details")
    visible: false

    property string stationId: ""

    StationDetails {
        id: stationDetails
        stationId: details.stationId

        onModelChanged: {
            if (stationId!="") details.title = (stationDetails.model.brand!="") ? stationDetails.model.brand : stationDetails.model.name
        }
    }

    Flickable {
        id: content
        anchors.fill: parent
        contentHeight: col.height

        Column {
            id: col
            width: parent.width - units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: units.gu(2)

            Row {
                width:parent.width

                Column {
                    width:parent.width/3
                    anchors.margins: units.gu(2)

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: stationDetails.model.e5!= null ? stationDetails.model.e5 : "-"
                        fontSize:"x-large"
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: i18n.tr("e5")
                    }
                }
                Column {
                    width:parent.width/3
                    anchors.margins: units.gu(2)

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: stationDetails.model.e10!= null ? stationDetails.model.e10 : "-"
                        fontSize:"x-large"
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: i18n.tr("e10")
                    }
                }
                Column {
                    width:parent.width/3
                    anchors.margins: units.gu(2)

                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: stationDetails.model.diesel!= null ? stationDetails.model.diesel : "-"
                        fontSize:"x-large"
                    }
                    Label {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: i18n.tr("diesel")
                    }
                }
            }

            Column {
                Label {
                    text: (stationDetails.model.isOpen ? i18n.tr("open") : i18n.tr("closed"))
                }
                Repeater {
                    model: stationDetails.model.openingTimes
                    Label {
                        text: modelData.text+": "+modelData.start+" - "+modelData.end
                    }
                }
            }

            Map {
                width: parent.width
                height:units.gu(30)

                center {
                    latitude: stationDetails.model.lat != undefined ? stationDetails.model.lat : 0.0
                    longitude: stationDetails.model.lng != undefined ? stationDetails.model.lng : 0.0
                }
                zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2

                gesture.enabled: false

                plugin: Plugin {
                    preferred:["osm"]
                }

                MapQuickItem {
                    anchorPoint.x: 14
                    anchorPoint.y: 50
                    sourceItem: Image {
                        width: 28
                        height: 50
                        source: "marker.png"
                    }

                    coordinate {
                        latitude: stationDetails.model.lat != undefined ? stationDetails.model.lat : 0.0
                        longitude: stationDetails.model.lng != undefined ? stationDetails.model.lng : 0.0
                    }

                }
            }

            Row {
                Button {
                    text: i18n.tr("Navigate with HERE")
                    color: UbuntuColors.orange
                    onClicked: {
                        Qt.openUrlExternally("https://www.here.com/directions/drive//:"+stationDetails.model.lat+","+stationDetails.model.lng+"?map="+stationDetails.model.lat+","+stationDetails.model.lng+",14,traffic");
                    }
                }
            }


            Column {
                Label {
                    text: stationDetails.model.name+""
                    fontSize: "large"
                }
                Label {
                    text: stationDetails.model.brand+""
                }
                Label {
                    text: stationDetails.model.street + (stationDetails.model.houseNumber==undefined ? "" : " "+stationDetails.model.houseNumber )
                    fontSize: "small"
                }
                Label {
                    text: stationDetails.model.postCode + " " + stationDetails.model.place
                    fontSize: "small"
                }
            }

        }

    }
}
