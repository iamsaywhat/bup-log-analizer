import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: root
    function addWidget(item){
        widgets.addItem(item);
    }

    SwipeView
    {
        id: widgets
        anchors.fill: parent;
        padding: 0
        Rectangle {
            anchors.fill: widgets;
            color: 'red';
        }
        GpsTracker {
            //anchors.fill: widgets
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
