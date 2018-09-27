#ifndef VIRTUALDESKTOPBARPLUGIN_H
#define VIRTUALDESKTOPBARPLUGIN_H

#include <QQmlExtensionPlugin>

class QQmlEngine;
class VirtualDesktopBarPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char* uri);
};

#endif // VIRTUALDESKTOPBARPLUGIN_H
