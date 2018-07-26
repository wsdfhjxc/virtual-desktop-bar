#include "mdsmodel.h"

#include <KWindowSystem>

MDSModel::MDSModel(QObject* parent) : QObject(parent),
                                      netRootInfo(QX11Info::connection(), 0) {

    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged,
                     this, &MDSModel::desktopChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged,
                     this, &MDSModel::desktopAmountChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged,
                     this, &MDSModel::desktopNamesChanged);
}

QVariantList MDSModel::getDesktopNames() const {
    QVariantList desktopNames;
    int numberOfDesktops = KWindowSystem::numberOfDesktops();
    for (int desktopNumber = 0; desktopNumber < numberOfDesktops; desktopNumber++) {
        const QString& desktopName = KWindowSystem::desktopName(desktopNumber + 1);
        desktopNames << QVariant(desktopName);
    }
    return desktopNames;
}

QVariant MDSModel::getActiveDesktopNumber() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    return QVariant(currentDesktop);
}

void MDSModel::switchToDesktop(int desktopNumber) {
    KWindowSystem::setCurrentDesktop(desktopNumber);
}

void MDSModel::addDesktop(const QString desktopName) {
    int numberOfDesktops = KWindowSystem::numberOfDesktops();
    netRootInfo.setNumberOfDesktops(numberOfDesktops + 1);
    if (!desktopName.isNull()) {
        KWindowSystem::setDesktopName(numberOfDesktops + 1, desktopName);
    }
}

void MDSModel::removeDesktop() {
    int numberOfDesktops = KWindowSystem::numberOfDesktops();
    if (numberOfDesktops > 1) {
        netRootInfo.setNumberOfDesktops(numberOfDesktops - 1);
    }
}
