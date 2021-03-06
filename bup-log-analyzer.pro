QT += quick core widgets qml quick location positioning quickcontrols2 charts

CONFIG += c++11 qml_debug

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        buplogparser.cpp \
        filesystemmodel.cpp \
        main.cpp

RESOURCES += \
    icons.qrc \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    buplogparser.h \
    filesystemmodel.h

DISTFILES += \
    components/GpsTracker.qml \
    components/Plot.qml \
    main.qml \
    pages/addwidget/AddWidgetPage.qml \
    pages/addwidget/PlotMenuProperties.qml \
    pages/addwidget/PointMenuProperties.qml \
    pages/addwidget/Selector.qml \
    pages/addwidget/TrackMenuProperties.qml \
    pages/main/AppHeader.qml \
    pages/main/WidgetsWorkspace.qml \
    pages/openfile/OpenFilePage.qml \
    qml/AppHeader.qml \
    qml/GpsTracker.qml \
    qml/OpenFilePage.qml \
    qml/Plot.qml \
    qml/WidgetsWorkspace.qml \
    qml/addpage/AddWidgetPage.qml \
    qml/addpage/PlotMenuProperties.qml \
    qml/addpage/PointMenuProperties.qml \
    qml/addpage/Selector.qml \
    qml/addpage/TrackMenuProperties.qml
