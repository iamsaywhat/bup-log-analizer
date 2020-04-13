import QtQuick 2.12
import QtCharts 2.12

Item {
    id: root
    anchors.fill: parent

    property real autoscaleMinX: 0
    property real autoscaleMaxX: 0
    property real autoscaleMinY: 0
    property real autoscaleMaxY: 0

    // Add series data to chart
    function addSeries (name){
        var lineSeries = chartView.createSeries(ChartView.SeriesTypeLine, name, axisX, axisY);
        parser.getSeries(lineSeries);

        // Update max min X-axes for autoscale
        if(chartView.count == 1) // the first data appended have to initialiize autoscale vars
            autoscaleMinX = lineSeries.at(0).x;
        else
            if(autoscaleMinX  > lineSeries.at(0).x)
                autoscaleMinX = lineSeries.at(0).x;
        if(autoscaleMaxX < lineSeries.at(lineSeries.count-1).x)
            autoscaleMaxX = lineSeries.at(lineSeries.count-1).x;

        // Update max min Y-axes for autoscale
        if(chartView.count == 1){ // the first data appended have to initialiize autoscale vars
            autoscaleMinY = lineSeries.at(0).y;
            autoscaleMaxY = lineSeries.at(0).y;
        }
        for(var i = 0; i < lineSeries.count; i++){
            if(autoscaleMinY > lineSeries.at(i).y)
                autoscaleMinY = lineSeries.at(i).y;
            if(autoscaleMaxY < lineSeries.at(i).y)
                autoscaleMaxY = lineSeries.at(i).y;
        }
    }
    // Clear axes
    function clear(){
        chartView.removeAllSeries();
        autoscaleMinX = 0;
        autoscaleMaxX = 0;
        autoscaleMinY = 0;
        autoscaleMaxY = 0;
    }
    ChartView {
        id: chartView
        anchors.fill: parent
        antialiasing: true
        theme: ChartView.ChartThemeDark

        ValueAxis {
            id: axisX
            min: autoscaleMinX
            max: autoscaleMaxX
        }
        ValueAxis {
            id: axisY
            min: autoscaleMinY
            max: autoscaleMaxY
        }
    }
    MouseArea {
        anchors.fill: parent
        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                autoscaleMinX = autoscaleMinX + (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;
                autoscaleMaxX = autoscaleMaxX - (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;
            }
            else if (wheel.modifiers & Qt.ShiftModifier) {
                autoscaleMinY = autoscaleMinY + (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                autoscaleMaxY = autoscaleMaxY - (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
            }
            else {
                autoscaleMinX = autoscaleMinX + (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;
                autoscaleMaxX = autoscaleMaxX - (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;
                autoscaleMinY = autoscaleMinY + (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                autoscaleMaxY = autoscaleMaxY - (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
            }
        }
    }
}
