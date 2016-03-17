import QtQuick 2.0
import Ubuntu.Components 1.3

import "api/apiindex.js" as Api


Page {
    title: i18n.tr("About")
    head.sections.model: [i18n.tr("About"), i18n.tr("Data Sources")]

    VisualItemModel {
        id: tabs

        Item {
            width: tabView.width
            height: tabView.height

            Flickable {
                clip: true
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick

                contentWidth: width
                contentHeight: column1.height + units.gu(2)

                Column {
                    id: column1

                    spacing: units.gu(2)

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: units.gu(2)
                    }

                    UbuntuShape {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Image {
                            source: "TankenApp.png"
                        }
                        width:100
                        height:100
                        radius:"medium"
                    }

                    Text {
                        text: "TankenApp"
                        font.pointSize: 18
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }
                    Text {
                        text: i18n.tr("Real-time fuel prices") + "\n" + i18n.tr("No warranty for correct prices and availability.")
                        wrapMode:Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }

                    Text {
                        text: i18n.tr("For bug reports, pull requests and information on how to translate, please go to the GitHub project.")
                        wrapMode:Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }
                    Button {
                        text: i18n.tr("TankenApp on GitHub")
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: UbuntuColors.orange
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/derjasper/TankenApp");
                        }
                    }

                    Text {
                        text: i18n.tr("I would appreciate a donation if you like this app.")
                        wrapMode:Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }
                    Button {
                        text: i18n.tr("Donate via PayPal")
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: UbuntuColors.orange
                        onClicked: {
                            Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=52XD8L5GZPPNW");
                        }
                    }

                    Text {
                        text: "(c) Jasper Nalbach\n" + i18n.tr("Licensed under GPLv3. Source code available at:") + "\n" + "https://github.com/derjasper/TankenApp"
                        wrapMode:Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }

                    Text {
                        text: i18n.tr("Translations: ") + "\n" + "Anne017 (fr)"
                        wrapMode:Text.WordWrap
                        horizontalAlignment:Text.AlignHCenter
                        width:parent.width
                    }
                }
            }
        }

        Item {
            width: tabView.width
            height: tabView.height

            Flickable {
                clip: true
                anchors.fill: parent
                flickableDirection: Flickable.VerticalFlick

                contentWidth: width
                contentHeight: column2.height + units.gu(2)

                Column {
                    id: column2

                    spacing: units.gu(2)

                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: units.gu(2)
                    }

                    ListModel { id: jsonModel }

                    Component.onCompleted: {
                        Api.apiindex.forEach(function(val) {
                            jsonModel.append(val);
                        });
                    }

                    Label {
                        text: i18n.tr("TankenApp is made possible by these data sources:")
                        wrapMode: Text.WordWrap
                        width:parent.width
                    }

                    Repeater {
                        model: jsonModel
                        delegate: Column {
                            Label {
                                id: lname
                                text: name
                                wrapMode: Text.WordWrap
                                width:column2.width
                            }

                            Label {
                                id: llicense
                                text: license
                                wrapMode: Text.WordWrap
                                fontSize: "small"
                                width:column2.width
                            }
                        }

                    }

                }
            }
        }
    }

    ListView {
        id: tabView
        model: tabs
        interactive: false
        anchors.fill: parent
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        currentIndex: aboutPage.head.sections.selectedIndex
        highlightMoveDuration: UbuntuAnimation.SlowDuration
    }
}
