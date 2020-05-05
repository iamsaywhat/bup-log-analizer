#include "filesystemmodel.h"
#include <QDebug>
#include <QStorageInfo>


FileSystemModel::FileSystemModel(QObject *parent)
    : QAbstractListModel(parent),
      _dir(QDir("/"))
{
    updateDirInfo();
}

void FileSystemModel::updateDirInfo (void){
    beginResetModel();
    items.clear();
    if(_dir.isRoot()){
        items.append(Item({"back", "drives", Back}));
        QFileInfoList currentDir = _dir.entryInfoList(QStringList("*.log"), QDir::NoDotAndDotDot | QDir::Dirs | QDir::AllDirs | QDir::Files,
                                                                            QDir::DirsFirst | QDir::Name);
        for(int i = 0; i < currentDir.count(); i++){
            items.append(Item({currentDir.at(i).fileName(),
                               currentDir.at(i).absoluteFilePath(),
                               currentDir.at(i).isFile() ? File : Dir}));
        }
    }
    else {
        QString currentPath = _dir.absolutePath();
        _dir.cdUp();
        items.append(Item({"back",_dir.absolutePath(), Back}));
        _dir.cd(currentPath);
        QFileInfoList currentDir = _dir.entryInfoList(QStringList("*.log"), QDir::NoDotAndDotDot | QDir::Dirs | QDir::AllDirs | QDir::Files,
                                                                            QDir::DirsFirst | QDir::Name);
        for(int i = 0; i < currentDir.count(); i++){
            items.append(Item({currentDir.at(i).fileName(),
                               currentDir.at(i).absoluteFilePath(),
                               currentDir.at(i).isFile() ? File : Dir}));
        }
    }
//    for(int i = 0; i < items.count(); i++) {
//        qDebug() << items.at(i).name << items.at(i).fullPath << items.at(i).type;
//    }
    endResetModel();
    emit currentPathChanged(currentPath());
}

QString FileSystemModel::currentPath(void) const{
    return _dir.absolutePath();
}
void FileSystemModel::setCurrentPath(QString){

}

int FileSystemModel::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent)
    return items.count();
}

QHash<int, QByteArray> FileSystemModel::roleNames(void) const{
    static QHash<int, QByteArray> roles = {
        {NAME, "name"},
        {DIR,  "dir"},
        {DIR_UP, "dir_up"},
        {DRIVE, "drive"},
        {FULL_PATH, "fullPath"}
    };
    return roles;
}

QVariant FileSystemModel::data(const QModelIndex &index, int role) const{
    //qDebug() <<  index, role;
    const int row = index.row();
    if(items.count() < row)
       return QVariant();

    const auto& item = items.at(row);
    switch (role) {
    case NAME:{
        //qDebug() << item.name;
        return item.name;
    case DIR:
       //qDebug() <<  (item.type == Dir ? true : false);
       return (item.type == Dir ? true : false);
    case DIR_UP:
        //qDebug() << (item.type == Back ? true : false);
        return (item.type == Back ? true : false);
    case DRIVE:
       //qDebug() << (item.type == Drive ? true : false);
       return (item.type == Drive ? true : false);
    case FULL_PATH:
       //qDebug() << item.fullPath;
       return item.fullPath;
    default:
       return QVariant();

   }
}
}


void FileSystemModel::cdUp(void){
    if(_dir.isRoot()){
        beginResetModel();
        items.clear();
        QFileInfoList drives = _dir.drives();
        for(int i = 0; i < drives.count(); i++){
            QString driveName = QStorageInfo(drives.at(i).absoluteFilePath()).name();
            driveName += " (" + drives.at(i).absoluteFilePath() + ")";
            items.append(Item({driveName, drives.at(i).absoluteFilePath(), Drive}));
        }
        endResetModel();
        emit currentPathChanged(currentPath());
        for(int i = 0; i < items.count(); i++) {
            qDebug() << items.at(i).name << items.at(i).fullPath << items.at(i).type;
        }
    }
    else {
        _dir.cdUp();
        updateDirInfo();
    }
}
void FileSystemModel::cd(const QString& path){
    qDebug() << path;
    if(path == "drives")
    {
        beginResetModel();
        items.clear();
        QFileInfoList drives = _dir.drives();
        for(int i = 0; i < drives.count(); i++){
            QString driveName = QStorageInfo(drives.at(i).absoluteFilePath()).name();
            driveName += " (" + drives.at(i).absoluteFilePath() + ")";
            items.append(Item({driveName, drives.at(i).absoluteFilePath(), Drive}));
        }
        endResetModel();
        emit currentPathChanged(currentPath());
//        for(int i = 0; i < items.count(); i++) {
//            qDebug() << items.at(i).name << items.at(i).fullPath << items.at(i).type;
//        }
    }
    else {
         beginResetModel();
         _dir = QDir(path);
         updateDirInfo();
         endResetModel();
         emit currentPathChanged(path);
    }
}
