#include "buplogparser.h"
#include <QDebug>
#include <QDir>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>


BupLogParser::BupLogParser(QObject *parent) : QObject(parent){

}
BupLogParser::~BupLogParser(void){
    clear();
    if(file.isOpen())
        file.close();
}
void BupLogParser::clear(void){
    warnings.clear();
    points.clear();
    for(int i = 0; i < series.count(); i++)
        delete series.at(i);
    series.clear();
    track.clear();
}
bool BupLogParser::openFile(QString path){     
    bool status = false;
    clear();
    if(file.exists(path)){
        file.setFileName(path);
        if(file.open(QIODevice::ReadOnly)){
            while(!file.atEnd())
                parseLine(file.readLine());
            status = true;
        }
    }
    if(file.isOpen())
        file.close();

    qDebug() << "Warnings:";
    for(int i = 0; i < warnings.count(); i++)
        qDebug() << warnings.at(i).timestamp << warnings.at(i).text;
    qDebug() << "Points:";
    for(int i = 0; i < points.count(); i++)
        qDebug() << points.at(i).timestamp << points.at(i).name << points.at(i).point;
     qDebug() << "Series:";
    for(int i = 0; i < series.count(); i++)
        qDebug() << series.at(i)->name << series.at(i)->value << series.at(i)->step;
    for(int i = 0; i < track.count(); i++)
        qDebug() << track.at(i).timestamp << track.at(i).coordinate;

    fileOpen(path);
    return status;
}
void BupLogParser::parseLine(QString line){
    QJsonObject object = QJsonDocument::fromJson(line.toLatin1()).object();
    if (object.keys().contains("warning")) {
        QJsonValue timestamp = object.value("time");
        QJsonArray values = object.value("warning").toArray();
        Warning data;
        data.timestamp = timestamp.toInt();
        data.text = values.at(0).toString();
        warnings.append(data);
    }
    else if (object.keys().contains("point")) {
        QJsonValue timestamp = object.value("time");
        QJsonArray values = object.value("point").toArray();
        Point data;
        data.timestamp = timestamp.toInt();
        data.name = values.at(0).toString();
        data.point.setLatitude(values.at(1).toDouble());
        data.point.setLongitude(values.at(2).toDouble());
        data.point.setAltitude(values.at(3).toDouble());
        points.append(data);
    }
    else if (object.keys().contains("serial")) {
        QJsonValue timestamp = object.value("time");
        QJsonArray values = object.value("serial").toArray();
        QString name = values.at(0).toString();
        int index;
        for( index = 0; index < series.count(); index++) {
            if (series.at(index)->name == name)
                break;
        }
        if (index == series.count()) {
            Series *data = new Series;
            data->name = name;
            series.append(data);
        }
        series.at(index)->timestamp.append(timestamp.toInt());
        series.at(index)->step.append(values.at(1).toDouble());
        series.at(index)->value.append(values.at(2).toDouble());
    }
    else if (object.keys().contains("track")) {
        QJsonValue timestamp = object.value("time");
        QJsonArray values = object.value("track").toArray();
        GeoTrack data;
        data.timestamp = timestamp.toInt();
        data.step = values.at(0).toDouble();
        data.coordinate.setLatitude(values.at(1).toDouble());
        data.coordinate.setLongitude(values.at(2).toDouble());
        data.coordinate.setAltitude(values.at(3).toDouble());
        track.append(data);
    }
}
QGeoPath BupLogParser::getTrack(QString latitudeTag,
                                QString longitudeTag,
                                QString altitudeTag)
{
    QGeoPath geoPath;
    geoPath.setWidth(5);
    for (int i = 0; i < track.count(); i++)
        geoPath.addCoordinate(track.at(i).coordinate);
    return geoPath;
}

QList<QPointF> BupLogParser::createSeries(QString xTag, QString yTag){
     QList<QPointF> lineSeries;
     Series* xData = nullptr;
     Series* yData = nullptr;

     for (int i = 0; i < series.count(); i++) {
         if(series.at(i)->name == xTag)
             xData = series.at(i);
     }
     for (int i = 0; i < series.count(); i++) {
         if(series.at(i)->name == yTag)
             yData = series.at(i);
     }
     if (xData == nullptr || yData == nullptr)
         return lineSeries;

     for (int i = 0; i < xData->step.count() &&
                     i < yData->step.count(); i++) {
         int xIndex = xData->step.indexOf(i);
         int yIndex = yData->step.indexOf(i);
         if (xIndex != -1 && yIndex != -1) {
             double xStep = xData->value.at(xIndex);
             double yStep = yData->value.at(yIndex);
             lineSeries.append(QPointF(xStep, yStep));
         }
     }
    return lineSeries;
}
void BupLogParser::getSeries(QtCharts::QAbstractSeries *series, QString xTag, QString yTag){
    QtCharts::QXYSeries *xySeries = static_cast<QtCharts::QXYSeries *>(series);
    xySeries->clear();
    xySeries->append(createSeries(xTag, yTag));
//    for(int i = 0; i < xySeries->count(); i++)
//        qDebug() << xySeries->at(i);
}
QStringList BupLogParser::getWarningsList(void){
    QStringList l;
    return l;
}
QStringList BupLogParser::getPointsList(void){
    QStringList names;
    for(int i = 0; i < points.count(); i++)
        names.append(points.at(i).name);
    return names;
}
QStringList BupLogParser::getSeriesList(void){
    QStringList names;
    for(int i = 0; i < series.count(); i++)
        names.append(series.at(i)->name);
    return names;
}
