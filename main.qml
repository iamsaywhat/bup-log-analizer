import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtCharts 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

//    GpsTracker {
//        anchors.fill: parent
//    }
    Graph {
        id: d

    }
    Button {

        onClicked: d.addData();
    }

}
