import QtQuick 2.12
import QtCharts 2.12

Item {
    id: root
    anchors.fill: parent

    function addData (){
        chartView.removeAllSeries();
        var lineSeries = chartView.createSeries(ChartView.SeriesTypeLine,
                                                "bup",
                                                axisX,
                                                axisY);
        parser.qwertyupdate(lineSeries);
    }

    ChartView {
        id: chartView
        anchors.fill: parent
        antialiasing: true
        theme: ChartView.ChartThemeDark

        ValueAxis {
            id: axisX
            min: 0
            max: 10
        }
        ValueAxis {
            id: axisY
            min: 0
            max: 10

        }
    }

}
