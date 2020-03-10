import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: behaviorConfig

    property alias cfg_keepOneEmptyDesktop: keepOneEmptyDesktop.checked
    property alias cfg_dropRedundantDesktops: dropRedundantDesktops.checked
    property string cfg_emptyDesktopName: ""
    property alias cfg_switchToNewDesktop: switchToNewDesktop.checked
    property alias cfg_renameNewDesktop: renameNewDesktop.checked
    property string cfg_newDesktopCommand: ""
    property alias cfg_switchWithWheel: switchWithWheel.checked
    property alias cfg_invertWheelSwitch: invertWheelSwitch.checked
    property alias cfg_wheelSwitchWrap: wheelSwitchWrap.checked

    property var labelFontPixelSize: theme.defaultFont.pixelSize + 4

    GridLayout {
        columns: 1

        Item {
            height: 10
        }

        Label {
            text: "Empty desktops"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: keepOneEmptyDesktop
            text: "Always keep at least one empty desktop"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: dropRedundantDesktops
            enabled: keepOneEmptyDesktop.checked
            text: "Automatically remove redundant empty desktops"
            Layout.columnSpan: 1
        }

        RowLayout {
            CheckBox {
                id: emptyDesktopNameCheckBox
                text: "Automatically rename empty desktops as:"
                checked: cfg_emptyDesktopName
                onCheckedChanged: cfg_emptyDesktopName = checked ? emptyDesktopName.text : ""
            }

            TextInput {
                id: hiddenTextInput
                visible: false
                text: emptyDesktopName.text
            }

            TextField {
                id: emptyDesktopName
                enabled: emptyDesktopNameCheckBox.checked
                maximumLength: 20
                implicitWidth: Math.max(30, hiddenTextInput.contentWidth + 16)
                horizontalAlignment: TextInput.AlignHCenter
                text: cfg_emptyDesktopName || "Desktop"
                onEditingFinished: cfg_emptyDesktopName = text
            }
        }

        Item {
            height: 16
        }

        Label {
            text: "Adding new desktops"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: switchToNewDesktop
            enabled: !keepOneEmptyDesktop.checked || !dropRedundantDesktops.checked
            text: "Automatically switch to a manually added desktop"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: renameNewDesktop
            text: "Automatically prompt to rename a manually added desktop"
            enabled: switchToNewDesktop.enabled && switchToNewDesktop.checked
            Layout.columnSpan: 1
        }

        RowLayout {
            CheckBox {
                id: newDesktopCommandCheckBox
                text: "Execute a command after manually adding a desktop:"
                enabled: !dropRedundantDesktops.checked
                checked: cfg_newDesktopCommand
                onCheckedChanged: cfg_newDesktopCommand = checked ? newDesktopCommand.text : "";
            }

            TextInput {
                id: hiddenTextInput2
                visible: false
                text: newDesktopCommand.text
            }

            TextField {
                id: newDesktopCommand
                enabled: newDesktopCommandCheckBox.enabled && newDesktopCommandCheckBox.checked
                maximumLength: 255
                implicitWidth: Math.max(30, hiddenTextInput2.contentWidth + 16)
                horizontalAlignment: TextInput.AlignHCenter
                text: cfg_newDesktopCommand || "krunner"
                onEditingFinished: cfg_newDesktopCommand = text
            }
        }

        Item {
            height: 16
        }

        Label {
            text: "Mouse wheel handling"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: switchWithWheel
            text: "Switch desktops with a mouse wheel"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: invertWheelSwitch
            text: "Invert mouse wheel desktop switching direction"
            enabled: switchWithWheel.checked
            Layout.columnSpan: 1
        }

        CheckBox {
            id: wheelSwitchWrap
            text: "Wrap desktop navigation after reaching first or last one"
            enabled: switchWithWheel.checked
            Layout.columnSpan: 1
        }

        Item {
            height: 10
        }
    }
}
