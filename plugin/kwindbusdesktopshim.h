#ifndef KWINDBUSDESKTOPSHIM_H
#define KWINDBUSDESKTOPSHIM_H

#include <QString>
#include <QDBusArgument>

struct KWinDBusDesktopShim {
    int number;
    QString id;
    QString name;
};

const QDBusArgument& operator>>(const QDBusArgument& arg, KWinDBusDesktopShim& shim) {
    arg.beginStructure();
    arg >> shim.number;
    arg >> shim.id;
    arg >> shim.name;
    arg.endStructure();
    return arg;
}

#endif // KWINDBUSDESKTOPSHIM_H
