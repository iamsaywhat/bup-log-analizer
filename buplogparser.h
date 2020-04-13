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
    void setTags(QStringList&);
    bool setFile(QString);
    void runParsing(void);



private:
    QStringList tags;
    QList<QStringList*> data;
    QFile file;

    void clear(void);
    QList<QPointF> createSeries(QString xTag, QString yTag);

signals:

public slots:
    QGeoPath getTrack(QString latitudeTag,
                      QString longitudeTag,
                      QString altitudeTag);
    void getSeries(QtCharts::QAbstractSeries *series);

};

#endif // BUPLOGPARSER_H
