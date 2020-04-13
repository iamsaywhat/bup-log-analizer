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

Q_INVOKABLE    void qwertyupdate(QtCharts::QAbstractSeries *series);

private:
    QStringList tags;
    QList<QStringList*> data;
    QFile file;

    void clear(void);

signals:

public slots:
    QGeoPath getTrack(QString latitudeTag,
                                    QString longitudeTag,
                                    QString altitudeTag);

};

#endif // BUPLOGPARSER_H
