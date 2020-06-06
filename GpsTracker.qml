import QtQuick 2.0
import QtQuick.Controls 2.13
import QtLocation 5.13
import QtPositioning 5.13


Item {
    id: root
    function createTrack(path, color){
        var track = Qt.createQmlObject('import QtLocation 5.13; MapPolyline {}', map);
        track.line.width = 5;
        track.line.color = color;
        track.setPath(path);
        map.center = path.coordinateAt(0);
        map.addMapItem(track);
    }
    function clearMap (){
        map.clearMapItems();
    }
    function createCircle(coordinate, radius, opacity, color){
        var circle = Qt.createQmlObject('import QtLocation 5.13; MapCircle {}', map)
        circle.center = coordinate;
        circle.radius = radius;
        circle.opacity = opacity;
        circle.color = color;
        circle.border.width = 2;
        map.addMapItem(circle);
        map.center = circle.center;
    }
    Plugin {
         id: mapPlugin
         name: "osm"
         PluginParameter {
             name: "osm.mapping.host";
             value: "http://a.tile.openstreetmap.org/"
         }
    }
    Map
    {
        id: map
        anchors.fill: root
        plugin: mapPlugin
        zoomLevel: 14
    }
    Item {
        id: instruments
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        width: 40
        height: width*2
//            Item {
//                id: zoom
            Button {
                id: zoomIn
                width: parent.width
                height: width
                anchors.top: parent.top
                onClicked: {
                    map.zoomLevel = map.zoomLevel + 1
                }
                Image {
                    id: zoomInIcon
                    source: "qrc:/icons/zoom_in.png"
                    anchors.fill: parent
                    anchors.margins: 5

                }
            }
            Button {
                id: zoomOut
                width: parent.width
                height: width
                anchors.top: zoomIn.bottom
                onClicked: {
                    map.zoomLevel = map.zoomLevel - 1
                }
                Image {
                    id: zoomOutIcon
                    source: "qrc:/icons/zoom_out.png"
                    anchors.fill: parent
                    anchors.margins: 5
                }
            }
//            }
    }

}
