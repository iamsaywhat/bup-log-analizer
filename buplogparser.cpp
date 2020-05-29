#include "buplogparser.h"
#include <QDebug>
#include <QDir>
#include <QJsonObject>
#include <QJsonDocument>


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

    fileOpen(path);
    return status;
}
void BupLogParser::parseLine(QString line){
    QJsonObject object = QJsonDocument::fromJson(line.toLatin1()).object();
    if(!object.isEmpty() &&  object.keys().contains("type")){
        QJsonValue type = object.value("type");
        if(type == "warning"){
            Warning data;
            data.timestamp = object.value("systime").toInt();
            data.text = object.value("text").toString();
            warnings.append(data);
        }
        else if(type == "point"){
            Point data;
            data.name = object.value("name").toString();
            data.timestamp = object.value("systime").toInt();
            data.point.setLatitude(object.value("lat").toDouble());
            data.point.setLongitude(object.value("lon").toDouble());
            data.point.setAltitude(object.value("alt").toDouble());
            points.append(data);
        }
        else if(type == "serial"){
            int index;
            for(index = 0; index < series.count(); index++){
                if(series.at(index)->name == object.value("name").toString())
                    break;
            }
            if(index == series.count()){
                Series *data = new Series;
                data->name = object.value("name").toString();
                series.append(data);
            }
            series.at(index)->timestamp.append(object.value("systime").toInt());
            series.at(index)->step.append(object.value("step").toDouble());
            series.at(index)->value.append(object.value("value").toDouble());
        }
    }
}
QGeoPath BupLogParser::getTrack(QString latitudeTag,
                                QString longitudeTag,
                                QString altitudeTag)
{
    QList<QGeoCoordinate> track;

    Series* latitude = nullptr;
    Series* longitude = nullptr;
    Series* altitude = nullptr;

    for (int i = 0; i < series.count(); i++) {
        if(series.at(i)->name == latitudeTag)
            latitude = series.at(i);
    }
    for (int i = 0; i < series.count(); i++) {
        if (series.at(i)->name == longitudeTag)
            longitude = series.at(i);
    }
    for (int i = 0; i < series.count(); i++) {
        if (series.at(i)->name == altitudeTag)
            altitude = series.at(i);
    }

    if (latitude == nullptr || longitude == nullptr || altitude == nullptr)
        return track;

    for (int i = 0; i < latitude->step.count() &&
                    i < longitude->step.count() &&
                    i < altitude->step.count(); i++) {
        int latitudeIndex = latitude->step.indexOf(i);
        int longitudeIndex = longitude->step.indexOf(i);
        int altitudeIndex = altitude->step.indexOf(i);
        if (latitudeIndex != -1 && longitudeIndex != -1 && altitudeIndex != -1) {
            double latitudeStep = latitude->value.at(latitudeIndex);
            double longitudeStep = longitude->value.at(longitudeIndex);
            double altitudeStep = altitude->value.at(altitudeIndex);
            track.append(QGeoCoordinate(latitudeStep, longitudeStep, altitudeStep));
        }
    }
    for(int i = 0; i < track.count(); i++)
        qDebug() << track.at(i);
    return QGeoPath(track);
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
    for(int i = 0; i < points.count(); i++)
        names.append(series.at(i)->name);
    return names;
}
