#include "mdsplugin.h"
#include "mdsmodel.h"

#include <QQmlEngine>

void MDSPlugin::registerTypes(const char* uri) {
    qmlRegisterType<MDSModel>(uri, 2, 0, "MDSModel");
}
