#include "buplogparser.h"
#include <QDebug>
#include <QDir>


BupLogParser::BupLogParser(QObject *parent) : QObject(parent){

}

BupLogParser::~BupLogParser(void){
    clear();
    if(file.isOpen())
        file.close();
}
void BupLogParser::clear(void){
    for(int i = 0; i < data.count(); i++) {
        QStringList *tagData = data.at(i);
        delete  tagData;
    }
}
void BupLogParser::setTags(QStringList& list){
    tags = list;
    clear();
    for(int i = 0; i < tags.count(); i++){
        QStringList *tagData = new  QStringList;
        data.append(tagData);
    }
}
bool BupLogParser::setFile(QString path){
    if(file.exists(path)){
        file.setFileName(path);
        return true;
    }
    else
        return false;
}
void BupLogParser::runParsing(void){
    if (file.open(QIODevice::ReadOnly)){
        while(!file.atEnd()){
            QString line = file.readLine();
            for(int i = 0; i < tags.count(); i++){
                if(line.contains(tags.at(i))){
                    line.remove(0, tags.at(i).count());
                    data.at(i)->append(line);
                    break;
                }
            }
        }
    }
    if(file.isOpen())
        file.close();

    qDebug() << *data.at(0);
    qDebug() << *data.at(1);
}
QGeoPath BupLogParser::getTrack(QString latitudeTag,
                                             QString longitudeTag,
                                             QString altitudeTag)
{
    QList<QGeoCoordinate> track;
    int latitudeIndex = tags.indexOf(latitudeTag);
    int longitudeIndex = tags.indexOf(longitudeTag);
    int altitudeIndex = tags.indexOf(altitudeTag);

    if(latitudeIndex == -1 || longitudeIndex == -1 || altitudeIndex == -1)
        return track;

    for(int i = 0; i < data.at(latitudeIndex)->size(); i++){
        double latitude = data.at(latitudeIndex)->at(i).toDouble();
        double longitude = data.at(longitudeIndex)->at(i).toDouble();
        double altitude = data.at(altitudeIndex)->at(i).toDouble();
        track.append(QGeoCoordinate(latitude, longitude, altitude));
    }
    for(int i = 0; i < track.count(); i++){
    qDebug() << track.at(i);
    }
    return QGeoPath(track);
    QGeoPath path;
//    path.addCoordinate(QGeoCoordinate(59.585949, 29.615652));
//    path.addCoordinate(QGeoCoordinate(59.652309, 30.018348));
//    return path;
}
