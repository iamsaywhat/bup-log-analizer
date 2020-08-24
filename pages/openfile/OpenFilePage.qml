import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.13

Item {
    id: root

    signal closeButtonClick()

    Pane {
        id: pane
        anchors.fill: parent;
        padding: 0
        ListView {
            id: files
            anchors.fill: parent
            model: fileSystemModel
            delegate: ItemDelegate {
                id: delegate
                width: parent.width
                onClicked: {
                    if(dir || dir_up || drive)
                        fileSystemModel.cd(fullPath);
                    else {
                        parser.openFile(fullPath);
                        closeButtonClick();
                    }
                }
                RowLayout {
                    anchors.fill: parent
                    spacing: 10
                    anchors.margins: 5

                    Image{
                        id: icon

                        fillMode: Image.PreserveAspectFit
                        Layout.fillHeight: true
                        Component.onCompleted: {
                            if(dir)
                                source = "qrc:/icons/to_folder.png";
                            else if(dir_up)
                                source = "qrc:/icons/out_folder.png";
                            else if(drive)
                                source = "qrc:/icons/drives.png";
                            else
                                source = "qrc:/icons/file.png";
                        }
                    }
                    Label{
                        id: label
                        Layout.fillWidth: true
                        text: name
                    }
                }
            }
            ScrollIndicator.vertical: ScrollIndicator { }
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
                anchors.margins: 5
                source: "qrc:/icons/close.png"
                fillMode: Image.PreserveAspectFit

            }
        }
    }
}
