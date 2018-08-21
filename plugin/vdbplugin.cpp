#include "vdbplugin.h"
#include "vdbmodel.h"

#include <QQmlEngine>

void VDBPlugin::registerTypes(const char* uri) {
    qmlRegisterType<VDBModel>(uri, 2, 0, "VDBModel");
}
