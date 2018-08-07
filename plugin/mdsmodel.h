#ifndef MDSMODEL_H
#define MDSMODEL_H

#include <QObject>
#include <QVariantList>
#include <netwm.h>
#include <QX11Info>
#include <QAction>
#include <KActionCollection>

class MDSModel : public QObject {
    Q_OBJECT

public:
    MDSModel(QObject* parent = nullptr);

    Q_INVOKABLE QVariantList getDesktopNames() const;
    Q_INVOKABLE QVariant getCurrentDesktopNumber() const;
    Q_INVOKABLE QVariant getCurrentDesktopName() const;

    Q_INVOKABLE void switchToDesktop(int desktopNumber);
    Q_INVOKABLE void addNewDesktop(const QString desktopName = QString());
    Q_INVOKABLE void removeLastDesktop();
    Q_INVOKABLE void removeDesktop(int desktopNumber);
    Q_INVOKABLE void removeCurrentDesktop();
    Q_INVOKABLE void renameCurrentDesktop(const QString desktopName);

signals:
    void currentDesktopChanged(int desktopNumber);
    void desktopAmountChanged(int desktopAmount);
    void desktopNamesChanged();
    void currentDesktopNameChangeRequested();

private:
    NETRootInfo netRootInfo;

    KActionCollection* actionCollection;
    QAction* actionAddNewDesktop;
    QAction* actionRemoveLastDesktop;
    QAction* actionRenameCurrentDesktop;
};

#endif // MDSMODEL_H
