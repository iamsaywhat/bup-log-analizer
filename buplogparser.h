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

private:
    QStringList tags;
    QList<QStringList*> data;
    QFile file;

    void setTags(QStringList&);
    void runParsing(void);
    void clear(void);
    QList<QPointF> createSeries(QString xTag, QString yTag);

signals:
    void fileOpen(void);

public slots:
    bool openFile(QString);

    QStringList getTags(void);
    QGeoPath getTrack(QString latitudeTag,
                      QString longitudeTag,
                      QString altitudeTag);
    void getSeries(QtCharts::QAbstractSeries *series, QString xTag, QString yTag);

};

#endif // BUPLOGPARSER_H
