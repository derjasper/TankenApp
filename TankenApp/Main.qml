import QtQuick 2.4
import Ubuntu.Components 1.3
import QtPositioning 5.4
import Ubuntu.Layouts 1.0
import Ubuntu.Components.Popups 1.3
import "helper.js" as Helper
import "api/api.js" as Api

// TODO fix openstreetmap

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.derjasper.tankenapp"

    automaticOrientation: true

    anchorToKeyboard: true

    width: units.gu(150)
    height: units.gu(75)

    TankenSettings {
        id: settings
    }

    PositionSource {
        id: positionSrc
        updateInterval: 10000
        active: false
    }

    AdaptivePageLayout {
        id: pageStack

        anchors.fill: parent
        primaryPage: main

        layouts:[
            PageColumnsLayout {
                id: smallLayout

                when: pageStack.width <= units.gu(100)

                PageColumn {
                    fillWidth: true
                }

                onWhenChanged: {
                    if (when) {
                        if (details.active) {
                            pageStack.removePages(mapPage)
                            pageStack.addPageToNextColumn(main, details)
                        }
                        else if (mapPage.active) {
                            pageStack.removePages(mapPage)
                        }
                    }
                }
            },

            PageColumnsLayout {
                id: mediumLayout
                when: pageStack.width > units.gu(100)

                PageColumn {
                    minimumWidth: units.gu(30)
                    maximumWidth: pageStack.width
                    preferredWidth: units.gu(50)
                }

                PageColumn {
                    fillWidth: true
                }

                onWhenChanged: {
                    if (when) {
                        if (details.active) {
                            pageStack.addPageToNextColumn(main, mapPage)
                            pageStack.addPageToNextColumn(mapPage, details)
                        }
                        else if (main.active) {
                            pageStack.addPageToNextColumn(main, mapPage)
                        }
                    }
                }
            }
        ]

        Component.onCompleted: {
            if (settings.firstStart) {
                settings.firstStart = false
                pageStack.addPageToCurrentColumn(main, apiPage)
            }

            main.refreshList()
        }

        function showDetailPage (stationId) {
            if (mapPage.active || details.active) {
                pageStack.addPageToNextColumn(mapPage, details, {stationId: stationId})
            }
            else {
                pageStack.addPageToNextColumn(main, details, {stationId: stationId})
            }
        }

        Page {
            id: main

            onActiveChanged: {
                if (active) {
                    if (!smallLayout.when && !mapPage.active && !details.active) {
                        pageStack.addPageToNextColumn(main, mapPage)
                    }
                }
            }

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

            header: PageHeader {
                id: header
                title: i18n.tr("Service Stations")

                contents: Column {
                    Label {
                        text: header.title
                        fontSize: "large"
                    }
                    Label {
                        text: Helper.fuelKeyToString(settings.api,settings.type) + ", "+(settings.rad+"").split(".")[0]+" "+stationModel.apiProps.unit.distance
                    }

                    anchors.verticalCenter: parent.verticalCenter
                }

                trailingActionBar {
                    actions: [
                        Action {
                            iconName: "stock_website"
                            text: i18n.tr("Show on Map")
                            visible: smallLayout.when
                            onTriggered: {
                                pageStack.addPageToNextColumn(main, mapPage)
                            }
                        },
                        Action {
                            iconName: "reload"
                            text: i18n.tr("Reload")
                            onTriggered: {
                                main.refreshList();
                            }
                        },
                        Action {
                            iconName: "filter"
                            text: i18n.tr("Filter")
                            onTriggered: pageStack.addPageToCurrentColumn(main,filter)
                        },
                        Action {
                            iconName: "location"
                            text: i18n.tr("Select Location")
                            onTriggered: pageStack.addPageToCurrentColumn(main,locationPage)
                        },
                        Action {
                            iconName: "settings"
                            text: i18n.tr("Select Source")
                            onTriggered: pageStack.addPageToCurrentColumn(main,apiPage)
                        },
                        Action {
                            iconName: "info"
                            text: i18n.tr("About")
                            onTriggered: pageStack.addPageToCurrentColumn(main,aboutPage)
                        }
                    ]
                }

                extension: Sections {
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        bottom: parent.bottom
                    }

                    model: makeModel(Api.apisettings[settings.api].features.sort)
                    onSelectedIndexChanged: {
                        settings.sort = indexToKey(selectedIndex)
                        main.refreshList()
                    }
                    onModelChanged: {
                        selectedIndex = keyToIndex(settings.sort)
                    }
                    Component.onCompleted: {
                        selectedIndex = keyToIndex(settings.sort)
                    }

                    function keyToIndex(key) {
                        for (var i=0; i<Api.apisettings[settings.api].features.sort.length; i++) {
                            if (Api.apisettings[settings.api].features.sort[i] == key)
                                return i;
                        }

                        return 0;
                    }

                    function indexToKey(idx) {
                        if (Api.apisettings[settings.api].features.sort.length<=idx)
                            return 0;
                        return Api.apisettings[settings.api].features.sort[idx];
                    }

                    function makeModel(list) {
                        var model = [];

                        for (var i=0; i<list.length; i++) {
                            model.push(Helper.sortKeyToString(list[i]));
                        }

                        return model;
                    }
                }

                flickable: list
            }

            UbuntuListView {
                id: list
                anchors.fill: parent
                model: stationModel.model

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
                        pageStack.showDetailPage(id)
                    }
                }

                visible : stationModel.model.count > 0 || stationModel.loading
            }
            Text{
                visible : stationModel.model.count == 0 && !stationModel.loading
                text: i18n.tr("No results found. Please check your Internet connection or set another data source.")
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Page {
            id: mapPage

            header: PageHeader {
                exposed: smallLayout.when

                title: i18n.tr("Map")
            }

            TankenMap {
                anchors.fill:parent

                model: stationModel.model
                centerLatitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.latitude : settings.lat
                centerLongitude: (settings.lat==0 && settings.lng==0) ? positionSrc.position.coordinate.longitude : settings.lng

                onMarkerClicked: {
                    pageStack.showDetailPage(currentId)
                }
            }
        }

        SettingsPage {
            id: filter

            type: settings.type
            radius: settings.rad

            api: settings.api

            onSettingsChanged: {
                settings.type = type
                settings.rad = radius

                main.refreshList()
            }
        }

        DetailsPage {
            id: details
            api: settings.api
        }

        LocationPage {
            id: locationPage

            onSetCoord: {
                settings.lat = lat
                settings.lng = lng

                main.refreshList()
            }
        }
        ApiPage {
            id: apiPage

            onSetApi: {
                settings.api = api

                main.refreshList()
            }
        }

        AboutPage {
            id: aboutPage
        }
    }
}
