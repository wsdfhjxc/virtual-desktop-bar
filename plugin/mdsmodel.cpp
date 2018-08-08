#include "mdsmodel.h"

#include <KWindowSystem>
#include <KGlobalAccel>

MDSModel::MDSModel(QObject* parent) : QObject(parent),
                                      netRootInfo(QX11Info::connection(), 0) {
    setUpSignalForwarding();
    setUpGlobalKeyboardShortcuts();
}

const QVariantList MDSModel::getDesktopNames() const {
    QVariantList desktopNames;
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    for (int desktopNumber = 0; desktopNumber < numberOfDesktops; desktopNumber++) {
        const QString& desktopName = KWindowSystem::desktopName(desktopNumber + 1);
        desktopNames << QVariant(desktopName);
    }
    return desktopNames;
}

const QVariant MDSModel::getCurrentDesktopName() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    const QString currentDesktopName = KWindowSystem::desktopName(currentDesktop);
    return QVariant(currentDesktopName);
}

const QVariant MDSModel::getCurrentDesktopNumber() const {
    const int currentDesktop = KWindowSystem::currentDesktop();
    return QVariant(currentDesktop);
}

void MDSModel::switchToDesktop(const int desktopNumber) {
    KWindowSystem::setCurrentDesktop(desktopNumber);
}

void MDSModel::addNewDesktop(const QString desktopName) {
    const int numberOfDesktops = KWindowSystem::numberOfDesktops();
    netRootInfo.setNumberOfDesktops(numberOfDesktops + 1);
    if (!desktopName.isNull()) {
        KWindowSystem::setDesktopName(numberOfDesktops + 1, desktopName);
    }
}

void MDSModel::removeDesktop(const int desktopNumber) {
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

void MDSModel::removeCurrentDesktop() {
    const int currentDesktop = KWindowSystem::currentDesktop();
    removeDesktop(currentDesktop);
}

void MDSModel::removeLastDesktop() {
    removeDesktop();
}

void MDSModel::renameDesktop(const int desktopNumber, const QString desktopName) {
    KWindowSystem::setDesktopName(desktopNumber, desktopName);
}

void MDSModel::renameCurrentDesktop(const QString desktopName) {
    const int currentDesktopNumber = KWindowSystem::currentDesktop();
    renameDesktop(currentDesktopNumber, desktopName);
}

void MDSModel::setUpSignalForwarding() {

    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged,
                     this, &MDSModel::currentDesktopChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged,
                     this, &MDSModel::desktopAmountChanged);

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged,
                     this, &MDSModel::desktopNamesChanged);
}

void MDSModel::setUpGlobalKeyboardShortcuts() {
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
}

const QList<WId> MDSModel::getWindows(const int desktopNumber, const bool afterDesktop) {
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
