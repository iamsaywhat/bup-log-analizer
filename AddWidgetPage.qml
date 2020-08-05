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

    function setActivelWidgetList (list) {
        plotWidgetSelector.combobox.textRole = 'name';
        plotWidgetSelector.combobox.model = list;
        trackWidgetSelector.combobox.textRole = 'name';
        trackWidgetSelector.combobox.model = list;
        pointWidgetSelector.combobox.textRole = 'name';
        pointWidgetSelector.combobox.model = list;
    }

    Connections {
        target: parser;
        onFileOpen: {
            plotXAxisSelector.combobox.model = parser.getSeriesList();
            plotYAxisSelector.combobox.model = parser.getSeriesList();
            pointNameSelector.combobox.model = parser.getPointsList();
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

            label.text: qsTr("Object type:");
            label.font.pixelSize: 18
            combobox.model: ListModel { }
            combobox.delegate: ItemDelegate {
                text: model.text
                width: parent.width
                highlighted: ListView.isCurrentItem
                onClicked: trackColorSelector.combobox.currentIndex = index;
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
        Item {
            id: trackMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 0) ? true : false)
            Selector {
                id: trackWidgetSelector
                label.text: "Select widget:"
                anchors.top: parent.top
                width: parent.width
                combobox.editable: true
                combobox.delegate: ItemDelegate {
                    text: model.name
                    width: parent.width
                    visible: model.type === 'empty' || model.type === 'map'
                    height: ((model.type === 'empty' || model.type === 'map') ? 50 : 0)
                    onClicked: {
                        trackWidgetSelector.combobox.currentIndex = model.index;
                        if(model.index === 0) {
                            trackWidgetSelector.combobox.editable = true;
                            trackWidgetSelector.combobox.editText = '';
                        }
                        else
                            trackWidgetSelector.combobox.editable = false;
                    }
                }
            }
            Selector {
                id: trackColorSelector
                anchors.top: trackWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Color:")
                combobox.model: ListModel {}
                combobox.delegate: ItemDelegate {
                    text: model.text
                    width: parent.width
                    highlighted: ListView.isCurrentItem
                    onClicked: trackColorSelector.combobox.currentIndex = index;
                }
                Component.onCompleted: {
                    combobox.model.append({ text: 'black'});
                    combobox.model.append({ text: 'red'});
                    combobox.model.append({ text: 'blue'});
                    combobox.model.append({ text: 'green'});
                    combobox.model.append({ text: 'yellow'});
                    combobox.model.append({ text: 'cyan'});
                    combobox.model.append({ text: 'magenta'});
                    combobox.currentIndex = 0;
                }
            }
            Button {
                id: addRrackButton
                anchors.top: trackColorSelector.bottom
                width: parent.width
                text: qsTr("Add")
                onClicked: {
                    if(trackWidgetSelector.combobox.editText == trackWidgetSelector.combobox.currentText
                       && trackWidgetSelector.combobox.editable){
                        console.debug("wrong name");
                    }
                    else {
                        trackWidgetSelector.combobox.editable = false;
                        var name = trackWidgetSelector.combobox.editText;
                        var color = trackColorSelector.combobox.currentText;
                        addTrack(name, color);
                        trackWidgetSelector.combobox.editable = true;
                    }
                }
            }
        }
        Item {
            id: plotMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 1) ? true : false)
            Selector {
                id: plotWidgetSelector
                anchors.top: parent.bottom
                width: parent.width
                label.text: qsTr("Select widget:")
                combobox.editable: true
                combobox.delegate: ItemDelegate {
                    text: model.name
                    width: parent.width
                    visible: model.type === 'empty' || model.type === 'plot'
                    height: ((model.type === 'empty' || model.type === 'plot') ? 50 : 0)
                    onClicked: {
                        if(model.index === 0)
                            plotWidgetSelector.combobox.editable = true;
                        else
                            plotWidgetSelector.combobox.editable = false;
                    }
                }
            }
            Selector {
                id: plotXAxisSelector
                anchors.top: plotWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Select x-axis:")
            }
            Selector {
                id: plotYAxisSelector
                width: parent.width
                anchors.top: plotXAxisSelector.bottom
                label.text: qTr("Select y-axis:")
            }
            Button {
                id: addPlotButton
                width: parent.width
                anchors.top: plotYAxisSelector.bottom
                text: qsTr("Add")
                onClicked: {
                    if(plotWidgetSelector.combobox.editText == plotWidgetSelector.combobox.currentText
                       && plotWidgetSelector.combobox.editable){
                        console.debug(qTr("wrong name"));
                    }
                    else {
                        var name = plotWidgetSelector.combobox.editText;
                        var xAxisName = plotXAxisSelector.combobox.currentText;
                        var yAxixName = plotYAxisSelector.combobox.currentText;
                        addPlot(name, xAxisName, yAxixName);
                    }
                }
            }
        }
        Item {
            id: pointMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            visible: ((widgetSelector.combobox.currentIndex === 2) ? true : false)
            Selector {
                id: pointWidgetSelector
                label.text: qTr("Select widget:")
                anchors.top: parent.top
                width: parent.width
                combobox.editable: true
                combobox.delegate: ItemDelegate {
                    text: model.name
                    width: parent.width
                    visible: model.type === 'empty' || model.type === 'map'
                    height: ((model.type === 'empty' || model.type === 'map') ? 50 : 0)
                    onClicked: {
                        if(model.index === 0)
                            pointWidgetSelector.combobox.editable = true;
                        else
                            pointWidgetSelector.combobox.editable = false;
                    }
                }
            }
            Selector {
                id: pointNameSelector
                anchors.top: pointWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Point name:")
            }
            Selector {
                id: pointRadiusSelector
                anchors.top: pointNameSelector.bottom
                width: parent.width
                combobox.editable: true
                label.text: qsTr("Radius:")
                combobox.model: ListModel {}
                combobox.delegate: ItemDelegate {
                    text: model.text
                    width: parent.width
                    highlighted: ListView.isCurrentItem
                    onClicked: pointRadiusSelector.combobox.currentIndex = index;
                }
                combobox.validator: IntValidator {
                        top: 5000
                        bottom: 0
                    }
                Component.onCompleted: {
                    pointRadiusSelector.combobox.model.append({text:'50'});
                    pointRadiusSelector.combobox.model.append({text:'100'});
                    pointRadiusSelector.combobox.model.append({text:'150'});
                    pointRadiusSelector.combobox.model.append({text:'200'});
                    pointRadiusSelector.combobox.model.append({text:'250'});
                    pointRadiusSelector.combobox.model.append({text:'300'});
                    pointRadiusSelector.combobox.model.append({text:'350'});
                    pointRadiusSelector.combobox.model.append({text:'400'});
                    pointRadiusSelector.combobox.currentIndex = 0;
                }
            }
            Selector {
                id: pointColorSelector
                anchors.top: pointRadiusSelector.bottom
                width: parent.width
                label.text: qsTr("Color:")
                combobox.model: ListModel {}
                combobox.delegate: ItemDelegate {
                    text: model.text
                    width: parent.width
                    highlighted: ListView.isCurrentItem
                    onClicked: pointColorSelector.combobox.currentIndex = index;
                }
                Component.onCompleted: {
                    pointColorSelector.combobox.model.append({text:'red'});
                    pointColorSelector.combobox.model.append({text:'blue'});
                    pointColorSelector.combobox.model.append({text:'green'});
                    pointColorSelector.combobox.model.append({text:'yellow'});
                    pointColorSelector.combobox.model.append({text:'cyan'});
                    pointColorSelector.combobox.model.append({text:'magenta'});
                    pointColorSelector.combobox.currentIndex = 0;
                }
            }

            Button {
                id: addPointButton
                anchors.top: pointColorSelector.bottom
                width: parent.width
                text: qsTr("Add")
                onClicked: {
                    console.debug("clisc");
                    if(pointWidgetSelector.combobox.editText == pointWidgetSelector.combobox.currentText
                       && pointWidgetSelector.combobox.editable){
                        console.debug("wrong name");
                    }
                    else {
                        var name = pointWidgetSelector.combobox.editText;
                        var point = pointNameSelector.combobox.currentText;
                        var radius = pointRadiusSelector.combobox.editText;
                        var opacity = 0.5;
                        var color = pointColorSelector.combobox.currentText;
                        addPoint(name, point, radius, opacity, color);
                    }
                }
            }
        }
    }
    RoundButton{
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
