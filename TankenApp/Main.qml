import QtQuick 2.4
import Ubuntu.Components 1.3
import QtPositioning 5.4
import Ubuntu.Layouts 1.0
import Ubuntu.Components.Popups 1.3
import "helper.js" as Helper;

import Ubuntu.Connectivity 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.derjasper.tankenapp"

    automaticOrientation: true

    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(75)

    TankenSettings {
        id: settings
    }


    PositionSource {
        id: positionSrc
        updateInterval: 10000
        active: false
    }

    PageStack {
        id: pageStack

        Component.onCompleted: {
            if (!settings.firstStart) {
                push(main)
                main.refreshList();
            }
            else {
                push(main)
                main.refreshList();
                push(apiPage)
                settings.firstStart = false;
            }
        }

        Page {
            id: main

            StationListApi {
                id: stationModel
                api: settings.api
                type: settings.type
                sort: settings.sort
                rad: settings.rad
                lat: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.latitude : settings.lat
                lng: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.longitude : settings.lng

            }

            function refreshList() {
                if (settings.lat==0 && settings.lng==0) {
                    positionSrc.update();
                }

                stationModel.refresh();
            }

            flickable: layouts.currentLayout == "mobile" ? list : null

            title: i18n.tr("Gas Stations")

            head {
                actions: [
                    Action {
                        iconName: "reload"
                        text: i18n.tr("Reload")
                        onTriggered: {
                            main.refreshList();
                        }
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
                        iconName: "info"
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
                        text: Helper.fuelKeyToString(settings.api,settings.type) + ", "+(settings.rad+"").split(".")[0]+" "+stationModel.apiProps.unit.distance+", "+i18n.tr("sort by %1").arg(Helper.sortKeyToString(settings.sort))
                    }
                }
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

                    UbuntuListView { // TODO tablet mode bug
                        id: list
                        anchors.fill: parent
                        model: stationModel.model
                        clip: layouts.currentLayout !="mobile"

                        pullToRefresh {
                            enabled: true
                            refreshing: stationModel.loading
                            onRefresh: {
                                main.refreshList()
                            }
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
                                            text: (lastUpdate !="null" ? dist + " " + dist_unit : "") + " " + (isOpen != "null" ? (isOpen == "true" ? i18n.tr("open") : i18n.tr("closed")):"")
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
                        visible : stationModel.model.count == 0 && !stationModel.loading && NetworkingStatus.online
                        text: i18n.tr("no results")
                        anchors.centerIn: parent
                    }
                    Text {
                        visible: stationModel.model.count == 0 && !stationModel.loading && !NetworkingStatus.online
                        text: i18n.tr("no Internet connection")
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
                    centerLatitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.latitude : settings.lat
                    centerLongitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.longitude : settings.lng

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
                centerLatitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.latitude : settings.lat
                centerLongitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.longitude : settings.lng

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

            api: settings.api

            onSettingsChanged: {
                settings.type = type
                settings.rad = radius
                settings.sort = sort

                main.refreshList()
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

                main.refreshList()
            }
        }
        ApiPage {
            id: apiPage
            visible: false

            onSetApi: {
                settings.api = api

                main.refreshList()
            }
        }

        AboutPage {
            id: aboutPage
            visible: false
        }


    }


}

