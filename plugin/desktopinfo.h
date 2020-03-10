#ifndef DESKTOPINFO_H
#define DESKTOPINFO_H

#include <QString>
#include <QDBusArgument>

struct DesktopInfo {
    int number;
    QString id;
    QString name;
};

const QDBusArgument& operator>>(const QDBusArgument& arg, DesktopInfo& info) {
    arg.beginStructure();
    arg >> info.number;
    arg >> info.id;
    arg >> info.name;
    arg.endStructure();
    return arg;
}

#endif // DESKTOPINFO_H
