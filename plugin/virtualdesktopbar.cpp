#include "virtualdesktopbar.h"

#include <KWindowSystem>
#include <KGlobalAccel>
#include <QDBusInterface>
#include <QDBusReply>
#include <QTimer>

VirtualDesktopBar::VirtualDesktopBar(QObject* parent) : QObject(parent),
                                      netRootInfo(QX11Info::connection(), 0) {
    setUpSignalForwarding();
    setUpGlobalKeyboardShortcuts();

    currentDesktopNumber = KWindowSystem::currentDesktop();
    recentDesktopNumber = currentDesktopNumber;
}

const QVariantList VirtualDesktopBar::getDesktopNames() const {
    QVariantList desktopNames;
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    for (int desktopNumber = 0; desktopNumber < numberOfDesktops; desktopNumber++) {
        const QString& desktopName = KWindowSystem::desktopName(desktopNumber + 1);
        desktopNames << QVariant(desktopName);
    }
    return desktopNames;
}

const QVariant VirtualDesktopBar::getCurrentDesktopName() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    const QString currentDesktopName = KWindowSystem::desktopName(currentDesktop);
    return QVariant(currentDesktopName);
}

const QVariant VirtualDesktopBar::getCurrentDesktopNumber() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    return QVariant(currentDesktop);
}

void VirtualDesktopBar::switchToDesktop(const int desktopNumber) {
    if (desktopNumber < 1 || desktopNumber > KWindowSystem::numberOfDesktops()) {
        return;
    }
    KWindowSystem::setCurrentDesktop(desktopNumber);
}

void VirtualDesktopBar::switchToRecentDesktop() {
    switchToDesktop(recentDesktopNumber);
}

void VirtualDesktopBar::addNewDesktop(const QString desktopName) {
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    netRootInfo.setNumberOfDesktops(numberOfDesktops + 1);
    if (!desktopName.isNull()) {
        KWindowSystem::setDesktopName(numberOfDesktops + 1, desktopName);
    }
}

void VirtualDesktopBar::removeDesktop(const int desktopNumber) {
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    if (numberOfDesktops == 1) {
        return;
    }

    if (desktopNumber > 0 && desktopNumber != numberOfDesktops) {
        const QList<WId> windowsAfterDesktop = getWindows(desktopNumber, true);
        for (WId wId : windowsAfterDesktop) {
            const KWindowInfo info = KWindowInfo(wId, NET::Property::WMDesktop);
            const int windowDesktopNumber = info.desktop();
            KWindowSystem::setOnDesktop(wId, windowDesktopNumber - 1);
        }

        QVariantList desktopNames = getDesktopNames();
        for (int i = desktopNumber - 1; i < numberOfDesktops - 1; i++) {
            const QString desktopName = desktopNames.at(i + 1).toString();
            KWindowSystem::setDesktopName(i + 1, desktopName);
        }
    }

    netRootInfo.setNumberOfDesktops(numberOfDesktops - 1);

    if (isFahoTilingLoaded()) {
        refreshFahoTiling();
    }
}

void VirtualDesktopBar::removeCurrentDesktop() {
    const int currentDesktop = KWindowSystem::currentDesktop();
    emit desktopRemoveRequested(currentDesktop);
}

void VirtualDesktopBar::removeLastDesktop() {
    removeDesktop();
}

void VirtualDesktopBar::renameDesktop(const int desktopNumber, const QString desktopName) {
    KWindowSystem::setDesktopName(desktopNumber, desktopName);
}

void VirtualDesktopBar::renameCurrentDesktop(const QString desktopName) {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    renameDesktop(currentDesktopNumber, desktopName);
}

void VirtualDesktopBar::swapDesktop(const int desktopNumber, const int targetDesktopNumber) {
    if (targetDesktopNumber == desktopNumber) {
        return;
    }

    QList<WId> windowsFromDesktop = getWindows(desktopNumber);
    QList<WId> windowsFromTargetDesktop = getWindows(targetDesktopNumber);

    for (WId wId : windowsFromDesktop) {
        KWindowSystem::setOnDesktop(wId, targetDesktopNumber);
    }

    for (WId wId : windowsFromTargetDesktop) {
        KWindowSystem::setOnDesktop(wId, desktopNumber);
    }

    const QString desktopName = KWindowSystem::desktopName(desktopNumber);
    const QString targetDesktopName = KWindowSystem::desktopName(targetDesktopNumber);

    KWindowSystem::setDesktopName(desktopNumber, targetDesktopName);
    KWindowSystem::setDesktopName(targetDesktopNumber, desktopName);

    if (currentDesktopNumber == desktopNumber) {
        currentDesktopNumber = targetDesktopNumber;
    } else if (currentDesktopNumber == targetDesktopNumber) {
        currentDesktopNumber = desktopNumber;
    }

    if (recentDesktopNumber == desktopNumber) {
        recentDesktopNumber = targetDesktopNumber;
    } else if (recentDesktopNumber == targetDesktopNumber) {
        recentDesktopNumber = desktopNumber;
    }

    if (isFahoTilingLoaded()) {
        refreshFahoTiling();
    }
}

void VirtualDesktopBar::moveDesktop(const int desktopNumber, const int moveStep) {
    int targetDesktopNumber = desktopNumber + moveStep;
    if (targetDesktopNumber < 1) {
        targetDesktopNumber = 1;
    } else if (targetDesktopNumber > KWindowSystem::numberOfDesktops()) {
        targetDesktopNumber = KWindowSystem::numberOfDesktops();
    }

    const int modifier = targetDesktopNumber > desktopNumber ? 1 : -1;
    for (int i = desktopNumber; i != targetDesktopNumber; i += modifier) {
        swapDesktop(i, i + modifier);
    }
}

