import QtQuick 2.0
import Ubuntu.Components 1.3


Page {
    title: i18n.tr("About")

    Flickable {
        anchors.fill: parent
        contentHeight: column.height + column.anchors.topMargin + column.anchors.bottomMargin

        Column {
            id: column
            anchors.top: parent.top
            anchors.margins: units.gu(5)
            width:parent.width
            spacing: units.gu(2)

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
                text: i18n.tr("Using TankerKoenig.de's API. Thank you for believing in open data!") + "\n" + "CC BY 4.0 -  http://creativecommons.tankerkoenig.de"
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                width:parent.width
            }
            Text {
                text: i18n.tr("Using myGasFeed.com's API. Thank you for believing in open data!") + "\n" + "http://www.mygasfeed.com/"
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                width:parent.width
            }
            Text {
                text: i18n.tr("Using data from spritpreisrechner.at.") + "\n" + "http://www.spritpreisrechner.at/"
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                width:parent.width
            }
            Text {
                text: i18n.tr("Licensed under GPLv3. Source code available at:") + "\n" + "https://github.com/derjasper/TankenApp"
                wrapMode:Text.WordWrap
                horizontalAlignment:Text.AlignHCenter
                width:parent.width
            }
        }
    }
}
