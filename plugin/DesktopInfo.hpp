#pragma once

#include <QDBusArgument>
#include <QList>
#include <QString>
#include <QVariantMap>

class DesktopInfo {
public:
    // Basic info
    int number = 0;
    QString id = "";
    QString name = "";
    bool isCurrent = false;

    // Extra info
    bool isEmpty = true;
    bool isUrgent = false;
    QString activeWindowName;
    QList<QString> windowNameList;

    // "Serializing" method
    QVariantMap toQVariantMap();
};

const QDBusArgument& operator>>(const QDBusArgument& arg, DesktopInfo& desktopInfo);
