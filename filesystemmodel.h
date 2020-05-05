#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <QObject>
#include <QAbstractListModel>
#include <QDir>
#include <QFileInfoList>

class FileSystemModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath WRITE setCurrentPath NOTIFY currentPathChanged)

public:
    enum Roles
    {
        NAME,
        DIR,
        DIR_UP,
        DRIVE,
        FULL_PATH
    };
    enum ItemTypes {
        File,
        Dir,
        Back,
        Drive,
    };
    struct Item {
        QString name;
        QString fullPath;
        ItemTypes type;
    };

    FileSystemModel(QObject *parent = nullptr);
    void updateDirInfo (void);
    void updateDrivesInfo(void);
    QString currentPath(void) const;
    void setCurrentPath(QString);

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash <int, QByteArray> roleNames(void) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

private:
    QDir _dir;
    QFileInfoList _content;
    QList<Item> items;

signals:
    void currentPathChanged(QString);

public slots:
    void cdUp(void);
    void cd(const QString& path);
};

#endif // FILESYSTEM_H
