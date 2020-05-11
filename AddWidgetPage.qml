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
        plotWidgetSelector.textRole = 'name';
        plotWidgetSelector.model = list;
        mapWidgetSelector.textRole = 'name';
        mapWidgetSelector.model = list;
    }

    Connections {
        target: parser;
        onTagListChanged: {
            plotXAxisSelector.model = parser.tagList();
            plotYAxisSelector.model = parser.tagList();
            mapLatitudeSelector.model = parser.tagList();
            mapLongitudeSelector.model = parser.tagList();
            mapAltitudeSelector.model = parser.tagList();
        }
    }

    Pane {
        id: pane
        anchors.fill: parent;
        anchors.margins: 50

        Label {
            text: qsTr("Widget type:");
            font.pixelSize: 22
            font.italic: true
            anchors.top: parent.top
            anchors.bottom: widgetSelector.top
        }
        ComboBox {
            id: widgetSelector
            width: parent.width
            model: ListModel {
                ListElement { text: "Map" }
                ListElement { text: "Plot" }
            }
            onAccepted: {
                if (find(editText) === -1)
                    model.append({text: editText})
            }
            onActivated: {
                if(find(editText) === 1) {
                    plotMenu.visible = true;
                    mapMenu.visible = false;
                }
                else{
                    plotMenu.visible = false;
                    mapMenu.visible = true;
                }
            }
        }
        Item {
            id: mapMenu
            width: parent.width
            anchors.top: widgetSelector.bottom
            ComboBox {
                id: mapWidgetSelector
                anchors.top: parent.bottom
                width: parent.width
                editable: true
                delegate: ItemDelegate {
                    text: model.name
                    width: parent.width
                    visible: model.type === 'empty' || model.type === 'map'
                    height: ((model.type === 'empty' || model.type === 'map') ? 50 : 0)
                    onClicked: {
                        if(model.index === 0)
                            mapDataSelector.editable = true;
                        else
                            mapDataSelector.editable = false;
                    }
                }
            }
            ComboBox {
                id: mapLatitudeSelector
                anchors.top: mapWidgetSelector.bottom
                width: parent.width
            }
            ComboBox {
                id: mapLongitudeSelector
                anchors.top: mapLatitudeSelector.bottom
                width: parent.width
            }
            ComboBox {
                id: mapAltitudeSelector
                anchors.top: mapLongitudeSelector.bottom
                width: parent.width
            }

            Button {
                id: addMapButton
                anchors.top: mapAltitudeSelector.bottom
                width: parent.width
                text: qsTr("Add")
                onClicked: {
                    console.debug("clisc");
                    if(mapWidgetSelector.editText == mapWidgetSelector.currentText
                       && mapWidgetSelector.editable){
                        console.debug("wrong name");
                    }
                    else {
                        var name = mapWidgetSelector.editText;
                        var latitudeName = mapLongitudeSelector.currentText;
                        var longitudeName = mapLatitudeSelector.currentText;
                        var altitudeName = mapAltitudeSelector.currentText;
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
            ComboBox {
                id: plotWidgetSelector
                anchors.top: parent.bottom
                width: parent.width
                editable: true
                delegate: ItemDelegate {
                    text: model.name
                    width: parent.width
                    visible: model.type === 'empty' || model.type === 'plot'
                    height: ((model.type === 'empty' || model.type === 'plot') ? 50 : 0)
                    onClicked: {
                        if(model.index === 0)
                            plotWidgetSelector.editable = true;
                        else
                            plotWidgetSelector.editable = false;
                    }
                }
            }
            ComboBox {
                id: plotXAxisSelector
                anchors.top: plotWidgetSelector.bottom
                width: parent.width
            }
            ComboBox {
                id: plotYAxisSelector
                width: parent.width
                anchors.top: plotXAxisSelector.bottom
            }
            Button {
                id: addPlotButton
                width: parent.width
                anchors.top: plotYAxisSelector.bottom
                text: qsTr("Add")
                onClicked: {

                    if(plotWidgetSelector.editText == plotWidgetSelector.currentText
                       && plotWidgetSelector.editable){
                        console.debug("wrong name");
                    }
                    else {
                        var name = plotWidgetSelector.editText;
                        var xAxisName = plotXAxisSelector.currentText;
                        var yAxixName = plotYAxisSelector.currentText;
                        addPlot(name, xAxisName, yAxixName);
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
