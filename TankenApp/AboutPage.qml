import QtQuick 2.0
import Ubuntu.Components 1.3

import "api/apiindex.js" as Api


Page {
    id: aboutPage

    header: PageHeader {
        title: i18n.tr("About")
        flickable: content
    }

    Flickable {
        id: content
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick

        contentWidth: width
        contentHeight: column.height + units.gu(2)

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: units.gu(2)
            }

            Column {
                spacing: units.gu(2)
                width: parent.width

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
                    text: "© " + i18n.tr("TankenApp Contributors") + "\n" + i18n.tr("Licensed under GPLv3. Source code available at:") + "\n" + "https://github.com/derjasper/TankenApp"
                    wrapMode:Text.WordWrap
                    horizontalAlignment:Text.AlignHCenter
                    width:parent.width
                }
            }

            Text {
                text: " "
            }


            // Contributors

            ListItem {
                height: layout0.height + divider.height
                ListItemLayout {
                    id: layout0
                    title.text: i18n.tr("Contributors")
                    title.font.bold: true
                }
            }

            ListItem {
                height: layout01.height + divider.height
                ListItemLayout {
                    id: layout01
                    title.text: "Jasper Nalbach (main developer)"
                }
                onClicked: {
                    Qt.openUrlExternally("https://github.com/derjasper")
                }
            }

            ListItem {
                height: layout02.height + divider.height
                ListItemLayout {
                    id: layout02
                    title.text: "Florin Lungu (backend for Italy, translations)"
                }
                onClicked: {
                    Qt.openUrlExternally("https://github.com/floryn90")
                }
            }

            ListItem {
                height: layout03.height + divider.height
                ListItemLayout {
                    id: layout03
                    title.text: "Jean-Marc (French translations)"
                }
                onClicked: {
                    Qt.openUrlExternally("https://launchpad.net/~m-balthazar")
                }
            }

            // Data Sources

            ListModel { id: jsonModel }

            Component.onCompleted: {
                Api.apiindex.forEach(function(val) {
                    jsonModel.append(val);
                });
            }

            ListItem {
                height: layout2.height + (divider.visible ? divider.height : 0)
                ListItemLayout {
                    id: layout2
                    title.text: i18n.tr("Data Sources")
                    title.font.bold: true
                }
            }

            Repeater {
                model: jsonModel
                delegate: ListItem {
                    height: layout1.height + (divider.visible ? divider.height : 0)
                    ListItemLayout {
                        id: layout1
                        title.text: name
                        subtitle.text: license
                    }
                }
            }
        }
    }
}
