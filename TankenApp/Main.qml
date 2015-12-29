import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import QtPositioning 5.4
import Ubuntu.Layouts 1.0
import Ubuntu.Components.Popups 1.3

import Ubuntu.Components.ListItems 1.3 as ListItems
import "helper.js" as Helper;

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.derjasper.tankenapp"

    automaticOrientation: true

    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(75)

    StationListApi {
        id: stationModel
        api: settings.api
    }

    Settings {
        id: settings
        property string type: "e5"
        property string sort: "price"
        property string rad: "5"
        property double lat: 0
        property double lng: 0
        property string api: "tankerkoenig"
    }


    PositionSource {
        id: positionSrc
        updateInterval: 10000
        active: false
    }

    PageStack { // TODO redesign
        // TODO filter + location + api auf eine seite?

        id: pageStack

        Component.onCompleted: {
            push(main)

            refreshList();
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

        Page {
            id: main

            flickable: layouts.currentLayout == "mobile" ? list : null

            title: i18n.tr("Gas Stations")

            head { // TODO settings mergen
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
                    },
                    Action {
                        iconName: "settings"
                        text: i18n.tr("Select Source")
                        onTriggered: pageStack.push(apiPage)
                    },
                    Action {
                        iconName: "torch-off"
                        text: i18n.tr("About")
                        onTriggered: pageStack.push(aboutPage)
                    }
                ]
                contents: Column {
                    Label {
                        text: main.title
                        fontSize:"large"
                    }
                    Label {
                        text: i18n.tr(settings.type) + ", "+settings.rad.split(".")[0]+" "+stationModel.apiProps.unit.distance+", sort by " + i18n.tr(settings.sort)
                    }
                }
            }

            Layouts {
                id: layouts
                anchors.fill: parent
                layouts: [
                    ConditionalLayout {
                        name: "tablet"
                        when: layouts.width > units.gu(60)
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
                        when: layouts.width <= units.gu(60)

                        ItemLayout {
                            item: "details"
                            anchors.fill: parent
                        }
                    }
                ]

                Item {
                    Layouts.item: "details"

                    UbuntuListView {
                        id: list
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
                                    Row {
                                        Label {
                                            text: price
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

                                    width:units.gu(12)
                                    height: parent.height
                                }

                                Column {
                                    Row {
                                        Label {
                                            text: (brand!="null") ? brand : name
                                            fontSize: "large"

                                        }

                                        Label {
                                            text: lastUpdate !="null" ? dist + " " + dist_unit : ""
                                        }

                                        spacing: units.gu(2)
                                    }

                                    Label {
                                        text: address + ", " + (postCode != "null" ? postCode + " " : "") + place
                                        fontSize: "small"
                                    }

                                }
                            }

                            onClicked: {
                                pageStack.push(details,{stationId: id});
                            }
                        }

                        visible : stationModel.model.count > 0 || stationModel.loading
                    }
                    Text{
                        visible : stationModel.model.count == 0 && !stationModel.loading
                        text: i18n.tr("no results")
                        anchors.centerIn: parent
                    }

                    BottomEdgeHint {
                        visible: layouts.currentLayout == "mobile"
                        id: bottomEdgeHint
                        text: i18n.tr("Map")
                        onClicked: pageStack.push(mapPage)
                    }
                }

                TankenMap {
                    Layouts.item: "map"

                    anchors.fill:parent

                    model: stationModel.model
                    centerLatitude: settings.lat
                    centerLongitude: settings.lng

                    onMarkerClicked: {
                        pageStack.push(details,{stationId: currentId})
                    }
                }
            }
        }

        Page {
            id: mapPage
            visible: false
            title: i18n.tr("Map")

            TankenMap {
                anchors.fill:parent

                model: stationModel.model
                centerLatitude: settings.lat
                centerLongitude: settings.lng

                onMarkerClicked: {
                    pageStack.push(details,{stationId: currentId})
                }
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
            api: settings.api
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
        ApiPage {
            id: apiPage
            visible: false

            onSetApi: {
                settings.api = api

                pageStack.refreshList()
            }
        }

        AboutPage {
            id: aboutPage
            visible: false
        }


    }


}

