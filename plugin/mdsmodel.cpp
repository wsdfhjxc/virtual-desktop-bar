#include "mdsmodel.h"

#include <KWindowSystem>
#include <KGlobalAccel>

MDSModel::MDSModel(QObject* parent) : QObject(parent),
                                      netRootInfo(QX11Info::connection(), 0) {

    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged,
                     this, &MDSModel::desktopChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged,
                     this, &MDSModel::desktopAmountChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged,
                     this, &MDSModel::desktopNamesChanged);

    actionCollection = new KActionCollection(this);

    actionAddDesktop = actionCollection->addAction(QStringLiteral("addDesktop"));
    actionAddDesktop->setText("Add New Virtual Desktop");
    connect(actionAddDesktop, &QAction::triggered, this, [this]() {
        addDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionAddDesktop, QKeySequence());

    actionRemoveDesktop = actionCollection->addAction(QStringLiteral("removeDesktop"));
    actionRemoveDesktop->setText("Remove Last Virtual Desktop");
    connect(actionRemoveDesktop, &QAction::triggered, this, [this]() {
        removeDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveDesktop, QKeySequence());

    actionRenameDesktop = actionCollection->addAction(QStringLiteral("renameDesktop"));
    actionRenameDesktop->setText("Rename Current Virtual Desktop");
    connect(actionRenameDesktop, &QAction::triggered, this, [this]() {
        emit activated();
    });
    KGlobalAccel::setGlobalShortcut(actionRenameDesktop, QKeySequence());
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

QVariant MDSModel::getActiveDesktopName() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    const QString currentDesktopName = KWindowSystem::desktopName(currentDesktop);
    return QVariant(currentDesktopName);
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

void MDSModel::renameActiveDesktop(const QString desktopName) {
    const int currentDesktop = KWindowSystem::currentDesktop();
    KWindowSystem::setDesktopName(currentDesktop, desktopName);
}
