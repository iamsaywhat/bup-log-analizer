import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.12
import QtQuick.Layouts 1.13

Item {
    id: root
    property real autoscaleMinX: 0
    property real autoscaleMaxX: 1
    property real autoscaleMinY: 0
    property real autoscaleMaxY: 1

    property real currentMinX: 0
    property real currentMaxX: 1
    property real currentMinY: 0
    property real currentMaxY: 1

    property real zoomCoefficient: 3
    property real deltaX: 0
    property real deltaY: 0
    property bool dragAndMove: false
    property color buttonColor: 'black'

    // Add series data to chart
    function addSeries (name, xname, yname){
        var lineSeries = chartView.createSeries(ChartView.SeriesTypeLine, name, axisX, axisY);
        parser.getSeries(lineSeries, xname, yname);   // get filled lineSeries

        // check that lineSeries is not empty
        if (lineSeries.count > 0) {
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
            axisX.tickInterval = multipleGridInterval(autoscaleMinX, autoscaleMaxX);
            axisY.tickInterval = multipleGridInterval(autoscaleMinY, autoscaleMaxY);

            currentMinX = autoscaleMinX;
            currentMaxX = autoscaleMaxX;
            currentMinY = autoscaleMinY;
            currentMaxY = autoscaleMaxY;
        }
        else {
            // if lineSeries is empty - remove that
            chartView.removeSeries(lineSeries);
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
    // Calculate multiple axis inteval
    function multipleGridInterval (lower, upper) {
        var interval = Math.abs(lower - upper) / 10;  // i want ~10 tick
        if(interval > 0) {
            var scale;
            for(scale = 0; interval < 1; scale++)
                interval *= 10;
            interval = Math.ceil(interval);
            if(interval % 2 < interval % 5)
                interval -= interval % 2;
            else
                interval -= interval % 5;
            interval = interval / Math.pow(10, scale);
        }
        else
            interval = 0;
        return interval;
    }
    // Convert cursor position to axis data
    function cursorPositionToAxisXY (){
        var x = mouseArea.mouseX - (chartView.plotArea.x - 10);
        var xScale = Math.abs(autoscaleMaxX - autoscaleMinX)/chartView.plotArea.width;
        var y = chartView.plotArea.height - (mouseArea.mouseY - (chartView.plotArea.y - 10));
        var yScale = Math.abs(autoscaleMaxY - autoscaleMinY)/chartView.plotArea.height;
        return Qt.point(x * xScale + autoscaleMinX, y * yScale + autoscaleMinY);
    }
    // Zoom to oginal view
    function autoScale () {
        currentMinX = autoscaleMinX;
        currentMaxX = autoscaleMaxX;
        currentMinY = autoscaleMinY;
        currentMaxY = autoscaleMaxY;
        axisX.tickInterval = multipleGridInterval(autoscaleMinX, autoscaleMaxX);
        axisY.tickInterval = multipleGridInterval(autoscaleMinY, autoscaleMaxY);
    }
    ChartView {
        id: chartView
        antialiasing: true
//        theme: ChartView.ChartThemeDark

        anchors { fill: parent; margins: -10 }             // This is hack for removing  weird margins or spacing
//        margins { right: 0; bottom: 0; left: 0; top: 0 } // In the future i'll found another way to fix it

        ValueAxis {
            id: axisX
            min: currentMinX
            max: currentMaxX
            tickType: ValueAxis.TicksDynamic
            tickAnchor: 0
            tickInterval: 1
        }
        ValueAxis {
            id: axisY
            min: currentMinY
            max: currentMaxY
            tickType: ValueAxis.TicksDynamic
            tickAnchor: 0
            tickInterval: 1

        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onWheel: {
            if (wheel.modifiers & Qt.ControlModifier) {
                currentMinX = currentMinX + zoomCoefficient * (currentMaxX - currentMinX)/wheel.angleDelta.y;
                currentMaxX = currentMaxX - zoomCoefficient * (currentMaxX - currentMinX)/wheel.angleDelta.y;
                axisX.tickInterval = multipleGridInterval(currentMinX, currentMaxX);
            }
            else if (wheel.modifiers & Qt.ShiftModifier) {
                currentMinY = currentMinY + zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                currentMaxY = currentMaxY - zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                axisY.tickInterval = multipleGridInterval(currentMinY, currentMaxY);
            }
            else {
                if (verticalZoom.checked) {
                    currentMinY = currentMinY + zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    currentMaxY = currentMaxY - zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    axisY.tickInterval = multipleGridInterval(currentMinY, currentMaxY);
                }
                else if (horizontalZoom.checked) {
                    currentMinX = currentMinX + zoomCoefficient * (currentMaxX - currentMinX)/wheel.angleDelta.y;
                    currentMaxX = currentMaxX - zoomCoefficient * (currentMaxX - currentMinX)/wheel.angleDelta.y;
                    axisX.tickInterval = multipleGridInterval(currentMinX, currentMaxX);
                }
                else if (allZoom.checked) {
                    currentMinX = currentMinX + zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    currentMaxX = currentMaxX - zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    currentMinY = currentMinY + zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    currentMaxY = currentMaxY - zoomCoefficient * (currentMaxY - currentMinY)/wheel.angleDelta.y;
                    axisX.tickInterval = multipleGridInterval(currentMinX, currentMaxX);
                    axisY.tickInterval = multipleGridInterval(currentMinY, currentMaxY);
                }
            }
        }
        onPressed: {
            if(mouse.button === Qt.LeftButton) {
                dragAndMove = true;
                var cursor = cursorPositionToAxisXY();
                deltaX = cursor.x;
                deltaY = cursor.y;
                cursorShape = Qt.ClosedHandCursor;
                if (rightClickMenu.visible)
                    rightClickMenu.visible = false;
            }
            else if (mouse.button === Qt.RightButton) {
                rightClickMenu.visible = true;
                rightClickMenu.x = mouseX;
                rightClickMenu.y = mouseY;
            }
            else {
                if (rightClickMenu.visible)
                    rightClickMenu.visible = false;
            }
        }
        onReleased: {
            if(mouse.button === Qt.LeftButton) {
                dragAndMove = false;
                cursorShape = Qt.OpenHandCursor;
            }
        }
        onMouseXChanged: {
            if(dragAndMove && containsMouse){
                var cursor = cursorPositionToAxisXY(); // get current postion
                currentMinX += deltaX - cursor.x;
                currentMaxX += deltaX - cursor.x;
                currentMinY += deltaY - cursor.y;
                currentMaxY += deltaY - cursor.y;
                cursor = cursorPositionToAxisXY();     // update cursor
                deltaX = cursor.x;                     // fixing the new value
                deltaY = cursor.y;
            }
        }
    }
    Rectangle {
        id: rightClickMenu
        visible: false
        width: 150
        opacity: 0.7
        color: 'black'
        height: 150
        radius: 5
        ColumnLayout {
            id: rightMenuLayout
            anchors.fill: parent
            spacing: 0
            anchors.margins: 0
            Button {
                id: originalView
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr("Reset to original view")
                background: Rectangle {
                    anchors.fill:parent
                    color: rightClickMenu.color
                    opacity: parent.hovered ? 0.3 : 0
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: 'white'
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onClicked: autoScale();
            }
            MenuSeparator {
                Layout.fillWidth: true
                spacing: 0
            }
            Button {
                id: verticalZoom
                Layout.fillWidth: true
                Layout.fillHeight: true
                checkable: true
                text: qsTr("Vertical zoom")
                background: Rectangle {
                    anchors.fill:parent
                    color: rightClickMenu.color
                    opacity: parent.checked ? 0.3 : 0
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: 'white'
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onPressed: {
                    horizontalZoom.checked = false;
                    allZoom.checked = false;
                }
            }
            Button {
                id: horizontalZoom
                Layout.fillWidth: true
                Layout.fillHeight: true
                checkable: true
                text: qsTr("Horizontal zoom")
                background: Rectangle {
                    anchors.fill:parent
                    color: rightClickMenu.color
                    opacity: parent.checked ? 0.3 : 0
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: 'white'
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onPressed: {
                    verticalZoom.checked = false;
                    allZoom.checked = false;
                }
            }
            Button {
                id: allZoom
                Layout.fillWidth: true
                Layout.fillHeight: true
                checkable: true
                checked: true
                text: qsTr("Zoom")
                background: Rectangle {
                    anchors.fill:parent
                    color: rightClickMenu.color
                    opacity: parent.checked ? 0.3 : 0
                }
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: 'white'
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onPressed: {
                    horizontalZoom.checked = false;
                    verticalZoom.checked = false;
                }
            }
        }
    }
}
