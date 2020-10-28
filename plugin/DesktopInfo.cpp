#include "DesktopInfo.hpp"

QVariantMap DesktopInfo::toQVariantMap() {
    QVariantMap map;
    map.insert("number", number);
    map.insert("id", id);
    map.insert("name", name);
    map.insert("isCurrent", isCurrent);
    map.insert("isEmpty", isEmpty);
    map.insert("isUrgent", isUrgent);
    map.insert("activeWindowName", activeWindowName);
    map.insert("windowNameList", QVariant(windowNameList));
    return map;
}

const QDBusArgument& operator>>(const QDBusArgument& arg, DesktopInfo& desktopInfo) {
    arg.beginStructure();
    arg >> desktopInfo.number;
    desktopInfo.number += 1;
    arg >> desktopInfo.id;
    arg >> desktopInfo.name;
    arg.endStructure();
    return arg;
}
