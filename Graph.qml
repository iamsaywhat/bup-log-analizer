import QtQuick 2.12
import QtCharts 2.12

Item {
    id: root
    //anchors.fill: parent

    property real autoscaleMinX: 0
    property real autoscaleMaxX: 1
    property real autoscaleMinY: 0
    property real autoscaleMaxY: 1
    property real zoomCoefficient: 3
    property real deltaX: 0
    property real deltaY: 0
    property bool dragAndMove: false

    // Add series data to chart
    function addSeries (name, xname, yname){
        var lineSeries = chartView.createSeries(ChartView.SeriesTypeLine, name, axisX, axisY);
        parser.getSeries(lineSeries, xname, yname);
        // Update max min X-axes for autoscale
        if(chartView.count === 1) // the first data appended have to initialiize autoscale vars
            autoscaleMinX = lineSeries.at(0).x;
        else
            if(autoscaleMinX  > lineSeries.at(0).x)
                autoscaleMinX = lineSeries.at(0).x;
        if(autoscaleMaxX < lineSeries.at(lineSeries.count-1).x)
            autoscaleMaxX = lineSeries.at(lineSeries.count-1).x;

        // Update max min Y-axes for autoscale
        if(chartView.count === 1){ // the first data appended have to initialiize autoscale vars
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
        autoscaleMaxX = 1;
        autoscaleMinY = 0;
        autoscaleMaxY = 1;
    }

    ChartView {
        id: chartView
        antialiasing: true
//        theme: ChartView.ChartThemeDark

        anchors { fill: parent; margins: -10 }             // This is hack for removing  weird margins or spacing
//        margins { right: 0; bottom: 0; left: 0; top: 0 } // In the future i'll found another way to fix it

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
        id: mouseArea
        anchors.fill: parent

        function cursorPositionToAxisXY (){
            var x = mouseX - (chartView.plotArea.x - 10);
            var xScale = Math.abs(autoscaleMaxX - autoscaleMinX)/chartView.plotArea.width;
            var y = chartView.plotArea.height - (mouseY - (chartView.plotArea.y - 10));
            var yScale = Math.abs(autoscaleMaxY - autoscaleMinY)/chartView.plotArea.height;
            return Qt.point(x * xScale + autoscaleMinX, y * yScale + autoscaleMinY);
        }

        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                //autoscaleMinX = autoscaleMinX + zoomCoefficient * (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;
                //autoscaleMaxX = autoscaleMaxX - zoomCoefficient * (autoscaleMaxX - autoscaleMinX)/wheel.angleDelta.y;

                chartView.zoomIn();
            }
            else if (wheel.modifiers & Qt.ShiftModifier) {
                //autoscaleMinY = autoscaleMinY + zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                //autoscaleMaxY = autoscaleMaxY - zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;

                chartView.zoomOut();
            }
            else {

                //autoscaleMinX = autoscaleMinX + zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                //autoscaleMaxX = autoscaleMaxX - zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                //autoscaleMinY = autoscaleMinY + zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                //autoscaleMaxY = autoscaleMaxY - zoomCoefficient * (autoscaleMaxY - autoscaleMinY)/wheel.angleDelta.y;
                chartView.zoomReset();
            }
            console.debug("wheel");
        }
        onPressed: {
            dragAndMove = true;
            deltaX = cursorPositionToAxisXY().x;
            deltaY = cursorPositionToAxisXY().y;
        }
        onReleased: {
            dragAndMove = false;
            deltaX = 0;
            deltaY = 0;
        }
        onMouseXChanged: {
            if(dragAndMove){
                autoscaleMinX += deltaX - cursorPositionToAxisXY().x;
                autoscaleMaxX += deltaX - cursorPositionToAxisXY().x;
                deltaX = cursorPositionToAxisXY().x;

                autoscaleMinY += deltaY - cursorPositionToAxisXY().y;
                autoscaleMaxY += deltaY - cursorPositionToAxisXY().y;
                deltaY = cursorPositionToAxisXY().y;
            }
        }
    }
}
