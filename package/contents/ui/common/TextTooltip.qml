import QtQuick 2.7
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.Dialog {
    visualParent: target
    type: PlasmaCore.Dialog.Tooltip
    flags: Qt.WindowDoesNotAcceptFocus
    location: PlasmaCore.Types.LeftEdge

    property Item target
    property string content

    mainItem: Text {
        width: implicitWidth
        height: implicitHeight

        text: content
        textFormat: Text.RichText
        color: theme.textColor
    }
}
