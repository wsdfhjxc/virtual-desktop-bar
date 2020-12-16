#include "VirtualDesktopBar.hpp"

#include <functional>

#include <QGuiApplication>
#include <QRegularExpression>
#include <QScreen>
#include <QTimer>
#include <QX11Info>

#include <KGlobalAccel>

VirtualDesktopBar::VirtualDesktopBar(QObject* parent) : QObject(parent),
        netRootInfo(QX11Info::connection(), 0),
        dbusInterface("org.kde.KWin", "/VirtualDesktopManager"),
        dbusInterfaceName("org.kde.KWin.VirtualDesktopManager"),
        sendDesktopInfoListLock(false),
        tryAddEmptyDesktopLock(false),
        tryRemoveEmptyDesktopsLock(false),
        tryRenameEmptyDesktopsLock(false),
        currentDesktopNumber(KWindowSystem::currentDesktop()),
        mostRecentDesktopNumber(currentDesktopNumber) {

    setUpSignals();
    setUpGlobalKeyboardShortcuts();
}

void VirtualDesktopBar::requestDesktopInfoList() {
    sendDesktopInfoList();
}

void VirtualDesktopBar::showDesktop(int number) {
    KWindowSystem::setCurrentDesktop(number);
}

void VirtualDesktopBar::addDesktop(unsigned position) {
    if (position == 0) {
        position = KWindowSystem::numberOfDesktops() + 1;
    }

    QString name = "New Desktop";
    auto reply = dbusInterface.call("createDesktop", position, name);

    if (reply.type() == QDBusMessage::ErrorMessage) {
        netRootInfo.setNumberOfDesktops(KWindowSystem::numberOfDesktops() + 1);
    }

    if (!cfg_AddingDesktopsExecuteCommand.isEmpty()) {
        QTimer::singleShot(100, [=] {
            QString command = "(" + cfg_AddingDesktopsExecuteCommand + ") &";
            system(command.toStdString().c_str());
        });
    }
}

void VirtualDesktopBar::removeDesktop(int number) {
    auto reply = dbusInterface.call("removeDesktop", getDesktopInfo(number).id);

    if (reply.type() == QDBusMessage::ErrorMessage) {
        if (number == KWindowSystem::numberOfDesktops()) {
            netRootInfo.setNumberOfDesktops(KWindowSystem::numberOfDesktops() - 1);
        } else {
            tryAddEmptyDesktopLock = true;
            tryRemoveEmptyDesktopsLock = true;
            tryRenameEmptyDesktopsLock = true;
            sendDesktopInfoListLock = true;

            QList<QString> desktopNameList;
            QList<KWindowInfo> windowInfoList;
            for (int i = number + 1; i <= KWindowSystem::numberOfDesktops(); i++) {
                desktopNameList << KWindowSystem::desktopName(i);
                windowInfoList.append(getWindowInfoList(i));
            }

            for (int i = number, j = 0; i <= KWindowSystem::numberOfDesktops() - 1; i++, j++) {
                renameDesktop(i, desktopNameList[j]);
            }

            for (auto& windowInfo : windowInfoList) {
                KWindowSystem::setOnDesktop(windowInfo.win(), windowInfo.desktop() - 1);
            }

            tryAddEmptyDesktopLock = false;
            tryRemoveEmptyDesktopsLock = false;
            tryRenameEmptyDesktopsLock = false;
            sendDesktopInfoListLock = false;

            netRootInfo.setNumberOfDesktops(KWindowSystem::numberOfDesktops() - 1);
        }
    }
}

void VirtualDesktopBar::renameDesktop(int number, QString name) {
    auto reply = dbusInterface.call("setDesktopName", getDesktopInfo(number).id, name);

    if (reply.type() == QDBusMessage::ErrorMessage) {
        KWindowSystem::setDesktopName(number, name);
    }
}

void VirtualDesktopBar::replaceDesktops(int number1, int number2) {
    if (number1 == number2) {
        return;
    }
    if (number1 < 1 || number1 > KWindowSystem::numberOfDesktops()) {
        return;
    }
    if (number2 < 1 || number2 > KWindowSystem::numberOfDesktops()) {
        return;
    }

    auto desktopInfo1 = getDesktopInfo(number1);
    auto desktopInfo2 = getDesktopInfo(number2);

    auto windowInfoList1 = getWindowInfoList(desktopInfo1.number);
    auto windowInfoList2 = getWindowInfoList(desktopInfo2.number);

    if (desktopInfo1.isCurrent) {
        KWindowSystem::setCurrentDesktop(desktopInfo2.number);
    } else if (desktopInfo2.isCurrent) {
        KWindowSystem::setCurrentDesktop(desktopInfo1.number);
    }

    for (auto& windowInfo : windowInfoList2) {
        KWindowSystem::setOnDesktop(windowInfo.win(), desktopInfo1.number);
    }

    for (auto& windowInfo : windowInfoList1) {
        KWindowSystem::setOnDesktop(windowInfo.win(), desktopInfo2.number);
    }

    renameDesktop(desktopInfo1.number, desktopInfo2.name);
    renameDesktop(desktopInfo2.number, desktopInfo1.name);
}

