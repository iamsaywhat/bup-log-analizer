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
    trackToSeries();
    if(file.isOpen())
        file.close();
    emit fileOpen(path);

    QList<Series*>::const_iterator i;
    for(i = series.cbegin(); i != series.cend(); ++i)
    {
        if((*i)->name == "course")
        {
            for(int j = 0; j < ((*i)->value.size()); j++)
                qDebug() << (*i)->value.at(j);
            break;
        }
    }

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
    else if (object.keys().contains("series")) {
        QJsonValue timestamp = object.value("time");
        QJsonArray values = object.value("series").toArray();
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
void BupLogParser::trackToSeries(void){
    if(track.size() > 0){
        Series *latitude = new Series;
        Series *longitude = new Series;
        Series *altitude = new Series;
        latitude->name = "track.latitude";
        longitude->name = "track.longitude";
        altitude->name = "track.altitude";

        QList<GeoTrack>::const_iterator i;
        for(i = track.cbegin(); i != track.cend(); ++i) {
           latitude->timestamp.append((*i).timestamp);
           longitude->timestamp.append((*i).timestamp);
           altitude->timestamp.append((*i).timestamp);

           latitude->step.append((*i).step);
           longitude->step.append((*i).step);
           altitude->step.append((*i).step);

           latitude->value.append((*i).coordinate.latitude());
           longitude->value.append((*i).coordinate.longitude());
           altitude->value.append((*i).coordinate.altitude());
        }
        series.append(latitude);
        series.append(longitude);
        series.append(altitude);
    }
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
QGeoCoordinate BupLogParser::getPoint(QString name) {
    int index = 0;
    for (; index < points.count(); index++) {
        if (points.at(index).name == name)
            break;
    }
    if (index == points.count())
        return QGeoCoordinate();
    else
        return points.at(index).point;

}
QStringList BupLogParser::getSeriesList(void){
    QStringList names;
    for(int i = 0; i < series.count(); i++)
        names.append(series.at(i)->name);
    return names;
}
QGeoPath BupLogParser::getTrack(void)
{
    QGeoPath geoPath;
    geoPath.setWidth(5);
    for (int i = 0; i < track.count(); i++)
        geoPath.addCoordinate(track.at(i).coordinate);
    return geoPath;
}
