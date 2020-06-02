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

}
