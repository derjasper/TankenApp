import QtQuick 2.0
import Ubuntu.Components 1.3
import QtLocation 5.3
import "api/apiindex.js" as Api

Page {
    title: i18n.tr("Select Source")

    signal setApi(string api)

    ListModel { id: jsonModel }

    ListView {
        anchors.fill: parent

        model: jsonModel


        delegate: ListItem {
            contentItem.anchors.margins: units.gu(2)
            height: units.gu(11)

            Label {
                id: lname
                text: name
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
            }

            Label {
                id: ldescription
                text: description
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: lname.bottom
            }

            Label {
                id: llicense
                text: license
                anchors.top: ldescription.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }


            onClicked: {
                setApi(id)

                pageStack.pop()
            }
        }


    }

    Component.onCompleted: {
        for (var key in Api.apiindex) {
            Api.apiindex[key].id = key;
            jsonModel.append(Api.apiindex[key]);
        }
    }
}