void VirtualDesktopBar::setUpSignals() {
    setUpKWinSignals();
    setUpInternalSignals();
}

void VirtualDesktopBar::setUpKWinSignals() {
    QObject::connect(KWindowSystem::self(), &KWindowSystem::currentDesktopChanged, this, [&] {
        updateLocalDesktopNumbers();
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), &KWindowSystem::numberOfDesktopsChanged, this, [&] {
        processChanges([&] { tryAddEmptyDesktop(); }, tryAddEmptyDesktopLock);
        processChanges([&] { tryRemoveEmptyDesktops(); }, tryRemoveEmptyDesktopsLock);
        processChanges([&] { tryRenameEmptyDesktops(); }, tryRenameEmptyDesktopsLock);
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), &KWindowSystem::desktopNamesChanged, this, [&] {
        processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
    });

    QObject::connect(KWindowSystem::self(), static_cast<void (KWindowSystem::*)(WId, NET::Properties, NET::Properties2)>
                                            (&KWindowSystem::windowChanged), this, [&](WId, NET::Properties properties, NET::Properties2) {
        if (properties & NET::WMState) {
            processChanges([&] { tryAddEmptyDesktop(); }, tryAddEmptyDesktopLock);
            processChanges([&] { tryRemoveEmptyDesktops(); }, tryRemoveEmptyDesktopsLock);
            processChanges([&] { tryRenameEmptyDesktops(); }, tryRenameEmptyDesktopsLock);
            processChanges([&] { sendDesktopInfoList(); }, sendDesktopInfoListLock);
        }
    });
}

void VirtualDesktopBar::setUpInternalSignals() {
    QObject::connect(this, &VirtualDesktopBar::cfg_EmptyDesktopsRenameAsChanged, this, [&] {
        tryRenameEmptyDesktops();
    });

    QObject::connect(this, &VirtualDesktopBar::cfg_DynamicDesktopsEnableChanged, this, [&] {
        tryAddEmptyDesktop();
        tryRemoveEmptyDesktops();
    });

    QObject::connect(this, &VirtualDesktopBar::cfg_MultipleScreensFilterOccupiedDesktopsChanged, this, [&] {
        sendDesktopInfoList();
    });
}

