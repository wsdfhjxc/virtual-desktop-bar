#ifndef VIRTUALDESKTOPBAR_H
#define VIRTUALDESKTOPBAR_H

#include <QObject>
#include <QVariantList>
#include <netwm.h>
#include <QX11Info>
#include <QAction>
#include <KActionCollection>
#include <QDBusInterface>
#include <QPair>

class VirtualDesktopBar : public QObject {
    Q_OBJECT

public:
    VirtualDesktopBar(QObject* parent = nullptr);

    Q_INVOKABLE const QList<QString> getDesktopNames() const;
    Q_INVOKABLE const QString getCurrentDesktopName() const;
    Q_INVOKABLE int getCurrentDesktopNumber() const;
    Q_INVOKABLE const QList<int> getEmptyDesktops() const;

    Q_INVOKABLE void switchToDesktop(const int desktopNumber);
    Q_INVOKABLE void switchToRecentDesktop();

    Q_INVOKABLE void addNewDesktop(bool guard = true, const QString desktopName = QString());

    Q_INVOKABLE void removeDesktop(const int desktopNumber);
    Q_INVOKABLE void removeCurrentDesktop();
    Q_INVOKABLE void removeLastDesktop();

    Q_INVOKABLE void renameDesktop(const int desktopNumber, const QString desktopName);
    Q_INVOKABLE void renameCurrentDesktop(const QString desktopName);

    Q_INVOKABLE void swapDesktop(const int desktopNumber, const int targetDesktopNumber);
    Q_INVOKABLE void moveDesktop(const int desktopNumber, const int moveStep);
    Q_INVOKABLE void moveDesktopToLeft(const int desktopNumber);
    Q_INVOKABLE void moveDesktopToRight(const int desktopNumber);
    Q_INVOKABLE void moveCurrentDesktopToLeft();
    Q_INVOKABLE void moveCurrentDesktopToRight();

    Q_PROPERTY(bool cfg_keepOneEmptyDesktop
               READ get_cfg_keepOneEmptyDesktop
               WRITE set_cfg_keepOneEmptyDesktop)

    Q_PROPERTY(bool cfg_dropRedundantDesktops
               READ get_cfg_dropRedundantDesktops
               WRITE set_cfg_dropRedundantDesktops)
    
    Q_PROPERTY(QString cfg_emptyDesktopName
               READ get_cfg_emptyDesktopName
               WRITE set_cfg_emptyDesktopName)

    Q_PROPERTY(QString cfg_newDesktopCommand
               MEMBER cfg_newDesktopCommand)

    bool get_cfg_keepOneEmptyDesktop();
    void set_cfg_keepOneEmptyDesktop(bool value);

    bool get_cfg_dropRedundantDesktops();
    void set_cfg_dropRedundantDesktops(bool value);

    QString get_cfg_emptyDesktopName();
    void set_cfg_emptyDesktopName(QString value);

signals:
    void currentDesktopChanged(const int desktopNumber);
    void desktopAmountChanged(const int desktopAmount);

    void currentDesktopNameChangeRequested();
    void desktopNamesChanged();

    void emptyDesktopsUpdated(QList<int> desktopNumbers);

private:
    NETRootInfo netRootInfo;

    bool cfg_keepOneEmptyDesktop;
    bool cfg_dropRedundantDesktops;
    QString cfg_emptyDesktopName;
    QString cfg_newDesktopCommand;

    KActionCollection* actionCollection;
    QAction* actionSwitchToRecentDesktop;
    QAction* actionAddNewDesktop;
    QAction* actionRemoveLastDesktop;
    QAction* actionRemoveCurrentDesktop;
    QAction* actionRenameCurrentDesktop;
    QAction* actionMoveCurrentDesktopToLeft;
    QAction* actionMoveCurrentDesktopToRight;

    QDBusInterface dbusInterface;

    void onCurrentDesktopChanged(const int desktopNumber);
    void onDesktopAmountChanged(const int desktopAmount);

    void setUpSignalForwarding();
    void setUpGlobalKeyboardShortcuts();

    const QList<WId> getWindows(const int desktopNumber, const bool afterDesktop = false);

    int currentDesktopNumber;
    int recentDesktopNumber;

    QList<QPair<WId, int>> windowDesktopChangesToIgnore;

    bool canRemoveDesktop(const int desktopNumber);

    void removeEmptyDesktops();
    void renameEmptyDesktops(const QList<int>& emptyDesktops);

    void onWindowAdded(WId id);
    void onWindowChanged(WId id, NET::Properties properties, NET::Properties2);
    void onWindowRemoved(WId id);

    void renameDesktopDBus(const int desktopNumber, const QString desktopName);
};

#endif // VIRTUALDESKTOPBAR_H
