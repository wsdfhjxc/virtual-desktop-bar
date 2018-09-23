#ifndef VDBMODEL_H
#define VDBMODEL_H

#include <QObject>
#include <QVariantList>
#include <netwm.h>
#include <QX11Info>
#include <QAction>
#include <KActionCollection>

class VDBModel : public QObject {
    Q_OBJECT

public:
    VDBModel(QObject* parent = nullptr);

    Q_INVOKABLE const QVariantList getDesktopNames() const;
    Q_INVOKABLE const QVariant getCurrentDesktopName() const;
    Q_INVOKABLE const QVariant getCurrentDesktopNumber() const;

    Q_INVOKABLE void switchToDesktop(const int desktopNumber);
    Q_INVOKABLE void addNewDesktop(const QString desktopName = QString());

    Q_INVOKABLE void removeDesktop(const int desktopNumber = 0);
    Q_INVOKABLE void removeCurrentDesktop();
    Q_INVOKABLE void removeLastDesktop();

    Q_INVOKABLE void renameDesktop(const int desktopNumber, const QString desktopName);
    Q_INVOKABLE void renameCurrentDesktop(const QString desktopName);

    Q_INVOKABLE bool moveDesktop(const int desktopNumber, const int moveStep);
    Q_INVOKABLE bool moveDesktopToLeft(const int desktopNumber);
    Q_INVOKABLE bool moveDesktopToRight(const int desktopNumber);
    Q_INVOKABLE void moveCurrentDesktopToLeft();
    Q_INVOKABLE void moveCurrentDesktopToRight();

signals:
    void currentDesktopChanged(const int desktopNumber);
    void desktopAmountChanged(const int desktopAmount);

    void currentDesktopNameChangeRequested();
    void desktopRemoveRequested(int desktopNumber);
    void desktopNamesChanged();

private:
    NETRootInfo netRootInfo;

    KActionCollection* actionCollection;
    QAction* actionAddNewDesktop;
    QAction* actionRemoveLastDesktop;
    QAction* actionRemoveCurrentDesktop;
    QAction* actionRenameCurrentDesktop;
    QAction* actionMoveCurrentDesktopToLeft;
    QAction* actionMoveCurrentDesktopToRight;

    void setUpSignalForwarding();
    void setUpGlobalKeyboardShortcuts();

    const QList<WId> getWindows(const int desktopNumber, const bool afterDesktop = false);

    bool isFahoTilingLoaded();
    void refreshFahoTiling();
};

#endif // VDBMODEL_H
