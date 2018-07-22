#ifndef MDSMODEL_H
#define MDSMODEL_H

#include <QObject>
#include <QVariantList>
#include <virtualdesktopinfo.h>

using namespace TaskManager;

class MDSModel : public QObject {
    Q_OBJECT

public:
    MDSModel(QObject* parent = nullptr);

    Q_INVOKABLE QVariantList getDesktopNames() const;
    Q_INVOKABLE QVariant getActiveDesktopNumber() const;

signals:
    void desktopChanged();

private:
    VirtualDesktopInfo desktopInfo;
};

#endif // MDSMODEL_H
