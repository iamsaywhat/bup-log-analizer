import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13
import QtQml.Models 2.13

Item {
    id: root

    signal closeButtonClick();
    signal addPlot(string name, string xname, string yname);
    signal addTrack(string name, color color);
    signal addPoint(string name, string latitude, string longitude, var radius, var opacity, color color);

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
        }
    }
    Pane {
        id: pane
        anchors.margins: 50
        anchors.fill:  parent
        Selector {
            id: widgetSelector
            anchors.top: parent.top
//            anchors.left: parent.left
//            anchors.right: parent.right
            width: parent.width

            label.text: qsTr("Object type:");
            label.font.pixelSize: 18
            combobox.model: ListModel {
                ListElement { text: "Track" }
                ListElement { text: "Plot" }
                ListElement { text: "Point" }
            }
            combobox.delegate: ItemDelegate {
                text: model.text
            }
            combobox.onAccepted: {
                if (combobox.find(combobox.editText) === -1)
                    combobox.model.append({text: editText})
            }
            combobox.onActivated: {
//                trackMenu.visible = ((index == 0) ? true : false);
//                plotMenu.visible = ((index == 1) ? true : false);
//                pointMenu.visible = ((index == 2) ? true : false);
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
                        if(model.index === 0)
                            trackWidgetSelector.combobox.editable = true;
                        else
                            trackWidgetSelector.combobox.editable = false;
                    }
                }
            }
//            Selector {
//                id: trackLatitudeSelector
//                anchors.top: trackWidgetSelector.bottom
//                width: parent.width
//                label.text: qsTr("Latitude:")
//            }
//            Selector {
//                id: trackLongitudeSelector
//                anchors.top: trackLatitudeSelector.bottom
//                width: parent.width
//                label.text: qsTr("Longitude:")
//            }
//            Selector {
//                id: trackAltitudeSelector
//                anchors.top: trackLongitudeSelector.bottom
//                width: parent.width
//                label.text: qsTr("Altitude:")
//            }
            Selector {
                id: trackColorSelector
                anchors.top: trackWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Color:")
                combobox.model: ListModel {
                    ListElement { text: 'black'}
                    ListElement { text: 'red' }
                    ListElement { text: 'blue' }
                    ListElement { text: 'green' }
                    ListElement { text: 'yellow'}
                    ListElement { text: 'cyan'}
                    ListElement { text: 'magenta'}
                }
                combobox.delegate: ItemDelegate {
                    text: model.text
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
                        var name = trackWidgetSelector.combobox.editText;
                        var color = trackColorSelector.combobox.currentText;
                        addTrack(name, color);
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
                label.text: "Select widget:"
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
                label.text: "Select x-axis:"
            }
            Selector {
                id: plotYAxisSelector
                width: parent.width
                anchors.top: plotXAxisSelector.bottom
                label.text: "Select y-axis:"
            }
            Button {
                id: addPlotButton
                width: parent.width
                anchors.top: plotYAxisSelector.bottom
                text: qsTr("Add")
                onClicked: {
                    if(plotWidgetSelector.combobox.editText == plotWidgetSelector.combobox.currentText
                       && plotWidgetSelector.combobox.editable){
                        console.debug("wrong name");
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
                        if(model.index === 0)
                            pointWidgetSelector.combobox.editable = true;
                        else
                            pointWidgetSelector.combobox.editable = false;
                    }
                }
            }
            Selector {
                id: pointLatitudeSelector
                anchors.top: pointWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Latitude:")
            }
            Selector {
                id: pointLongitudeSelector
                anchors.top: pointLatitudeSelector.bottom
                width: parent.width
                label.text: qsTr("Longitude:")
            }
            Selector {
                id: pointRadiusSelector
                anchors.top: pointLongitudeSelector.bottom
                width: parent.width
                label.text: qsTr("Radius:")
            }
            Selector {
                id: pointColorSelector
                anchors.top: pointRadiusSelector.bottom
                width: parent.width
                label.text: qsTr("Color:")
                combobox.model: ListModel {
                    ListElement { text: 'red' }
                    ListElement { text: 'blue' }
                    ListElement { text: 'green' }
                    ListElement { text: 'yellow'}
                    ListElement { text: 'cyan'}
                    ListElement { text: 'magenta'}
                }
                combobox.delegate: ItemDelegate {
                    text: model.text
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
                        var latitudeName = pointLongitudeSelector.combobox.currentText;
                        var longitudeName = pointLatitudeSelector.combobox.currentText;
                        var radius = 5000;
                        var opacity = 0.5;
                        var color = pointColorSelector.combobox.currentText;
                        addPoint(name, latitudeName, longitudeName, radius, opacity, color);
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
            source: "qrc:/icons/stop.png"
        }
    }
}
