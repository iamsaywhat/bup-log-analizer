#include "filesystemmodel.h"
#include <QDebug>
FileSystemModel::FileSystemModel(QObject *parent)
    : QAbstractListModel(parent),
      _dir(QDir("/"))
{
    //_dir.setNameFilters(QStringList("*.log"));
    updateDirInfo();

}
void FileSystemModel::updateDirInfo (void){
    _content = _dir.entryInfoList(QStringList("*.log"), QDir::NoDotAndDotDot | QDir::Dirs | QDir::AllDirs | QDir::Files,
                                  QDir::DirsFirst | QDir::Name);
}
void FileSystemModel::updateDrivesInfo(void){
    _content = _dir.drives();
}

QString FileSystemModel::currentPath(void) const{
    return _dir.absolutePath();
}
void FileSystemModel::setCurrentPath(QString){

}

int FileSystemModel::rowCount(const QModelIndex &parent) const{
    Q_UNUSED(parent)
    return _content.count();
}

QHash<int, QByteArray> FileSystemModel::roleNames(void) const{
    static QHash<int, QByteArray> roles = {
        {NAME, "name"},
        {DIR,  "dir"},
        {DRIVE, "drive"},
        {FULL_PATH, "fullPath"}
    };
    return roles;
}

QVariant FileSystemModel::data(const QModelIndex &index, int role) const{
    const int row = index.row();
    if(_content.count() < row)
       return QVariant();

    const auto& item = _content[row];
    switch (role) {
    case NAME:
        if(item.fileName().isEmpty())
            return item.absoluteFilePath();
       else
            return item.fileName();
    case DIR:
       return item.isDir();
    case DRIVE:
       return item.fileName().isEmpty();
    case FULL_PATH:
       return item.absoluteFilePath();
    default:
       return QVariant();
   }
}
void FileSystemModel::cdUp(void){
    if(_dir.cdUp()){
        beginResetModel();
        updateDirInfo();
        endResetModel();
        emit currentPathChanged(currentPath());
    }
    else {
        beginResetModel();
        updateDrivesInfo();
        endResetModel();
    }
}
void FileSystemModel::cd(const QString& path){
         beginResetModel();
         _dir = QDir(path);
         updateDirInfo();
         endResetModel();
         emit currentPathChanged(path);
}
