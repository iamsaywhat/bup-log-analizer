import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtCharts 2.12
import QtQml.Models 2.13

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    AppHeader {
        id: overlayHeader
        z: 4
        width: parent.width
        height: 30
        parent: window.overlay
        onButtonClick: {
            if(!drawer.opened)
                drawer.open();
            if(drawer.opened)
                drawer.close();
        }
    }

    Drawer {
        id: drawer

        y: overlayHeader.height
        width: window.width / 4
        height: window.height - overlayHeader.height
        modal: false//inPortrait
        interactive: true//inPortrait
        //position: //inPortrait ? 0 : 1
        //visible: false //!inPortrait

        ListView {
            id: menu
            anchors.fill: parent
            headerPositioning: ListView.OverlayHeader
            header: Pane {
                id: header
                z: 3
                width: parent.width
                contentHeight: openFileButton.height + addWidgetButton.height
                padding: 0
                Button {
                    id: openFileButton
                    spacing: 0
                    padding: 0
                    width: parent.width
                    text: qsTr('Open file')
                    onClicked: {
                        paneStack.pop(null);
                        paneStack.push(openFilePane);
                        drawer.close();
                    }
                }
                Button {
                    id: addWidgetButton
                    anchors.margins: 0
                    spacing: 0
                    padding: 0
                    anchors.top: openFileButton.bottom
                    width: parent.width
                    text: qsTr('Add widget')
                    onClicked: {
                        //menu.model = parser.getTags();
                        paneStack.pop(null);
                        paneStack.push(addWidgetPane);
                        drawer.close();
                        paneStack.currentItem.setActivelWidgetList(activeWidgetsModel);
                    }
                }
                MenuSeparator {
                    parent: header
                    width: parent.width
                    anchors.verticalCenter: parent.bottom
                    visible: !menu.atYBeginning
                }
            }
            model: activeWidgetsModel

            delegate: ItemDelegate {
                text: model.name
                width: parent.width
                visible: model.type === "map" || model.type === "plot"
                height: ((model.type === 'map' || model.type === 'plot') ? 50 : 0)
                onClicked: {
                    widgets.switchAt(model.index+1);
                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
    ListModel {
        id:activeWidgetsModel
        function find (name){
            for(var i = 0; i < count; i++){
                if(get(i).name === name){
                    return i;
                }
            }
            return -1;
        }
        Component.onCompleted: {
            append({'type': 'empty', 'name': '<new widget>'});
//            append({'type': 'plot', 'name': 'plot i hui '});
//            append({'type': 'plot', 'name': 'plot и залупа'});
//            append({'type': 'map', 'name': '<насвай1>'});
//            append({'type': 'map', 'name': '<насвай2>'});
        }
    }

    StackView {
        id: paneStack
        anchors.fill: parent;
        anchors.topMargin: overlayHeader.height
        initialItem: widgetPane
        Pane {
            id: widgetPane
            //anchors.fill: parent;
            padding: 0
            WidgetsWorkspace {
                id: widgets
                anchors.fill: parent
            }
        }
    }
    Component {
        id: openFilePane
        OpenFilePage {
            id: openFilePaneRoot
            onCloseButtonClick: paneStack.pop(null);
        }
    }
    Component {
        id: addWidgetPane
        AddWidgetPage {
            id: addWidgetPaneRoot
            onCloseButtonClick: paneStack.pop(null);
            onAddPlot: {
                var itemIndex = activeWidgetsModel.find(name);
                if(itemIndex === -1){
                    activeWidgetsModel.append({'type': 'plot', 'name': name});
                    var newObject = Qt.createQmlObject('Graph {}', widgets);
                    newObject.addSeries (yname , xname, yname);
                    widgets.addWidget(newObject);
                }
                else {
                    widgets.itemAt(itemIndex).addSeries (yname , xname, yname);
                }
            }
            onAddMap: {
              //  (string name, string latitude, string longitude);
            }
        }
    }
}
