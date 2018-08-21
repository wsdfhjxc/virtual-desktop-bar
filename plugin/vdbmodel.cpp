#include "vdbmodel.h"

#include <KWindowSystem>
#include <KGlobalAccel>

VDBModel::VDBModel(QObject* parent) : QObject(parent),
                                      netRootInfo(QX11Info::connection(), 0) {
    setUpSignalForwarding();
    setUpGlobalKeyboardShortcuts();
}

const QVariantList VDBModel::getDesktopNames() const {
    QVariantList desktopNames;
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    for (int desktopNumber = 0; desktopNumber < numberOfDesktops; desktopNumber++) {
        const QString& desktopName = KWindowSystem::desktopName(desktopNumber + 1);
        desktopNames << QVariant(desktopName);
    }
    return desktopNames;
}

const QVariant VDBModel::getCurrentDesktopName() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    const QString currentDesktopName = KWindowSystem::desktopName(currentDesktop);
    return QVariant(currentDesktopName);
}

const QVariant VDBModel::getCurrentDesktopNumber() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    return QVariant(currentDesktop);
}

void VDBModel::switchToDesktop(const int desktopNumber) {
    KWindowSystem::setCurrentDesktop(desktopNumber);
}

void VDBModel::addNewDesktop(const QString desktopName) {
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    netRootInfo.setNumberOfDesktops(numberOfDesktops + 1);
    if (!desktopName.isNull()) {
        KWindowSystem::setDesktopName(numberOfDesktops + 1, desktopName);
    }
}

void VDBModel::removeDesktop(const int desktopNumber) {
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
}

void VDBModel::removeCurrentDesktop() {
    const int currentDesktop = KWindowSystem::currentDesktop();
    emit desktopRemoveRequested(currentDesktop);
}

void VDBModel::removeLastDesktop() {
    removeDesktop();
}

void VDBModel::renameDesktop(const int desktopNumber, const QString desktopName) {
    KWindowSystem::setDesktopName(desktopNumber, desktopName);
}

void VDBModel::renameCurrentDesktop(const QString desktopName) {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    renameDesktop(currentDesktopNumber, desktopName);
}

bool VDBModel::moveDesktop(const int desktopNumber, const int moveStep) {
    const int otherDesktopNumber = desktopNumber + moveStep;

    if (otherDesktopNumber == 0 ||
        otherDesktopNumber == KWindowSystem::numberOfDesktops() + 1) {
        return false;
    }

    QList<WId> windowsFromDesktop = getWindows(desktopNumber);
    QList<WId> windowsFromOtherDesktop = getWindows(otherDesktopNumber);

    for (WId wId : windowsFromDesktop) {
        KWindowSystem::setOnDesktop(wId, otherDesktopNumber);
    }

    for (WId wId : windowsFromOtherDesktop) {
        KWindowSystem::setOnDesktop(wId, desktopNumber);
    }

    const QString desktopName = KWindowSystem::desktopName(desktopNumber);
    const QString otherDesktopName = KWindowSystem::desktopName(otherDesktopNumber);

    KWindowSystem::setDesktopName(desktopNumber, otherDesktopName);
    KWindowSystem::setDesktopName(otherDesktopNumber, desktopName);

    return true;
}

bool VDBModel::moveDesktopToLeft(const int desktopNumber) {
    return moveDesktop(desktopNumber, -1);
}

bool VDBModel::moveDesktopToRight(const int desktopNumber) {
    return moveDesktop(desktopNumber, 1);
}

void VDBModel::moveCurrentDesktopToLeft() {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    if (moveDesktopToLeft(currentDesktopNumber)) {
        switchToDesktop(currentDesktopNumber - 1);
    }
}

void VDBModel::moveCurrentDesktopToRight() {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    if (moveDesktopToRight(currentDesktopNumber)) {
        switchToDesktop(currentDesktopNumber + 1);
    }
}

void VDBModel::setUpSignalForwarding() {

    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged,
                     this, &VDBModel::currentDesktopChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged,
                     this, &VDBModel::desktopAmountChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged,
                     this, &VDBModel::desktopNamesChanged);
}

void VDBModel::setUpGlobalKeyboardShortcuts() {
    actionCollection = new KActionCollection(this);

    actionAddNewDesktop = actionCollection->addAction(QStringLiteral("addNewDesktop"));
    actionAddNewDesktop->setText("Add New Virtual Desktop");
    actionAddNewDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-add")));
    QObject::connect(actionAddNewDesktop, &QAction::triggered, this, [this]() {
        addNewDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionAddNewDesktop, QKeySequence());

    actionRemoveLastDesktop = actionCollection->addAction(QStringLiteral("removeLastDesktop"));
    actionRemoveLastDesktop->setText("Remove Last Virtual Desktop");
    actionRemoveLastDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-remove")));
    QObject::connect(actionRemoveLastDesktop, &QAction::triggered, this, [this]() {
        removeLastDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveLastDesktop, QKeySequence());

    actionRemoveCurrentDesktop = actionCollection->addAction(QStringLiteral("removeCurrentDesktop"));
    actionRemoveCurrentDesktop->setText("Remove Current Virtual Desktop");
    actionRemoveCurrentDesktop->setIcon(QIcon::fromTheme(QStringLiteral("list-remove")));
    QObject::connect(actionRemoveCurrentDesktop, &QAction::triggered, this, [this]() {
        removeCurrentDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveCurrentDesktop, QKeySequence());

    actionRenameCurrentDesktop = actionCollection->addAction(QStringLiteral("renameCurrentDesktop"));
    actionRenameCurrentDesktop->setText("Rename Current Virtual Desktop");
    actionRenameCurrentDesktop->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionRenameCurrentDesktop, &QAction::triggered, this, [this]() {
        emit currentDesktopNameChangeRequested();
    });
    KGlobalAccel::setGlobalShortcut(actionRenameCurrentDesktop, QKeySequence());

    actionMoveCurrentDesktopToLeft = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToLeft"));
    actionMoveCurrentDesktopToLeft->setText("Move Current Virtual Desktop To Left");
    actionMoveCurrentDesktopToLeft->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionMoveCurrentDesktopToLeft, &QAction::triggered, this, [this]() {
        moveCurrentDesktopToLeft();
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToLeft, QKeySequence());

    actionMoveCurrentDesktopToRight = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToRight"));
    actionMoveCurrentDesktopToRight->setText("Move Current Virtual Desktop To Right");
    actionMoveCurrentDesktopToRight->setIcon(QIcon::fromTheme(QStringLiteral("edit-rename")));
    QObject::connect(actionMoveCurrentDesktopToRight, &QAction::triggered, this, [this]() {
        moveCurrentDesktopToRight();
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToRight, QKeySequence());
}

const QList<WId> VDBModel::getWindows(const int desktopNumber, const bool afterDesktop) {
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
