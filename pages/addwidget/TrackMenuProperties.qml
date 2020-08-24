import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    id: root

    property int spacing: 5
    property int rowHeight: 50
    property int rowWidth: 300

    signal confirmed(string name, color color);

    function setModel(model) {
        widgetSelector.combobox.model = model;
    }

    function selRole(role) {
        widgetSelector.combobox.textRole = role;
    }

    width: rowWidth
    height: rowHeight * 3

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
                    widgetSelector.combobox.currentIndex = model.index;  // switch curent element
                    if(model.index === 0) {                             // it's <new widget> index0
                        widgetSelector.combobox.editable = true;   // make it editable
                        widgetSelector.combobox.editText = '';     // make it empty for user
                    }
                    else
                        widgetSelector.combobox.editable = false;  // in other cases make it uneditable
                }
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
                combobox.model.append({text:'black'});
                combobox.model.append({text:'red'});
                combobox.model.append({text:'blue'});
                combobox.model.append({text:'green'});
                combobox.model.append({text:'yellow'});
                combobox.model.append({text:'cyan'});
                combobox.model.append({text:'magenta'});
                combobox.currentIndex = 0;
            }
        }
        Button {
            id: applyButton
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: qsTr("Add")
            onClicked: {
                if(widgetSelector.combobox.editText == "" &&    // if name is empty
                   widgetSelector.combobox.currentIndex == 0)   // and current index is index of <new widget>
                {
                    console.debug("name is empty!");
                }
                else {
                    widgetSelector.combobox.editable = false;        // the following will fix a bug with
                    var name = widgetSelector.combobox.editText;     // adding empty elements (before adding a
                    var color = colorSelector.combobox.currentText;  // new element, you need to make the combobox
                    confirmed(name, color);                                // uneditable)
                    widgetSelector.combobox.editable = true;
                    widgetSelector.combobox.editText = "";
                }
            }
        }
    }
}
