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
            PluginParameter { name: "osm.mapping.host"; value: "http://c.tile.thunderforest.com/neighbourhood/" }
            PluginParameter { name: "osm.mapping.copyright"; value: "Maps &copy; Thunderforest<br>Data &copy; OpenStreetMap contributors" }
        }

        activeMapType: supportedMapTypes["7"]

        MapItemView {
            model: root.model
            delegate: MapQuickItem {
                anchorPoint.x: 32
                anchorPoint.y: 64
                sourceItem: MouseArea {
                    width: units.gu(12)
                    height: 64
                    
                    UbuntuShape {
                        anchors.fill: parent
                        backgroundColor: "white"



                        Column {
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

                            width: parent.width
                            height: parent.height
                        }
                    }

                    /*Icon {
                        width: 64
                        height: 64
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
