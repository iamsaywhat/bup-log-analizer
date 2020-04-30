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
void BupLogParser::clear(void){                  // Здесь производим гарантированное освобождение памяти
    for(int i = 0; i < data.count(); i++) {      // data содержит список указателей на динамически создаваемые списки
        QStringList *tagData = data.at(i);       // проходим по всем указателям и освобождаем память
        delete  tagData;
    }
}
void BupLogParser::setTags(QStringList& list){
    tags = list;                                     // Размещаем список тэгов
    clear();                                         // Освобождаем память (если есть что освобождать
    for(int i = 0; i < tags.count(); i++){           // по количеству тэгов начинаем динамически создавать
        QStringList *tagData = new  QStringList;     // списки данных
        data.append(tagData);                        // и сохранять их указатели в контейнер
    }
}
QStringList BupLogParser::getTags(void){
    return tags;
}




bool BupLogParser::openFile(QString path){
    if(file.exists(path)){
        file.setFileName(path);    
        QStringList tagList;
        tagList << "Timestamp, sec: " << "SNS_Lat: " << "SNS_Lon: " << "SNS_Alt: " << "SNS_Vel_lat: " << "SNS_Vel_lon: " <<
                "SNS_Vel_alt: " << "SNS_Course: " << "SNS_Heading_true: " << "SNS_Heading_mgn: " << "SNS_Pitch: " <<
                "SNS_Roll: " << "SWS_TrueSpeed: " << "SWS_InstrumentSpeed: " << "BIML_Pos: " << "BIMR_Pos: " << "SystemState: "
                "Model_Lat, deg: " << "Model_Lon, deg: " << "Model_Alt, m: " << "Model_VelocityLat, m/s: " << "Model_VelocityLon, m/s: " <<
                "Model_VelocityAlt, m/s: " << "Model_HeadingTrue, rad: " << "Model_HeadingMgn, rad: " << "Model_Course, rad: " <<
                "Model_Pitch, rad: " << "Model_Roll, rad: " << "MAP, m: " << "Model_BIM_CMD: " << "Model_TD_CMD: ";
        setTags(tagList);
        runParsing();
        emit fileOpen();
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
//    for(int i = 0; i < track.count(); i++)
//        qDebug() << track.at(i);
    return QGeoPath(track);
}
QList<QPointF> BupLogParser::createSeries(QString xTag, QString yTag){
     QList<QPointF> series;
     int xIndex = tags.indexOf(xTag);
     int yIndex = tags.indexOf(yTag);

     if(xIndex == -1 || yIndex == -1)
         return series;

     for(int i = 0; i < data.at(xIndex)->size(); i++){
         double x = data.at(xIndex)->at(i).toDouble();
         double y = data.at(yIndex)->at(i).toDouble();
         series.append(QPointF(x,y));
     }
     return series;
}
void BupLogParser::getSeries(QtCharts::QAbstractSeries *series, QString xTag, QString yTag){
    QtCharts::QXYSeries *xySeries = static_cast<QtCharts::QXYSeries *>(series);
    xySeries->clear();
    xySeries->append(createSeries(xTag, yTag));
//    for(int i = 0; i < xySeries->count(); i++)
//        qDebug() << xySeries->at(i);
}
