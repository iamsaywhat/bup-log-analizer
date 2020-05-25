import QtQuick 2.0
import QtQuick.Controls 2.13
import QtLocation 5.13
import QtPositioning 5.13


Item {
    id: root

    property MapPolyline track

    function createTrack(path){
        console.debug("add thact");
        var track = Qt.createQmlObject('import QtLocation 5.13; MapPolyline {}', map);
        track.line.width = 5;
        track.line.color = 'green';
        track.setPath(path);
        map.center = path.coordinateAt(0);
        map.addMapItem(track);
    }
    function clearMap (){
        map.clearMapItems();
    }
    function createCircle(latitude, longitude, radius, opacity, color){
        var circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', map)
        circle.center = QtPositioning.coordinate(-27, 153.0)
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
        center: QtPositioning.coordinate(59.652309, 30.018348, 3048);
        //center: positionSource.position.coordinate
        zoomLevel: 14
    }

}
