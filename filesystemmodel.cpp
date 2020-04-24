#include "filesystemmodel.h"
#include <QDebug>
FileSystemModel::FileSystemModel(QObject *parent)
    : QAbstractListModel(parent),
      _dir(QDir("/"))
{
    updateFileList();
}
void FileSystemModel::updateFileList (void){
    _content = _dir.entryInfoList(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Files,
                                  QDir::DirsFirst | QDir::Name);
    qDebug() << _content;
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
       return item.fileName();
   case DIR:
       return item.isDir();
   case FULL_PATH:
       return item.absoluteFilePath();
   default:
       return QVariant();
   }
}
void FileSystemModel::cdUp(void){
    if(_dir.cdUp()){
        beginResetModel();
        updateFileList();
        endResetModel();
        emit currentPathChanged(currentPath());
    }
    qDebug() << "hhhh";
}
void FileSystemModel::cd(const QString& path){
         beginResetModel();
         _dir = QDir(path);
         updateFileList();
         endResetModel();
         emit currentPathChanged(path);
}
