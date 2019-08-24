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
    property alias cfg_switchWithWheel: switchWithWheel.checked
    property alias cfg_invertWheelSwitch: invertWheelSwitch.checked
    property alias cfg_wheelSwitchWrap: wheelSwitchWrap.checked

    property var labelFontPixelSize: theme.defaultFont.pixelSize + 4

    GridLayout {
        columns: 1

        Item {
            height: 8
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
                onCheckedChanged: {
                    if (checked) {
                        if (emptyDesktopName.text) {
                            cfg_emptyDesktopName = emptyDesktopName.text;
                        } else {
                            cfg_emptyDesktopName = "Empty";
                        }
                    } else {
                        cfg_emptyDesktopName = "";
                    }
                }
            }

            TextField {
                id: emptyDesktopName
                enabled: emptyDesktopNameCheckBox.checked
                maximumLength: 20
                implicitWidth: 90
                horizontalAlignment: TextInput.AlignHCenter
                placeholderText: "Empty"
                text: cfg_emptyDesktopName
                onEditingFinished: cfg_emptyDesktopName = text ? text : "Empty"
            }
        }

        Item {
            height: 8
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
            text: "Immediately prompt to rename a manually added desktop"
            enabled: switchToNewDesktop.enabled && switchToNewDesktop.checked
            Layout.columnSpan: 1
        }

        Item {
            height: 8
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
            height: 8
        }
    }
}
