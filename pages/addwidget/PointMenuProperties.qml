import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    id: root

    property int spacing: 5
    property int rowHeight: 50
    property int rowWidth: 300

    signal confirmed(string name, string point, var radius, var opacity, color color);

    function setModel(model) {
        widgetSelector.combobox.model = model;
    }

    function setRole(role) {
        widgetSelector.combobox.textRole = role;
    }

    function setNamesModel(model) {
        nameSelector.combobox.model = model;
    }

    width: rowWidth
    height: rowHeight * 5

    ColumnLayout {
        anchors.fill: parent
        spacing: spacing
        Selector {
            id: widgetSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Select widget:")
            combobox.editable: true
            combobox.delegate: ItemDelegate {
                text: model.name
                width: parent.width
                visible: model.type === 'empty' || model.type === 'map'
                height: ((model.type === 'empty' || model.type === 'map') ? 50 : 0)
                onClicked: {
                    widgetSelector.combobox.currentIndex = index;
                    if(model.index === 0) {
                        widgetSelector.combobox.editable = true;
                        widgetSelector.combobox.editText = "";
                    }
                    else
                        widgetSelector.combobox.editable = false;
                }
            }
        }
        Selector {
            id: nameSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Point name:")
        }
        Selector {
            id: radiusSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            combobox.editable: true
            label.text: qsTr("Radius:")
            combobox.model: ListModel {}
            combobox.delegate: ItemDelegate {
                text: model.text
                width: parent.width
                highlighted: ListView.isCurrentItem
                onClicked: radiusSelector.combobox.currentIndex = index;
            }
            combobox.validator: IntValidator {
                top: 5000
                bottom: 0
            }
            Component.onCompleted: {
                radiusSelector.combobox.model.append({text:'50'});
                radiusSelector.combobox.model.append({text:'100'});
                radiusSelector.combobox.model.append({text:'150'});
                radiusSelector.combobox.model.append({text:'200'});
                radiusSelector.combobox.model.append({text:'250'});
                radiusSelector.combobox.model.append({text:'300'});
                radiusSelector.combobox.model.append({text:'350'});
                radiusSelector.combobox.model.append({text:'400'});
                radiusSelector.combobox.currentIndex = 0;
            }
        }
        Selector {
            id: colorSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Color:")
            combobox.model: ListModel {}
            combobox.delegate: ItemDelegate {
                text: model.text
                width: parent.width
                highlighted: ListView.isCurrentItem
                onClicked: colorSelector.combobox.currentIndex = index;
            }
            Component.onCompleted: {
                colorSelector.combobox.model.append({text:'red'});
                colorSelector.combobox.model.append({text:'blue'});
                colorSelector.combobox.model.append({text:'green'});
                colorSelector.combobox.model.append({text:'yellow'});
                colorSelector.combobox.model.append({text:'cyan'});
                colorSelector.combobox.model.append({text:'magenta'});
                colorSelector.combobox.currentIndex = 0;
            }
        }

        Button {
            id: applyButton
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: qsTr("Add")
            onClicked: {
                if(widgetSelector.combobox.editText == "" &&
                   widgetSelector.combobox.currentIndex == 0)
                {
                    console.debug("name is empty!");
                }
                else {
                    widgetSelector.combobox.editable = false;
                    var name = widgetSelector.combobox.editText;
                    var point = nameSelector.combobox.currentText;
                    var radius = radiusSelector.combobox.editText;
                    var opacity = 0.5;
                    var color = colorSelector.combobox.currentText;
                    confirmed(name, point, radius, opacity, color);
                    widgetSelector.combobox.editable = true;
                    widgetSelector.combobox.editText = "";
                }
            }
        }
    }
}

