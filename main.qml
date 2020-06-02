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
                        main.setCurrentIndex(0);
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
                        main.setCurrentIndex(1);
                        drawer.close();
                        main.currentItem.setActivelWidgetList(activeWidgetsModel);
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
                    console.debug(model.index-1);
                    widgets.switchAt(model.index-1);
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

    SwipeView {
        id: main
        anchors.fill: parent;
        anchors.topMargin: overlayHeader.height
        interactive: false

        OpenFilePage {
            id: openFilePane
            onCloseButtonClick: main.setCurrentIndex(2);
        }
        AddWidgetPage {
            id: addWidgetPane
            onCloseButtonClick: main.setCurrentIndex(2);
            onAddPlot: {
                var itemIndex = activeWidgetsModel.find(name);
                if(itemIndex === -1){
                    var component = Qt.createComponent("Graph.qml");
                    if (component.status === Component.Ready) {
                        var object = component.createObject(widgets);
                        activeWidgetsModel.append({'type': 'plot', 'name': name});
                        object.addSeries (yname , xname, yname);
                        widgets.addWidget(object);
                    }
                }
                else {
                    widgets.itemAt(itemIndex-1).addSeries (yname , xname, yname);
                }
            }
            onAddTrack: {
                var itemIndex = activeWidgetsModel.find(name);
                if(itemIndex === -1){
                    var component = Qt.createComponent("GpsTracker.qml");
                    if (component.status === Component.Ready) {
                        var object = component.createObject(widgets);
                        activeWidgetsModel.append({'type': 'map', 'name': name});
                        object.createTrack(parser.getTrack(), color);
                        widgets.addWidget(object);
                    }
                }
                else {
                    widgets.itemAt(itemIndex-1).createTrack(parser.getTrack(), color);
                }
            }
            onAddPoint:  {
                console.debug("onAddPoint");
                var itemIndex = activeWidgetsModel.find(name);
                if(itemIndex === -1){
                    var component = Qt.createComponent("GpsTracker.qml");
                    if (component.status === Component.Ready) {
                        var object = component.createObject(widgets);
                        activeWidgetsModel.append({'type': 'map', 'name': name});
                        object.createCircle(latitude, longitude, radius, opacity, color);
                        widgets.addWidget(object);
                    }
                }
                else {
                    widgets.itemAt(itemIndex-1).createCircle(latitude, longitude, radius, opacity, color);
                }
            }
        }
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
}
