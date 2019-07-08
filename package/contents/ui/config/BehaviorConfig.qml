import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: behaviorConfig

    property alias cfg_keepOneEmptyDesktop: keepOneEmptyDesktop.checked
    property alias cfg_dropRedundantDesktops: dropRedundantDesktops.checked
    property alias cfg_switchToNewDesktop: switchToNewDesktop.checked
    property alias cfg_renameNewDesktop: renameNewDesktop.checked

    GridLayout {
        columns: 1

        Item {
            height: 8
        }

        CheckBox {
            id: keepOneEmptyDesktop
            text: "Always keep at least one empty desktop"
            Layout.columnSpan: 1

            Component.onCompleted: {
                if (keepOneEmptyDesktop.checked) {
                    checked = true;
                }
            }
        }

        CheckBox {
            id: dropRedundantDesktops
            enabled: keepOneEmptyDesktop.checked
            text: "Automatically remove redundant empty desktops"
            Layout.columnSpan: 1
        }

        Item {
            height: 8
        }

        CheckBox {
            id: switchToNewDesktop
            text: "Automatically switch to a manually added desktop"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: renameNewDesktop
            text: "Immediately prompt to rename a manually added desktop"
            enabled: switchToNewDesktop.checked
            Layout.columnSpan: 1
        }
    }
}
