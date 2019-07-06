import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: appearanceConfig

    property alias cfg_enableAnimations: enableAnimations.checked
    property alias cfg_showPlusButton: showPlusButton.checked
    property alias cfg_prependDesktopNumber: prependDesktopNumber.checked

    GridLayout {
        columns: 1

        CheckBox {
            id: enableAnimations
            text: "Enable plasmoid animations"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: prependDesktopNumber
            text: "Show desktop numbers"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: showPlusButton
            text: "Show a button for adding new desktops (+)"
            Layout.columnSpan: 1
        }
    }
}
