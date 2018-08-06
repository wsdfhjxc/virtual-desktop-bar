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
    Q_INVOKABLE void addDesktop(const QString desktopName = QString());
    Q_INVOKABLE void removeDesktop();
    Q_INVOKABLE void removeDesktop(int desktopNumber);
    Q_INVOKABLE void removeCurrentDesktop();
    Q_INVOKABLE void renameCurrentDesktop(const QString desktopName);

signals:
    void activated();
    void desktopChanged(int desktopNumber);
    void desktopAmountChanged(int desktopAmount);
    void desktopNamesChanged();

private:
    NETRootInfo netRootInfo;

    KActionCollection* actionCollection;
    QAction* actionAddDesktop;
    QAction* actionRemoveDesktop;
    QAction* actionRenameDesktop;
};

#endif // MDSMODEL_H
