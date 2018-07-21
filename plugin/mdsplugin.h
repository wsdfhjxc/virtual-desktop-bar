#ifndef MDSPLUGIN_H
#define MDSPLUGIN_H

#include <QQmlExtensionPlugin>

class QQmlEngine;
class MDSPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char* uri);
};

#endif // MDSPLUGIN_H
