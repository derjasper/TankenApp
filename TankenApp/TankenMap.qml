import QtQuick 2.0
import QtLocation 5.4
import Ubuntu.Components 1.3

Item {
    id: root
    property var model
    property var centerLatitude
    property var centerLongitude

    signal markerClicked(var currentId)

    Map {
        id: map
        anchors.fill: parent
        center {
            latitude: root.centerLatitude
            longitude: root.centerLongitude
        }

        zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
        gesture.enabled: true
        gesture.flickDeceleration: 3000

        plugin: Plugin {
            name: "osm"
            //PluginParameter { name: "osm.mapping.host"; value: "http://c.tile.thunderforest.com/neighbourhood/" }
            //PluginParameter { name: "osm.mapping.copyright"; value: "Maps &copy; Thunderforest<br>Data &copy; OpenStreetMap contributors" }
        }

        activeMapType: supportedMapTypes["7"]

        MapItemView {
            model: root.model
            delegate: MapQuickItem {
                anchorPoint.x: 10
                anchorPoint.y: 64
                sourceItem: MouseArea {
                    width: units.gu(12)
                    height: 74

                    Rectangle {
                        id: rect

                        width: parent.width
                        height: 64

                        color: "white"
                        border.width: 2
                        border.color: "black"

                        Column {
                            width: parent.width - 8
                            height: parent.height - 8
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 4
                            anchors.leftMargin: 4

                            Row {
                                Label {
                                    text: price != "null" ? price : "N/A"
                                    fontSize:"x-large"
                                }

                                Label {
                                    text: price_currency
                                    fontSize:"x-small"
                                }
                            }

                            Label {
                                text: lastUpdate !="null" ? Helper.renderLastUpdate(lastUpdate) : dist + " " + dist_unit
                            }
                        }
                    }

                    Image {
                        anchors.top: rect.bottom
                        width: 20
                        height: 10
                        source: "marker_arrow.png"
                    }

                    /*Icon {

                        name: "location-active"
                        color: UbuntuColors.blue
                    }*/

                    onClicked: {
                        markerClicked(id);
                    }
                }

                coordinate {
                    latitude: lat
                    longitude: lng
                }
            }

            autoFitViewport: true

        }
    }
}
