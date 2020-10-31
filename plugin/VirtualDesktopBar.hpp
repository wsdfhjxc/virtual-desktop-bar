#pragma once

#include <QAction>
#include <QDBusInterface>
#include <QList>
#include <QMap>
#include <QObject>
#include <QString>
#include <QVariantList>

#include <netwm.h>

#include <KActionCollection>
#include <KWindowSystem>

#include "DesktopInfo.hpp"

class VirtualDesktopBar : public QObject {
    Q_OBJECT

public:
    VirtualDesktopBar(QObject* parent = nullptr);

    Q_INVOKABLE void requestDesktopInfoList();

    Q_INVOKABLE void showDesktop(int number);
    Q_INVOKABLE void addDesktop(unsigned position = 0);
    Q_INVOKABLE void removeDesktop(int number);
    Q_INVOKABLE void renameDesktop(int number, QString name);
    Q_INVOKABLE void replaceDesktops(int number1, int number2);

    Q_PROPERTY(QString cfg_EmptyDesktopsRenameAs
               MEMBER cfg_EmptyDesktopsRenameAs
               NOTIFY cfg_EmptyDesktopsRenameAsChanged);

    Q_PROPERTY(QString cfg_AddingDesktopsExecuteCommand
               MEMBER cfg_AddingDesktopsExecuteCommand
               NOTIFY cfg_AddingDesktopsExecuteCommandChanged);

    Q_PROPERTY(bool cfg_DynamicDesktopsEnable
               MEMBER cfg_DynamicDesktopsEnable
               NOTIFY cfg_DynamicDesktopsEnableChanged);

    Q_PROPERTY(bool cfg_MultipleScreensFilterOccupiedDesktops
               MEMBER cfg_MultipleScreensFilterOccupiedDesktops
               NOTIFY cfg_MultipleScreensFilterOccupiedDesktopsChanged);

    void cfg_EmptyDesktopsRenameAsChanged();
    void cfg_AddingDesktopsExecuteCommandChanged();
    void cfg_DynamicDesktopsEnableChanged();
    void cfg_MultipleScreensFilterOccupiedDesktopsChanged();

signals:
    void desktopInfoListSent(QVariantList desktopInfoList);
    void requestRenameCurrentDesktop();

private:
    NETRootInfo netRootInfo;
    QDBusInterface dbusInterface;
    QString dbusInterfaceName;

    void setUpSignals();
    void setUpGlobalKeyboardShortcuts();

    QMap<QString, QString> windowNameSubstitutionMap;
    void setUpWindowNameSubstitutions();

    DesktopInfo getDesktopInfo(int number);
    DesktopInfo getDesktopInfo(QString id);
    QList<DesktopInfo> getDesktopInfoList(bool extraInfo = false);
    QList<KWindowInfo> getWindowInfoList(int desktopNumber, bool ignoreScreens = false);
    QList<int> getEmptyDesktopNumberList(bool noCheating = true);

    QString cfg_EmptyDesktopsRenameAs;
    QString cfg_AddingDesktopsExecuteCommand;
    bool cfg_DynamicDesktopsEnable;
    bool cfg_MultipleScreensFilterOccupiedDesktops;
    bool cfg_MultipleScreensEnableSeparateDesktops;

    void sendDesktopInfoList();
    bool sendDesktopInfoListLock;

    void tryAddEmptyDesktop();
    bool tryAddEmptyDesktopLock;

    void tryRemoveEmptyDesktops();
    bool tryRemoveEmptyDesktopsLock;

    void tryRenameEmptyDesktops();
    bool tryRenameEmptyDesktopsLock;

    void processChanges(std::function<void()> callback, bool& lock);

    int currentDesktopNumber;
    int mostRecentDesktopNumber;
    void updateLocalDesktopNumbers();

    KActionCollection* actionCollection;
    QAction* actionSwitchToRecentDesktop;
    QAction* actionAddDesktop;
    QAction* actionRemoveLastDesktop;
    QAction* actionRemoveCurrentDesktop;
    QAction* actionRenameCurrentDesktop;
    QAction* actionMoveCurrentDesktopToLeft;
    QAction* actionMoveCurrentDesktopToRight;
};
