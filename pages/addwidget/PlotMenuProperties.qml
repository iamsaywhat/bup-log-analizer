import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12


Item {
    id: root
    signal confirmed(string name, string xname, string yname);
    function setModel(model) {
        widgetSelector.combobox.model = model;
    }
    function setRole(role) {
        widgetSelector.combobox.textRole = role;
    }
    function setXSelectorModel(model) {
        xAxisSelector.combobox.model = model;
    }
    function setYSelectorModel(model) {
        yAxisSelector.combobox.model = model;
    }
    ColumnLayout {
        anchors.fill: parent
        Selector {
            id: widgetSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Select widget:")
            combobox.editable: true
            combobox.delegate: ItemDelegate {
                text: model.name
                width: parent.width
                visible: model.type === 'empty' || model.type === 'plot'
                height: ((model.type === 'empty' || model.type === 'plot') ? 50 : 0)
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
            id: xAxisSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Select x-axis:")
        }
        Selector {
            id: yAxisSelector
            Layout.fillHeight: true
            Layout.fillWidth: true
            label.text: qsTr("Select y-axis:")
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
                    widgetSelector.combobox.editable = false;
                    var name = widgetSelector.combobox.editText;
                    var xAxisName = xAxisSelector.combobox.currentText;
                    var yAxixName = yAxisSelector.combobox.currentText;
                    confirmed(name, xAxisName, yAxixName);
                    widgetSelector.combobox.editable = true;
                    widgetSelector.combobox.editText = "";
                }
            }
        }
    }
}
