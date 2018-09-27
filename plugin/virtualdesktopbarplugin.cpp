#include "virtualdesktopbarplugin.h"
#include "virtualdesktopbar.h"

#include <QQmlEngine>

void VirtualDesktopBarPlugin::registerTypes(const char* uri) {
    qmlRegisterType<VirtualDesktopBar>(uri, 2, 0, "VirtualDesktopBar");
}
