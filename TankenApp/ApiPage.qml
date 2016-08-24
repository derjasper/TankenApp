import QtQuick 2.0
import Ubuntu.Components 1.3
import QtLocation 5.3
import "api/apiindex.js" as Api

Page {
    id: apiPage

    header: PageHeader {
        title: i18n.tr("Select Source")
        flickable: list
    }

    signal setApi(string api)

    ListModel { id: jsonModel }

    ListView {
        id: list

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

                pageStack.removePages(apiPage)
            }
        }


    }

    Component.onCompleted: {
        Api.apiindex.forEach(function(val) {
            jsonModel.append(val);
        });
    }
}
