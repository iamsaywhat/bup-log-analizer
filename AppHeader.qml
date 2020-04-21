import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id:root

    signal buttonClick()

    ToolBar {
        id: header
        anchors.fill: parent
        Button {
            id: menuButton
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            onClicked: buttonClick();
        }
        Label {
            id: label
            anchors.centerIn: parent
            text: qsTr('File is not open')
        }
    }
}
