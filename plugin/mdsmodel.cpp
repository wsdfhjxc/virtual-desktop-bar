#include "mdsmodel.h"

MDSModel::MDSModel(QObject* parent) : QObject(parent) {}

QVariantList MDSModel::getDesktopNames() const {
    QVariantList desktopNames;
    for (const QString& desktopName : desktopInfo.desktopNames()) {
        desktopNames << QVariant(desktopName);
    }
    return desktopNames;
}

QVariant MDSModel::getActiveDesktopNumber() const {
    const int currentDesktop = desktopInfo.currentDesktop();
    return QVariant(currentDesktop);
}
