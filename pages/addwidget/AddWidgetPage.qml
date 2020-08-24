import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13
import QtQml.Models 2.13

Item {
    id: root

    signal closeButtonClick();
    signal addPlot(string name, string xname, string yname);
    signal addTrack(string name, color color);
    signal addPoint(string name, string point, var radius, var opacity, color color);


    property int rowHeight: 50

    function setActivelWidgetList (list) {
        plotMenu.setModel(list);
        plotMenu.setRole('name');
        trackMenu.setModel(list);
        trackMenu.selRole('name');
        pointMenu.setModel(list);
        pointMenu.setRole('name');
    }

    Connections {
        target: parser;
        onFileOpen: {
            plotMenu.setXSelectorModel(parser.getSeriesList());
            plotMenu.setYSelectorModel(parser.getSeriesList());
            pointMenu.setNamesModel(parser.getPointsList());
        }
    }
    Pane {
        id: pane
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width, 500)
        height: parent.height
        Selector {
            id: widgetSelector
            anchors.top: parent.top
            width: parent.width
            height: rowHeight
            label.text: qsTr("Object type:");
            label.font.pixelSize: 18
            combobox.model: ListModel { }
            combobox.delegate: ItemDelegate {
                text: model.text
                width: parent.width
                highlighted: ListView.isCurrentItem
                onClicked: widgetSelector.combobox.currentIndex = index;
            }
            combobox.onAccepted: {
                if (combobox.find(combobox.editText) === -1)
                    combobox.model.append({text: editText})
            }
            Component.onCompleted: {
                widgetSelector.combobox.model.append({text:"Track"});
                widgetSelector.combobox.model.append({text:"Plot"});
                widgetSelector.combobox.model.append({text:"Point"});
                widgetSelector.combobox.currentIndex = 0;
            }
        }
        TrackMenuProperties {
            id: trackMenu
            rowHeight: rowHeight
            rowWidth: parent.width
            spacing: 10
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 0) ? true : false)
            onConfirmed: addTrack(name, color);
        }
        PlotMenuProperties {
            id: plotMenu
            rowHeight: rowHeight
            rowWidth: parent.width
            spacing: 10
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 1) ? true : false)
            onConfirmed: addPlot(name, xname, yname);
        }
        PointMenuProperties {
            id: pointMenu
            rowHeight: rowHeight
            rowWidth: parent.width
            spacing: 10
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 2) ? true : false)
            onConfirmed: addPoint(name, point, radius, opacity, color);
        }
    }
    RoundButton {
        id: closeButton
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 20
        anchors.topMargin: 20
        width: 30
        height: width
        onClicked: closeButtonClick();
        Image {
            id: closeButtonIcon
            anchors.fill: parent
            anchors.margins: 5
            source: "qrc:/icons/close.png"
            fillMode: Image.PreserveAspectFit
        }
    }
}

