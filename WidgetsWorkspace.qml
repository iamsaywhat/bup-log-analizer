import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: root
    function addWidget(item){
        widgets.addItem(item);
    }
    function switchAt(index){
        widgets.setCurrentIndex(index);
    }
    function itemAt(index){
        return widgets.itemAt(index);
    }

    SwipeView
    {
        id: widgets
        anchors.fill: parent;
        padding: 0
        GpsTracker {
        }
    }
    PageIndicator {
        id: indicator

        count: widgets.count
        currentIndex: widgets.currentIndex

        anchors.bottom: widgets.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
