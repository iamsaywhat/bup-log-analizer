import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13
import QtQml.Models 2.13

Item {
    id: root

    signal closeButtonClick();
    signal addPlot(string name, string xname, string yname);
    signal addMap(string name, string latitude, string longitude, string altitude);

    function setActivelWidgetList (list) {
        plotWidgetSelector.combobox.textRole = 'name';
        plotWidgetSelector.combobox.model = list;
        mapWidgetSelector.combobox.textRole = 'name';
        mapWidgetSelector.combobox.model = list;
    }

    Connections {
        target: parser;
        onTagListChanged: {
            plotXAxisSelector.combobox.model = parser.tagList();
            plotYAxisSelector.combobox.model = parser.tagList();
            mapLatitudeSelector.combobox.model = parser.tagList();
            mapLongitudeSelector.combobox.model = parser.tagList();
            mapAltitudeSelector.combobox.model = parser.tagList();
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

            label.text: qsTr("Widget type:");
            label.font.pixelSize: 18
            label.font.italic: true
            combobox.model: ListModel {
                ListElement { text: "Map" }
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
                mapMenu.visible = ((index == 0) ? true : false);
                plotMenu.visible = ((index == 1) ? true : false);;
                pointMenu.visible = ((index == 2) ? true : false);
            }
        }
        Item {
            id: mapMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            Selector {
                id: mapWidgetSelector
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
                            mapWidgetSelector.combobox.editable = true;
                        else
                            mapWidgetSelector.combobox.editable = false;
                    }
                }
            }
            Selector {
                id: mapLatitudeSelector
                anchors.top: mapWidgetSelector.bottom
                width: parent.width
                label.text: qsTr("Latitude:")
            }
            Selector {
                id: mapLongitudeSelector
                anchors.top: mapLatitudeSelector.bottom
                width: parent.width
                label.text: qsTr("Longitude:")
            }
            Selector {
                id: mapAltitudeSelector
                anchors.top: mapLongitudeSelector.bottom
                width: parent.width
                label.text: qsTr("Altitude:")
            }

            Button {
                id: addMapButton
                anchors.top: mapAltitudeSelector.bottom
                width: parent.width
                text: qsTr("Add")
                onClicked: {
                    console.debug("clisc");
                    if(mapWidgetSelector.combobox.editText == mapWidgetSelector.combobox.currentText
                       && mapWidgetSelector.combobox.editable){
                        console.debug("wrong name");
                    }
                    else {
                        var name = mapWidgetSelector.combobox.editText;
                        var latitudeName = mapLongitudeSelector.combobox.currentText;
                        var longitudeName = mapLatitudeSelector.combobox.currentText;
                        var altitudeName = mapAltitudeSelector.combobox.currentText;
                        addMap(name, latitudeName, longitudeName, altitudeName);
                    }
                }
            }
        }
        Item {
            id: plotMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            visible: false
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
//                    else {
//                        var name = mapWidgetSelector.combobox.editText;
//                        var latitudeName = mapLongitudeSelector.combobox.currentText;
//                        var longitudeName = mapLatitudeSelector.combobox.currentText;
//                        var altitudeName = mapAltitudeSelector.combobox.currentText;
//                        addMap(name, latitudeName, longitudeName, altitudeName);
//                    }
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
