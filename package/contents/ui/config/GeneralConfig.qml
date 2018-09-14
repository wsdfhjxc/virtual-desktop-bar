import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: generalConfig

    property alias cfg_showPlusButton: showPlusButton.checked
    property alias cfg_switchToNewDesktop: switchToNewDesktop.checked
    property alias cfg_renameNewDesktop: renameNewDesktop.checked

    GridLayout {
        columns: 1

        CheckBox {
            id: showPlusButton
            text: "Show Add New Virtual Desktop button at the end"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: switchToNewDesktop
            text: "Automatically switch to a new Virtual Desktop"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: renameNewDesktop
            text: "Prompt to rename a new Virtual Desktop"
            enabled: switchToNewDesktop.checked
            Layout.columnSpan: 1
        }
    }
}
