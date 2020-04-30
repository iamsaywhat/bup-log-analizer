#include <QApplication>
//#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "buplogparser.h"
#include "filesystemmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);



    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();    // Создаём корневой контекст

    BupLogParser parser;
    context->setContextProperty("parser", &parser);

    FileSystemModel fileSystemModel;
    context->setContextProperty("fileSystemModel", &fileSystemModel);

    //QStringList tags;
    //tags << "Model_Lat, deg: "<< "Model_Lon, deg: " << "Model_Alt, m: " << "Timestamp, sec: " << "MAP, m: ";
    //parser.setTags(tags);
    //parser.setFile("D:/Qt project/saulog.log");
    //parser.runParsing();


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url); 


    return app.exec();
}
