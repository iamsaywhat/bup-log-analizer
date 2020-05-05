import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13
import QtQml.Models 2.13

Item {
    id: root

    signal closeButtonClick();
    signal addWidged(string name, string xname, string yname);

    function setData () {
       plotXAxisSelector.model = parser.getTags();
       plotYAxisSelector.model = parser.getTags();

    }
    function setActivelWidgetList (list) {
        plotWidgetSelector.textRole = 'name';
        plotWidgetSelector.model = list;
    }

    Component.onCompleted:  setData();

    Pane {
        id: pane
        anchors.fill: parent;

        Label {
            text: qsTr("Widget type:");
            font.pixelSize: 22
            font.italic: true
            anchors.top: parent.top
            anchors.bottom: widgetSelector.top
        }
        ComboBox {
            id: widgetSelector
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
                }
                else{
                    plotMenu.visible = false;
                }
            }
        }
        Item {
            id: mapMenu
            width: 200
            anchors.top: widgetSelector.bottom
            ComboBox {
                id: mapDataSelector
                editable: false
                model: ListView {

                }
            }

            Button {
                id: addMapButton
            }

        }

        Item {
            id: plotMenu
            width: 200
            anchors.top: widgetSelector.bottom
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
                id: addPlot
                width: parent.width
                anchors.top: plotYAxisSelector.bottom
                text: qsTr("Add")
                onClicked: {
                    var name = plotWidgetSelector.editText;
                    var xAxisName = plotXAxisSelector.currentText;
                    var yAxixName = plotYAxisSelector.currentText;
//                    plotWidgetSelector.model.append({'type': 'plot',
//                                                     'name': name});
                    addWidged(name, xAxisName, yAxixName);
                    console.debug(plotWidgetSelector.model);
                }
            }
        }

//        ComboBox {
//            id: objectType
//            anchors.top: ggt.bottom
//        }


        RoundButton{
            text: "\u2713" // Unicode Character 'CHECK MARK'
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.topMargin: 20
            onClicked: closeButtonClick();
        }
    }
}
