import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: root

    signal closeButtonClick()

    Pane {
        id: pane
        anchors.fill: parent;
        padding: 0
//        Rectangle {
//            color: 'blue'
//            anchors.fill: parent
//        }
        ListView {
            id: files
            anchors.fill: parent
//            header: Pane {
//                id:header
//                width: parent.width
//                contentHeight: delegate.height
//                padding: 0
//                Button {
//                    id: upButton
//                    spacing: 0
//                    padding: 0
//                    width: parent.width
//                    text: qsTr('...')
//                    onClicked: {
//                        fileSystemModel.cdUp();
//                    }
////                    background: Rectangle {
////                        anchors.fill: parent
////                        color: 'red'
////                    }
//                }
//            }

            model: fileSystemModel
            delegate: ItemDelegate {
                id: delegate
                text: name
                width: parent.width
                onClicked: {
                    if(dir || dir_up || drive)
                        fileSystemModel.cd(fullPath);
                    else {
                        parser.openFile(fullPath);
                        closeButtonClick();
                    }
                }
//                Rectangle {
//                    id: background
//                    anchors.fill: parent
//                    color: dir ? 'red' : 'blue'
//                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
        }
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
