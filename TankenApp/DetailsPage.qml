import QtQuick 2.0
import Ubuntu.Components 1.3
 import Ubuntu.Layouts 1.0
import QtLocation 5.5
import QtQuick.Layouts 1.1
import "helper.js" as Helper

Page {
    header: PageHeader {
        id: header
        title: i18n.tr("Details")
        flickable: content
    }

    property string stationId: ""
    property string api: ""

    StationDetailsApi {
        id: stationDetails
        stationId: details.stationId
        api: details.api

        onModelChanged: {
            if (stationId!="" && !stationDetails.err)
                details.header.title = (stationDetails.model.brand!="null") ? stationDetails.model.brand : stationDetails.model.name

            if (stationDetails.err)
                details.header.title = i18n.tr("Details")
        }
    }

    onStationIdChanged: {
        details.header.title = i18n.tr("Details")
    }

    Label {
        text: i18n.tr("An error occurred.")
        anchors.centerIn: parent
        visible: stationDetails.err
    }

    ActivityIndicator {
        running: stationDetails.loading
        anchors.centerIn: parent
    }

    Label {
        text: i18n.tr("An error occurred.")
        anchors.centerIn: parent
        visible: stationDetails.err
    }

    ActivityIndicator {
        running: stationDetails.loading
        anchors.centerIn: parent
    }

    Flickable {
        visible: !stationDetails.loading && !stationDetails.err

        id: content
        anchors.fill: parent
        contentHeight: col.height + units.gu(2)*2

        clip: true


        Column {
            id: col
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }

            spacing: units.gu(2)

            Flow {
                width:parent.width
                anchors.margins: 10
                spacing: 40

                Repeater {
                    model: stationDetails.model.fuel

                    Column {
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            Label {
                                text: modelData.price != "null" ? modelData.price : "N/A"
                                fontSize:"x-large"
                            }
                            Label {
                                text: modelData.price_currency
                                fontSize:"x-small"
                            }
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Helper.fuelKeyToString(api,modelData.type)
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
                    visible: stationDetails.model.isOpen != "null"
                    text: (stationDetails.model.isOpen == "true" ? i18n.tr("open") : i18n.tr("closed"))
                }
                Repeater {
                    visible: stationDetails.model.openingTimes != "null"
                    model: stationDetails.model.openingTimes
                    Label {
                        text: modelData.text + (modelData.start != "null" && modelData.end != "null" ? (": "+modelData.start+" - "+modelData.end) : "")
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
                maximumZoomLevel: zoomLevel
                minimumZoomLevel: zoomLevel
                zoomLevel: 18

                gesture.enabled: false


                plugin: Plugin {
                    name: "osm"
                    PluginParameter { name: "osm.mapping.host"; value: "http://c.tile.thunderforest.com/neighbourhood/" }
                    PluginParameter { name: "osm.mapping.copyright"; value: "Maps &copy; Thunderforest<br>Data &copy; OpenStreetMap contributors" }
                }

                activeMapType: supportedMapTypes["7"]

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

            Column {
                Label {
                    visible: stationDetails.model.name !="null"
                    text: stationDetails.model.name+""
                    fontSize: "large"
                }
                Label {
                    visible: stationDetails.model.brand !="null"
                    text: stationDetails.model.brand+""
                }
                Label {
                    visible: stationDetails.model.address !="null"
                    text: stationDetails.model.address+""
                    fontSize: "small"
                }
                Label {
                    visible: stationDetails.model.postCode != "null" || stationDetails.model.place != "null"
                    text: (stationDetails.model.postCode != "null" ? stationDetails.model.postCode : "") + " " + (stationDetails.model.place != "null" ? stationDetails.model.place : "")
                    fontSize: "small"
                }
            }

            Row {
               anchors.right: parent.right
               spacing: units.gu(1)

               Button {
                   text: i18n.tr("Navigate")
                   color: UbuntuColors.warmGrey
                   onClicked: {
                       Qt.openUrlExternally("geo:"+stationDetails.model.lat+","+stationDetails.model.lng);
                   }
               }

               Button {
                   text: i18n.tr("Navigate with HERE")
                   strokeColor: UbuntuColors.warmGrey
                   onClicked: {
                       Qt.openUrlExternally("https://www.here.com/directions/drive//:"+stationDetails.model.lat+","+stationDetails.model.lng+"?map="+stationDetails.model.lat+","+stationDetails.model.lng+",14,traffic");
                   }
               }
            }
        }
    }
}
