import QtQuick 2.0
import Ubuntu.Components 1.2
import Qt.labs.settings 1.0
import QtPositioning 5.2
import QtLocation 5.3

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.derjasper.tankenapp"

    automaticOrientation: true

    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(75)

    PageStack {
        id: pageStack

        Component.onCompleted: {
            push(main)

            refreshList();
        }

        StationListApi {
            id: stationModel
        }

        Settings {
            id: settings
            property string type: "e5"
            property string sort: "price"
            property string rad: "5"
            property double lat: 0
            property double lng: 0
        }


        PositionSource {
            id: positionSrc
            updateInterval: 10000
            active: false
        }

        function refreshList() {
            if (settings.lat==0 && settings.lng==0) {
                positionSrc.update();
            }

            stationModel.type= settings.type
            stationModel.sort= settings.sort
            stationModel.rad= settings.rad
            stationModel.lat= (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.latitude : settings.lat
            stationModel.lng= (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.longitude : settings.lng

            stationModel.refresh();
        }

        Tabs {
            id: main

            Tab {
                id: list
                title: i18n.tr("List")
                page: Page {
                    title: i18n.tr("Gas Stations")

                    head {
                        actions: [
                            Action {
                                iconName: "reload"
                                text: i18n.tr("Reload")
                                onTriggered: stationModel.refresh()
                            },
                            Action {
                                iconName: "settings"
                                text: i18n.tr("Filter")
                                onTriggered: pageStack.push(filter)
                            },
                            Action {
                                iconName: "location"
                                text: i18n.tr("Select Location")
                                onTriggered: pageStack.push(locationPage)
                            }
                        ]
                        contents: Column {
                            Label {
                                text: main.currentPage.title
                                fontSize:"large"
                            }
                            Label {
                                text: i18n.tr(settings.type) + ", "+settings.rad.split(".")[0]+" km, sort by " + i18n.tr(settings.sort)
                            }
                        }
                    }

                    ListView {
                        anchors.fill: parent
                        model: stationModel.model

                        PullToRefresh {
                            refreshing: stationModel.loading
                            onRefresh: stationModel.refresh()
                        }

                        delegate: ListItem {
                            contentItem.anchors {
                                    leftMargin: units.gu(2)
                                    rightMargin: units.gu(2)
                                    topMargin: units.gu(0.5)
                                    bottomMargin: units.gu(0.5)
                                }

                            Row {
                                Column {
                                    Label {
                                        text: price
                                        fontSize:"x-large"
                                    }

                                    Label {
                                        text: dist + " km"
                                    }

                                    width:units.gu(10)
                                    height: parent.height
                                }

                                Column {
                                    Label {
                                        text: (brand!="") ? brand : name
                                        fontSize: "large"

                                    }

                                    Label {
                                        text: street + (houseNumber==undefined ? "" : " "+houseNumber ) + ", " + postCode + " " + place
                                        fontSize: "small"
                                    }

                                }
                            }

                            onClicked: {
                                pageStack.push(details,{stationId: id});
                            }
                        }

                        visible : stationModel.model.count > 0
                    }
                    Text{
                         visible : stationModel.model.count == 0
                         text: i18n.tr("no results")
                         anchors.centerIn: parent
                    }

                }
            }

            Tab {
                id: mapTab
                title: i18n.tr("Map")
                page: Page {
                    title: i18n.tr("Map")

                    head {
                        actions: [
                            Action {
                                iconName: "reload"
                                text: i18n.tr("Reload")
                                onTriggered: stationModel.refresh()
                            },
                            Action {
                                iconName: "settings"
                                text: i18n.tr("Filter")
                                onTriggered: pageStack.push(filter)
                            },
                            Action {
                                iconName: "location"
                                text: i18n.tr("Select Location")
                                onTriggered: pageStack.push(locationPage)
                            }
                        ]
                        contents: Column {
                            Label {
                                text: main.currentPage.title
                                fontSize:"large"
                            }
                            Label {
                                text: i18n.tr(settings.type) + ", "+settings.rad.split(".")[0]+" km"
                            }
                        }
                    }

                    Map {
                        id: map
                        anchors.fill: parent

                        center {
                            latitude: positionSrc.position.coordinate.latitude
                            longitude: positionSrc.position.coordinate.longitude
                        }
                        zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
                        gesture.enabled: true
                        gesture.flickDeceleration: 3000

                        plugin: Plugin {
                            preferred:["osm"]
                        }

                        MapItemView {
                            model: stationModel.model
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
                                        pageStack.push(details,{stationId: id})
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
            }

            Tab {
                id: about
                title: i18n.tr("About")
                page: AboutPage {}
            }

        }

        SettingsPage {
            id: filter
            visible: false

            type: settings.type
            radius: settings.rad
            sort: settings.sort

            onSettingsChanged: {
                settings.type = type
                settings.rad = radius
                settings.sort = sort

                pageStack.refreshList()
            }
        }

        DetailsPage {
            id: details
            visible: false
        }

        LocationPage {
            id: locationPage
            visible: false

            onSetCoord: {
                settings.lat = lat
                settings.lng = lng

                pageStack.refreshList()
            }
        }


    }


}

