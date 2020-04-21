import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtCharts 2.12

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
                    onClicked: menu.model = parser.getTags();
                }
                Button {
                    id: addWidgetButton
                    anchors.margins: 0
                    spacing: 0
                    padding: 0
                    anchors.top: openFileButton.bottom
                    width: parent.width
                    text: qsTr('Add widget')
                    onClicked: menu.model = parser.getTags();
                }
                MenuSeparator {
                    parent: header
                    width: parent.width
                    anchors.verticalCenter: parent.bottom
                    visible: !menu.atYBeginning
                }
            }
            //model: 50

            delegate: ItemDelegate {
                //text: qsTr("%1").arg(parser.getTags().at(index))
                text: modelData
                width: parent.width
                onClicked: {
                    var newObject = Qt.createQmlObject('Graph {anchors.fill: widgets;}',
                                                       widgets,
                                                       "dynamicSnippet1");
                    newObject.addSeries ("ffff");
                    widgets.addWidget(newObject);
                    //widgets.push(newObject);
                    //widgets.setCurrentIndex(0);
                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }

        }
    }
//    Button {
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        onClicked: {
//            //d.addSeries ("ffff");

//            for(var i = 0; i < parser.getTags().length; i++)
//            {
//               console.debug(parser.getTags()[i]);
//               console.debug(parser.getTags().length);
//            }
//            menu.model = parser.getTags();
//        }
//    }
    //StackView
//    SwipeView
//    {
//        id: widgets
//        anchors.fill: parent;
//        Rectangle {
//            anchors.fill: widgets;
//            color: 'red';
//        }
//        GpsTracker {
//            anchors.fill: widgets
//        }
////        Graph {
////            id: d
////        }
//    }

    StackView {
        id: paneStack
        anchors.fill: parent;
        initialItem: widgetPane
        Pane {
            id: widgetPane
            anchors.fill: parent;
            padding: 0
            WidgetsWorkspace {
                id: widgets
                anchors.fill: parent
            }
        }
    }
//    Pane {
//        id: openFilePane
//        anchors.fill: parent;
//        TextInput {
//          text: 'Соси жопу'
//        }
//    }
//    Pane {
//        id: addWidgetPane
//        anchors.fill: parent;
//    }
}
