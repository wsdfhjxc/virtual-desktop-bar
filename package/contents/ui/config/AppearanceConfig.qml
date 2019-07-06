import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: appearanceConfig

    property alias cfg_enableAnimations: enableAnimations.checked
    property alias cfg_labelStyle: labelStyle.currentIndex
    property alias cfg_invertIndicator: invertIndicator.checked
    property alias cfg_showPlusButton: showPlusButton.checked

    GridLayout {
        columns: 1

        Item {
            height: 5
        }

        CheckBox {
            id: enableAnimations
            text: "Enable plasmoid animations"
            Layout.columnSpan: 1
        }

        Item {
            height: 5
        }

        RowLayout {
            Label {
                text: "Desktop label style:"
            }

            ComboBox {
                id: labelStyle
                Layout.fillWidth: true
                model: [ "Number only", "Number and name", "Name only" ]
            }
        }

        Item {
            height: 5
        }

        CheckBox {
            id: invertIndicator
            text: "Invert desktop indicator position"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: showPlusButton
            text: "Show a button for adding new desktops (+)"
            Layout.columnSpan: 1
        }
    }
}
