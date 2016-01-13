import QtQuick 2.0
import Ubuntu.Components 1.3
 import Ubuntu.Layouts 1.0
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
            if (stationId!="" && !stationDetails.err)
                details.title = (stationDetails.model.brand!="null") ? stationDetails.model.brand : stationDetails.model.name

            if (stationDetails.err)
                details.title = i18n.tr("Details")
        }
    }

    onStationIdChanged: {
        details.title = i18n.tr("Details")
    }

    Layouts {
        id: layouts
        anchors.fill: parent
        layouts: [
            ConditionalLayout {
                name: "tablet"
                when: layouts.width > units.gu(100)
                Flow {
                    anchors.fill: parent
                    flow: Flow.LeftToRight
                    ItemLayout {
                        item: "details"
                        width: units.gu(60)
                        height: parent.height
                    }
                    ItemLayout {
                        item: "map"
                        width: parent.width - units.gu(60)
                        height: parent.height
                    }
                }
            },
            ConditionalLayout {
                name: "mobile"
                when: layouts.width <= units.gu(100)

                ItemLayout {
                    item: "details"
                    anchors.fill: parent
                }
            }
        ]
        Item {
            Layouts.item: "details"

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
                                    text: Helper.fuelKeyToString(modelData.type)
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
                                text: modelData.text+": "+modelData.start+" - "+modelData.end
                            }
                        }
                    }

                    Map {
                        visible: layouts.currentLayout === "mobile"

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
                               Qt.openUrlExternally("geo://"+stationDetails.model.lat+","+stationDetails.model.lng);
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



        Map {
            Layouts.item: "map"

            anchors.fill: parent

            center {
                latitude: stationDetails.model.lat != undefined ? stationDetails.model.lat : 0.0
                longitude: stationDetails.model.lng != undefined ? stationDetails.model.lng : 0.0
            }

            zoomLevel: (maximumZoomLevel - minimumZoomLevel) / 1.1

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
    }


}
