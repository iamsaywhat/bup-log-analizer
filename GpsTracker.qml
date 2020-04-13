import QtQuick 2.0
import QtQuick.Controls 2.13
import QtLocation 5.13
import QtPositioning 5.13


Item {
    id: root

    property MapPolyline track

    function createTrack(path){
        track.setPath(path);

    }
    function clearMap (){
        map.clearMapItems();
    }
    function createTarget(position){

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
        center: QtPositioning.coordinate(59.652309, 30.018348, 3048);
        //center: positionSource.position.coordinate
        zoomLevel: 14
        property MapCircle circle
        onCenterChanged: {
//            console.debug(center)
//            circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
//            circle.center = map.center
//            circle.radius = 300.0
//            circle.color = 'green'
//            circle.border.width = 3
//            map.addMapItem(circle)
            createTrack(parser.getTrack("Model_Lat, deg: ", "Model_Lon, deg: ",  "Model_Alt, m: "));
        }
        MapPolyline {
            id: track
            line.width: 5
            line.color: 'green'
        }
        MapCircle {
            center: QtPositioning.coordinate(-27, 153.0)
            radius: 300
            opacity: 0.5
            color: 'green'
        }
    }

}
