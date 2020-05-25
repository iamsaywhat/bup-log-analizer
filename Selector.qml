import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: root
    property alias label: label
    property alias combobox: combobox
    height: 50
    width:  20
    Rectangle {
        anchors.fill: parent
        color: 'red'
        Label {
            id: label
            font.pixelSize: 18
            font.italic: true
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: combobox.left
            verticalAlignment: Text.AlignVCenter
            width: parent.width/2
        }
        ComboBox {
            id: combobox
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width/2
        }
    }
}
