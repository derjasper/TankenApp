import QtQuick 2.0
import QtLocation 5.5

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
            preferred:["osm"]
        }

        MapItemView {
            model: root.model
            delegate: MapQuickItem {
                anchorPoint.x: 14
                anchorPoint.y: 50
                sourceItem: MouseArea {
                    width: 28
                    height: 50

                    Image {
                        width: 28
                        height: 50
                        source: "marker.png"
                    }

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

