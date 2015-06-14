import QtQuick 2.0
import Ubuntu.Components 1.2


Page {
    title: i18n.tr("About")



    Column {
        anchors.centerIn: parent
        width:parent.width
        spacing: units.gu(2)


        UbuntuShape {
            anchors.horizontalCenter: parent.horizontalCenter
            image: Image {
                source: "Tanken.png"
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
            text: i18n.tr("Germany's offical MTS-K data.") + "\n" + i18n.tr("No warranty for correct prices and availability.")
            wrapMode:Text.WordWrap
            horizontalAlignment:Text.AlignHCenter
            width:parent.width
        }
        Text {
            text: i18n.tr("Using TankerKoenig.de's API. Thank you for believing in open data!") + "\n" + "CC BY 4.0 -  http://creativecommons.tankerkoenig.de"
            wrapMode:Text.WordWrap
            horizontalAlignment:Text.AlignHCenter
            width:parent.width
        }
        Text {
            text: i18n.tr("Licenced under GPL v2. Source code available at:") + "\n" + "https://github.com/derjasper/TankenApp"
            wrapMode:Text.WordWrap
            horizontalAlignment:Text.AlignHCenter
            width:parent.width
        }
    }
}