void VirtualDesktopBar::setUpGlobalKeyboardShortcuts() {
    QString prefix = "Virtual Desktop Bar - ";
    actionCollection = new KActionCollection(this, QStringLiteral("kwin"));

    actionSwitchToRecentDesktop = actionCollection->addAction(QStringLiteral("switchToRecentDesktop"));
    actionSwitchToRecentDesktop->setText(prefix + "Switch to Recent Desktop");
    QObject::connect(actionSwitchToRecentDesktop, &QAction::triggered, this, [&] {
        showDesktop(mostRecentDesktopNumber);
    });
    KGlobalAccel::setGlobalShortcut(actionSwitchToRecentDesktop, QKeySequence());

    actionAddDesktop = actionCollection->addAction(QStringLiteral("addDesktop"));
    actionAddDesktop->setText(prefix + "Add Desktop");
    QObject::connect(actionAddDesktop, &QAction::triggered, this, [&] {
        if (!cfg_DynamicDesktopsEnable) {
            addDesktop();
        }
    });
    KGlobalAccel::setGlobalShortcut(actionAddDesktop, QKeySequence());

    actionRemoveLastDesktop = actionCollection->addAction(QStringLiteral("removeLastDesktop"));
    actionRemoveLastDesktop->setText(prefix + "Remove Last Desktop");
    QObject::connect(actionRemoveLastDesktop, &QAction::triggered, this, [&] {
        if (!cfg_DynamicDesktopsEnable) {
            removeDesktop(KWindowSystem::numberOfDesktops());
        }
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveLastDesktop, QKeySequence());

    actionRemoveCurrentDesktop = actionCollection->addAction(QStringLiteral("removeCurrentDesktop"));
    actionRemoveCurrentDesktop->setText(prefix + "Remove Current Desktop");
    QObject::connect(actionRemoveCurrentDesktop, &QAction::triggered, this, [&] {
        if (!cfg_DynamicDesktopsEnable) {
            removeDesktop(KWindowSystem::currentDesktop());
        }
    });
    KGlobalAccel::setGlobalShortcut(actionRemoveCurrentDesktop, QKeySequence());

    actionRenameCurrentDesktop = actionCollection->addAction(QStringLiteral("renameCurrentDesktop"));
    actionRenameCurrentDesktop->setText(prefix + "Rename Current Desktop");
    QObject::connect(actionRenameCurrentDesktop, &QAction::triggered, this, [&] {
        emit requestRenameCurrentDesktop();
    });
    KGlobalAccel::setGlobalShortcut(actionRenameCurrentDesktop, QKeySequence());

    actionMoveCurrentDesktopToLeft = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToLeft"));
    actionMoveCurrentDesktopToLeft->setText(prefix + "Move Current Desktop to Left");
    QObject::connect(actionMoveCurrentDesktopToLeft, &QAction::triggered, this, [&] {
        replaceDesktops(KWindowSystem::currentDesktop(),
                        KWindowSystem::currentDesktop() - 1);
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToLeft, QKeySequence());

    actionMoveCurrentDesktopToRight = actionCollection->addAction(QStringLiteral("moveCurrentDesktopToRight"));
    actionMoveCurrentDesktopToRight->setText(prefix + "Move Current Desktop to Right");
    QObject::connect(actionMoveCurrentDesktopToRight, &QAction::triggered, this, [&] {
        replaceDesktops(KWindowSystem::currentDesktop(),
                        KWindowSystem::currentDesktop() + 1);
    });
    KGlobalAccel::setGlobalShortcut(actionMoveCurrentDesktopToRight, QKeySequence());
}

void VirtualDesktopBar::processChanges(std::function<void()> callback, bool& lock) {
    if (!lock) {
        lock = true;
        QTimer::singleShot(1, [this, callback, &lock] {
            lock = false;
            callback();
        });
    }
}

DesktopInfo VirtualDesktopBar::getDesktopInfo(int number) {
    for (auto& desktopInfo : getDesktopInfoList()) {
        if (desktopInfo.number == number) {
            return desktopInfo;
        }
    }
    return DesktopInfo();
}

DesktopInfo VirtualDesktopBar::getDesktopInfo(QString id) {
    for (auto& desktopInfo : getDesktopInfoList()) {
        if (desktopInfo.id == id) {
            return desktopInfo;
        }
    }
    return DesktopInfo();
}

QList<DesktopInfo> VirtualDesktopBar::getDesktopInfoList(bool extraInfo) {
    QList<DesktopInfo> desktopInfoList;

    // Getting info about desktops through the KWin's D-Bus service here
    auto reply = dbusInterface.call("Get", dbusInterfaceName, "desktops");

    if (reply.type() == QDBusMessage::ErrorMessage) {
        for (int i = 1; i <= KWindowSystem::numberOfDesktops(); i++) {
            DesktopInfo desktopInfo;
            desktopInfo.id = i;
            desktopInfo.number = i;
            desktopInfo.name = KWindowSystem::desktopName(i);

            desktopInfoList << desktopInfo;
        }
    } else {
        // Extracting data from the D-Bus reply message here
        // More details at https://stackoverflow.com/a/20206377
        auto something = reply.arguments().at(0).value<QDBusVariant>();
        auto somethingSomething = something.variant().value<QDBusArgument>();
        somethingSomething >> desktopInfoList;
    }

    for (auto& desktopInfo : desktopInfoList) {
        desktopInfo.isCurrent = desktopInfo.number == KWindowSystem::currentDesktop();

        if (!extraInfo) {
            continue;
        }

        auto windowInfoList = getWindowInfoList(desktopInfo.number);

        desktopInfo.isEmpty = windowInfoList.isEmpty();

        for (int i = 0; i < windowInfoList.length(); i++) {
            auto& windowInfo = windowInfoList[i];

            if (!desktopInfo.isUrgent) {
                desktopInfo.isUrgent = windowInfo.hasState(NET::DemandsAttention);
            }

            QString windowName = windowInfo.name();
            int separatorPosition = qMax(windowName.lastIndexOf(" - "),
                                         qMax(windowName.lastIndexOf(" – "),
                                              windowName.lastIndexOf(" — ")));
            if (separatorPosition >= 0) {
                separatorPosition += 3;
                int length = windowName.length() - separatorPosition;
                QStringRef substringRef(&windowName, separatorPosition, length);
                windowName = substringRef.toString().trimmed();
            }

            if (i == 0) {
                desktopInfo.activeWindowName = windowName;
            }

            desktopInfo.windowNameList << windowName;
        }
    }

    return desktopInfoList;
}

QList<KWindowInfo> VirtualDesktopBar::getWindowInfoList(int desktopNumber, bool ignoreScreens) {
    QList<KWindowInfo> windowInfoList;

    auto screenRect = QGuiApplication::screens().at(0)->geometry();

    QList<WId> windowIds = KWindowSystem::stackingOrder();
    for (int i = windowIds.length() - 1; i >= 0; i--) {
        KWindowInfo windowInfo(windowIds[i], NET::WMState |
                                             NET::WMDesktop |
                                             NET::WMGeometry |
                                             NET::WMWindowType |
                                             NET::WMName);

        // Skipping windows not present on the current desktops
        if (windowInfo.desktop() != desktopNumber &&
            windowInfo.desktop() != -1) {
            continue;
        }

        // Skipping some flagged windows
        if (windowInfo.hasState(NET::SkipPager) ||
            windowInfo.hasState(NET::SkipTaskbar)) {
            continue;
        }

        auto windowType = windowInfo.windowType(NET::DockMask |
                                                NET::MenuMask |
                                                NET::SplashMask |
                                                NET::NormalMask);
        if ((windowType & NET::Dock) ||
            (windowType & NET::Menu) ||
            (windowType & NET::Splash)) {
            continue;
        }

        // Skipping windows not present on the current screen
        if (!ignoreScreens && cfg_MultipleScreensFilterOccupiedDesktops) {
            auto windowRect = windowInfo.geometry();
            auto intersectionRect = screenRect.intersected(windowRect);
            if (intersectionRect.width() < windowRect.width() / 2 ||
                intersectionRect.height() < windowRect.height() / 2) {
                continue;
            }
        }

        windowInfoList << windowInfo;
    }

    return windowInfoList;
}

QList<int> VirtualDesktopBar::getEmptyDesktopNumberList(bool noCheating) {
    QList<int> emptyDesktopNumberList;

    for (int i = 1; i <= KWindowSystem::numberOfDesktops(); i++) {
        auto windowInfoList = getWindowInfoList(i, true);

        if (noCheating) {
            if (windowInfoList.empty()) {
                emptyDesktopNumberList << i;
            }
            continue;
        }

        bool isConsideredEmpty = true;
        for (auto& windowInfo : windowInfoList) {
            if (windowInfo.desktop() == i) {
                isConsideredEmpty = false;
                break;
            }
        }

        if (isConsideredEmpty) {
            emptyDesktopNumberList << i;
        }
    }

    return emptyDesktopNumberList;
}

void VirtualDesktopBar::sendDesktopInfoList() {
    QVariantList desktopInfoList;
    for (auto& desktopInfo : getDesktopInfoList(true)) {
        desktopInfoList << desktopInfo.toQVariantMap();
    }
    emit desktopInfoListSent(desktopInfoList);
}

void VirtualDesktopBar::tryAddEmptyDesktop() {
    if (cfg_DynamicDesktopsEnable) {
        auto emptyDesktopNumberList = getEmptyDesktopNumberList(false);
        if (emptyDesktopNumberList.empty()) {
            addDesktop();
        }
    }
}

void VirtualDesktopBar::tryRemoveEmptyDesktops() {
    if (cfg_DynamicDesktopsEnable) {
        auto emptyDesktopNumberList = getEmptyDesktopNumberList(false);
        for (int i = 1; i < emptyDesktopNumberList.length(); i++) {
            int desktopNumber = emptyDesktopNumberList[i];
            removeDesktop(desktopNumber);
        }
    }
}

void VirtualDesktopBar::tryRenameEmptyDesktops() {
    if (!cfg_EmptyDesktopsRenameAs.isEmpty()) {
        auto emptyDesktopNumberList = getEmptyDesktopNumberList();
        for (int desktopNumber : emptyDesktopNumberList) {
            renameDesktop(desktopNumber, cfg_EmptyDesktopsRenameAs);
        }
    }
}

void VirtualDesktopBar::updateLocalDesktopNumbers() {
    int n = KWindowSystem::currentDesktop();
    if (currentDesktopNumber != n) {
        mostRecentDesktopNumber = currentDesktopNumber;
    }
    currentDesktopNumber = n;
}
