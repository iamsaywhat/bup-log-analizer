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
        FULL_PATH
    };

    FileSystemModel(QObject *parent = nullptr);
    void updateFileList (void);
    QString currentPath(void) const;
    void setCurrentPath(QString);

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash <int, QByteArray> roleNames(void) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

private:
    QDir _dir;
    QFileInfoList _content;

signals:
    void currentPathChanged(QString);

public slots:
    void cdUp(void);
    void cd(const QString& path);
};

#endif // FILESYSTEM_H
