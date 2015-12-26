import QtQuick 2.0
import Ubuntu.Components 1.2
import QtLocation 5.3
import QtQuick.Layouts 1.1
import "helper.js" as Helper

Page {
    title: i18n.tr("Details")

    property string stationId: ""
    property string api: ""

    StationDetailsApi {
        id: stationDetails
        stationId: details.stationId
        api: details.api

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

            GridLayout {
                width:parent.width
                columns: 3

                Repeater {
                    model: stationDetails.model.fuel

                    Column {
                        anchors.margins: units.gu(2)

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Label {
                                text: modelData.price
                                fontSize:"x-large"
                            }
                            Label {
                                text: modelData.price_currency
                                fontSize:"x-small"
                            }
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: i18n.tr(modelData.type)
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.lastUpdate !="null" ? Helper.renderLastUpdate(modelData.lastUpdate) : ""
                        }
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
                    text: stationDetails.model.address+""
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
