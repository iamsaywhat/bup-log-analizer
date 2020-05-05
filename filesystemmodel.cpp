#include "filesystemmodel.h"
#include <QDebug>
#include <QStorageInfo>


FileSystemModel::FileSystemModel(QObject *parent)
    : QAbstractListModel(parent),
      dir(QDir("/"))
{
    updateDirInfo();
}

void FileSystemModel::updateDirInfo (void){
    beginResetModel();
    items.clear();
    if(dir.isRoot()){
        items.append(Item({cdItemName, "drives", Back}));
        QFileInfoList currentDir = dir.entryInfoList(QStringList("*.log"),
                                                     QDir::NoDotAndDotDot | QDir::Dirs |
                                                     QDir::AllDirs | QDir::Files,
                                                     QDir::DirsFirst | QDir::Name);
        for(int i = 0; i < currentDir.count(); i++){
            items.append(Item({currentDir.at(i).fileName(),
                               currentDir.at(i).absoluteFilePath(),
                               currentDir.at(i).isFile() ? File : Dir}));
        }
    }
    else {
        QString currentPath = dir.absolutePath();
        dir.cdUp();
        items.append(Item({cdItemName, dir.absolutePath(), Back}));
        dir.cd(currentPath);
        QFileInfoList currentDir = dir.entryInfoList(QStringList("*.log"),
                                                     QDir::NoDotAndDotDot | QDir::Dirs |
                                                     QDir::AllDirs | QDir::Files,
                                                     QDir::DirsFirst | QDir::Name);
        for(int i = 0; i < currentDir.count(); i++){
            items.append(Item({currentDir.at(i).fileName(),
                               currentDir.at(i).absoluteFilePath(),
                               currentDir.at(i).isFile() ? File : Dir}));
        }
    }
    endResetModel();
    emit currentPathChanged(currentPath());
}

void FileSystemModel::updateDrivesInfo(void){         // This fills items list of drives names as normal files/folders
    beginResetModel();                                         // but without "back" item
    items.clear();
    QFileInfoList drives = dir.drives();
    for(int i = 0; i < drives.count(); i++){
        QString driveName = QStorageInfo(drives.at(i).absoluteFilePath()).name();
        driveName += " (" + drives.at(i).absoluteFilePath() + ")";
        items.append(Item({driveName, drives.at(i).absoluteFilePath(), Drive}));
    }
    endResetModel();
    emit currentPathChanged(currentPath());
}

QString FileSystemModel::currentPath(void) const{
    return dir.absolutePath();
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
    const int row = index.row();
    if(items.count() < row)
       return QVariant();

    const auto& item = items.at(row);
    switch (role) {
    case NAME:
        return item.name;
    case DIR:
       return (item.type == Dir ? true : false);
    case DIR_UP:
        return (item.type == Back ? true : false);
    case DRIVE:
       return (item.type == Drive ? true : false);
    case FULL_PATH:
       return item.fullPath;
    default:
       return QVariant();
    }
}

void FileSystemModel::cdUp(void){
    if(dir.isRoot())            // When user want to move up from current directory, but it's root directory
        updateDrivesInfo();     // we introduce an abstraction to show drives as folders with special role
    else {
        dir.cdUp();
        updateDirInfo();
    }
}

void FileSystemModel::cd(const QString& path){
    if(path == "drives")        // path "drives" is abstraction level to show drives as folders
        updateDrivesInfo();
    else {
         dir = QDir(path);
         updateDirInfo();
    }
}
