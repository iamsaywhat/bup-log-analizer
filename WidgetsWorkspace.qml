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
}
