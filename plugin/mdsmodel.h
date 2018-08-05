#ifndef MDSMODEL_H
#define MDSMODEL_H

#include <QObject>
#include <QVariantList>
#include <netwm.h>
#include <QX11Info>

class MDSModel : public QObject {
    Q_OBJECT

public:
    MDSModel(QObject* parent = nullptr);

    Q_INVOKABLE QVariantList getDesktopNames() const;
    Q_INVOKABLE QVariant getActiveDesktopNumber() const;
    Q_INVOKABLE QVariant getActiveDesktopName() const;

    Q_INVOKABLE void switchToDesktop(int desktopNumber);
    Q_INVOKABLE void addDesktop(const QString desktopName = QString());
    Q_INVOKABLE void removeDesktop();
    Q_INVOKABLE void renameActiveDesktop(const QString desktopName);

signals:
    void desktopChanged(int desktopNumber);
    void desktopAmountChanged(int desktopAmount);
    void desktopNamesChanged();

private:
    NETRootInfo netRootInfo;
};

#endif // MDSMODEL_H
