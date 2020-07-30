import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: root
    function addWidget(item){
        widgets.addItem(item);
    }
    function switchAt(index){
        widgets.setCurrentIndex(index);
        console.debug(widgets.count);
    }
    function itemAt(index){
        return widgets.itemAt(index);
    }
    Label {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: "There is nothing here, but you can add widgets using the \"Add widget\" button in the left swipe menu"
        font.pixelSize: 20
    }
    SwipeView
    {
        id: widgets
        anchors.fill: parent;
        padding: 0
    }
    PageIndicator {
        id: indicator

        count: widgets.count
        currentIndex: widgets.currentIndex

        anchors.bottom: widgets.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Button {
        id: swipeToLeft
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 50
        visible: ((widgets.count > 1) ? true : false)
        onClicked: {
            if(widgets.currentIndex > 0)
                widgets.setCurrentIndex(widgets.currentIndex - 1);
            else
                widgets.setCurrentIndex(widgets.count - 1);
        }
        background: Rectangle {
            color: "white"
            opacity: parent.pressed ? 0.2 : 0
        }
        Image {
            source: "qrc:/icons/swipe_to_left.png"
            anchors.fill: parent
            opacity: !parent.hovered ? 0.5 : 0.8
        }
    }
    Button {
        id: swipetoRight
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 50
        visible: ((widgets.count > 1) ? true : false)
        Image {
            source: "qrc:/icons/swipe_to_right.png"
            anchors.fill: parent
            opacity: !parent.hovered ? 0.5 : 0.8
        }
        onClicked: {
            if(widgets.currentIndex < widgets.count - 1)
                widgets.setCurrentIndex(widgets.currentIndex + 1);
            else
                widgets.setCurrentIndex(0);
        }
        background: Rectangle {
            color: "white"
            opacity: parent.pressed ? 0.2 : 0
        }
    }
}