void VirtualDesktopBar::moveDesktopToLeft(const int desktopNumber) {
    moveDesktop(desktopNumber, -1);
}

void VirtualDesktopBar::moveDesktopToRight(const int desktopNumber) {
    moveDesktop(desktopNumber, 1);
}

void VirtualDesktopBar::moveCurrentDesktopToLeft() {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    moveDesktopToLeft(currentDesktopNumber);
    switchToDesktop(currentDesktopNumber - 1);
}

void VirtualDesktopBar::moveCurrentDesktopToRight() {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    moveDesktopToRight(currentDesktopNumber);
    switchToDesktop(currentDesktopNumber + 1);
}

void VirtualDesktopBar::onCurrentDesktopChanged(const int desktopNumber) {
    if (desktopNumber != currentDesktopNumber) {
        recentDesktopNumber = currentDesktopNumber;
    }
    currentDesktopNumber = desktopNumber;
    emit currentDesktopChanged(desktopNumber);
}

void VirtualDesktopBar::setUpSignalForwarding() {

    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged,
                     this, &VirtualDesktopBar::onCurrentDesktopChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged,
                     this, &VirtualDesktopBar::desktopAmountChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged,
                     this, &VirtualDesktopBar::desktopNamesChanged);
}

void VirtualDesktopBar::setUpGlobalKeyboardShortcuts() {
    actionCollection = new KActionCollection(this, QStringLiteral("kwin"));

    actionSwitchToRecentDesktop = actionCollection->addAction(QStringLiteral("switchToRecentDesktop"));
    actionSwitchToRecentDesktop->setText("Switch to Recent Desktop");
    QObject::connect(actionSwitchToRecentDesktop, &QAction::triggered, this, [this]() {
        switchToRecentDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionSwitchToRecentDesktop, QKeySequence());

    actionAddNewDesktop = actionCollection->addAction(QStringLiteral("addNewDesktop"));
    actionAddNewDesktop->setText("Add New Desktop");
    actionAddNewDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-add")));
    QObject::connect(actionAddNewDesktop, &QAction::triggered, this, [this]() {
        addNewDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionAddNewDesktop, QKeySequence());

    actionRemoveLastDesktop = actionCollection->addAction(QStringLiteral("removeLastDesktop"));
    actionRemoveLastDesktop->setText("Remove Last Desktop");
    actionRemoveLastDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-remove")));
    QObject::connect(actionRemoveLastDesktop, &QAction::triggered, this, [this]() {
        removeLastDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveLastDesktop, QKeySequence());

    actionRemoveCurrentDesktop = actionCollection->addAction(QStringLiteral("removeCurrentDesktop"));
    actionRemoveCurrentDesktop->setText("Remove Current Desktop");
    actionRemoveCurrentDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-remove")));
    QObject::connect(actionRemoveCurrentDesktop, &QAction::triggered, this, [this]() {
        removeCurrentDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveCurrentDesktop, QKeySequence());

    actionRenameCurrentDesktop = actionCollection->addAction(QStringLiteral("renameCurrentDesktop"));
    actionRenameCurrentDesktop->setText("Rename Current Desktop");
    actionRenameCurrentDesktop->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionRenameCurrentDesktop, &QAction::triggered, this, [this]() {
        emit currentDesktopNameChangeRequested();
    });
    KGlobalAccel::setGlobalShortcut(actionRenameCurrentDesktop, QKeySequence());

    actionMoveCurrentDesktopToLeft = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToLeft"));
    actionMoveCurrentDesktopToLeft->setText("Move Current Desktop To Left");
    actionMoveCurrentDesktopToLeft->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionMoveCurrentDesktopToLeft, &QAction::triggered, this, [this]() {
        moveCurrentDesktopToLeft();
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToLeft, QKeySequence());

    actionMoveCurrentDesktopToRight = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToRight"));
    actionMoveCurrentDesktopToRight->setText("Move Current Desktop To Right");
    actionMoveCurrentDesktopToRight->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionMoveCurrentDesktopToRight, &QAction::triggered, this, [this]() {
        moveCurrentDesktopToRight();
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToRight, QKeySequence());
}

const QList<WId> VirtualDesktopBar::getWindows(const int desktopNumber, const bool afterDesktop) {
    QList<WId> windows;

    const QList<WId> allWindows = KWindowSystem::windows();
    for (WId wId : allWindows) {
        if (KWindowSystem::hasWId(wId)) {
            const KWindowInfo info = KWindowInfo(wId, NET::Property::WMDesktop);
            const int windowDesktopNumber = info.desktop();

            if (windowDesktopNumber != NET::OnAllDesktops &&
                ((afterDesktop && windowDesktopNumber > desktopNumber) ||
                (!afterDesktop && windowDesktopNumber == desktopNumber))) {
                windows << wId;
            }
        }
    }

    return windows;
}

bool VirtualDesktopBar::isFahoTilingLoaded() {
    QDBusInterface interface("org.kde.KWin", "/Scripting", "");
    return (QDBusReply<bool>) interface.call("isScriptLoaded", "kwin-script-tiling");
}

void VirtualDesktopBar::refreshFahoTiling() {
    QTimer::singleShot(100, [=] {
        QDBusInterface interface("org.kde.kglobalaccel", "/component/kwin", "");
        interface.call("invokeShortcut", "TILING: Refresh Tiles");
    });
}
