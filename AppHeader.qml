import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id:root

    signal buttonClick()

    Connections {
        target: parser;
        onFileOpen: {
            label.text = name;
        }
    }

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
            Image {
                id: menuIcon
                anchors.fill: parent
                anchors.margins: 5
                source: "qrc:/icons/menu.png"
            }
        }
        Label {
            id: label
            anchors.centerIn: parent
            text: qsTr('File is not open')
        }
    }
}
