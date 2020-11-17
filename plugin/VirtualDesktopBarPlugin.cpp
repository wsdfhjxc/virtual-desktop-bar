#include "VirtualDesktopBarPlugin.hpp"

#include <QQmlEngine>

#include "VirtualDesktopBar.hpp"

void VirtualDesktopBarPlugin::registerTypes(const char* uri) {
    qmlRegisterType<VirtualDesktopBar>(uri, 1, 2, "VirtualDesktopBar");
}
