#ifndef BUPLOGPARSER_H
#define BUPLOGPARSER_H

#include <QObject>
#include <QFile>
#include <QtPositioning/QGeoCoordinate>
#include <QGeoPath>
#include <QAbstractSeries>
#include <QLineSeries>
#include <QXYSeries>

class BupLogParser : public QObject
{
    Q_OBJECT

public:
    explicit BupLogParser(QObject *parent = nullptr);
    ~BupLogParser(void);

    struct Warning {
        uint64_t timestamp;
        QString text;
    };
    struct Point {
        uint64_t timestamp;
        QString name;
        QGeoCoordinate point;
    };
    struct Series {
        QString name;
        QList<uint64_t> timestamp;
        QList<double> step;
        QList<double> value;
    };
    struct GeoTrack {
        uint64_t timestamp;
        double step;
        QGeoCoordinate coordinate;
    };

private:
    QFile file;
    QList<Warning> warnings;
    QList<Point> points;
    QList<Series*> series;
    QList<GeoTrack> track;


    void parseLine(QString line);
    void clear(void);
    QList<QPointF> createSeries(QString xTag, QString yTag);

signals:
    void fileOpen(QString name);

public slots: 
    bool openFile(QString);
    QGeoPath getTrack(QString latitudeTag, QString longitudeTag, QString altitudeTag);
    void getSeries(QtCharts::QAbstractSeries *series, QString xTag, QString yTag);

    QStringList getWarningsList(void);
    QStringList getPointsList(void);
    QStringList getSeriesList(void);

};

Q_DECLARE_METATYPE(BupLogParser::Warning)
Q_DECLARE_METATYPE(BupLogParser::Point)
Q_DECLARE_METATYPE(BupLogParser::Series)


#endif // BUPLOGPARSER_H
