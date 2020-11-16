import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common" as UICommon

Item {
    // Empty desktops
    property string cfg_EmptyDesktopsRenameAs

    // Adding desktops
    property alias cfg_AddingDesktopsSwitchTo: addingDesktopsSwitchToCheckBox.checked
    property alias cfg_AddingDesktopsPromptToRename: addingDesktopsPromptToRenameCheckBox.checked
    property string cfg_AddingDesktopsExecuteCommand

    // Dynamic desktops
    property alias cfg_DynamicDesktopsEnable: dynamicDesktopsEnableCheckBox.checked

    // Multiple screens/monitors
    property alias cfg_MultipleScreensFilterOccupiedDesktops: multipleScreensFilterOccupiedDesktopsCheckBox.checked

    // Mouse wheel handling
    property alias cfg_MouseWheelRemoveDesktopOnClick: mouseWheelRemoveDesktopOnClickCheckBox.checked
    property alias cfg_MouseWheelSwitchDesktopOnScroll: mouseWheelSwitchDesktopOnScrollCheckBox.checked
    property alias cfg_MouseWheelInvertDesktopSwitchingDirection: mouseWheelInvertDesktopSwitchingDirectionCheckBox.checked
    property alias cfg_MouseWheelWrapDesktopNavigationWhenScrolling: mouseWheelWrapDesktopNavigationWhenScrollingCheckBox.checked

    GridLayout {
        columns: 1

        SectionHeader {
            text: "Empty desktops"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: emptyDesktopsRenameAsCheckBox
                checked: cfg_EmptyDesktopsRenameAs
                onCheckedChanged: cfg_EmptyDesktopsRenameAs = checked ?
                                  emptyDesktopsRenameAsTextField.text : ""
                text: "Rename as"
            }

            UICommon.GrowingTextField {
                id: emptyDesktopsRenameAsTextField
                enabled: emptyDesktopsRenameAsCheckBox.checked
                maximumLength: 20
                text: cfg_EmptyDesktopsRenameAs || "Desktop"
                onTextChanged: {
                    if (cfg_EmptyDesktopsRenameAs && text) {
                        cfg_EmptyDesktopsRenameAs = text;
                    }
                }
                onEditingFinished: cfg_EmptyDesktopsRenameAs = text
            }
        }

        SectionHeader {
            text: "Adding desktops"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: addingDesktopsSwitchToCheckBox
                enabled: !dynamicDesktopsEnableCheckBox.checked
                text: "Switch to an added desktop"
            }

            HintIcon {
                visible: !addingDesktopsSwitchToCheckBox.enabled
                tooltipText: "Not available if dynamic desktops are enabled"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: addingDesktopsPromptToRenameCheckBox
                enabled: !dynamicDesktopsEnableCheckBox.checked
                text: "Prompt to rename an added desktop"
            }

            HintIcon {
                visible: !addingDesktopsPromptToRenameCheckBox.enabled
                tooltipText: "Not available if dynamic desktops are enabled"
            }
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: addingDesktopsExecuteCommandCheckBox
                checked: cfg_AddingDesktopsExecuteCommand
                onCheckedChanged: cfg_AddingDesktopsExecuteCommand = checked ?
                                  addingDesktopsExecuteCommandTextField.text : ""
                text: "Execute a command:"
            }

            UICommon.GrowingTextField {
                id: addingDesktopsExecuteCommandTextField
                enabled: addingDesktopsExecuteCommandCheckBox.enabled &&
                         addingDesktopsExecuteCommandCheckBox.checked
                maximumLength: 255
                text: cfg_AddingDesktopsExecuteCommand || "krunner"
                onTextChanged: {
                    if (cfg_AddingDesktopsExecuteCommand && text) {
                        cfg_AddingDesktopsExecuteCommand = text;
                    }
                }
                onEditingFinished: cfg_AddingDesktopsExecuteCommand = text
            }
        }

        SectionHeader {
            text: "Dynamic desktops"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: dynamicDesktopsEnableCheckBox
                text: "Enable dynamic desktops"
            }

            HintIcon {
                tooltipText: "Automatically adds and removes desktops"
            }
        }

        SectionHeader {
            text: "Multiple screens/monitors"
        }

        CheckBox {
            id: multipleScreensFilterOccupiedDesktopsCheckBox
            text: "Filter occupied desktops by screen/monitor"
        }

        SectionHeader {
            text: "Mouse wheel handling"
        }

        RowLayout {
            spacing: 0

            CheckBox {
                id: mouseWheelRemoveDesktopOnClickCheckBox
                enabled: !dynamicDesktopsEnableCheckBox.checked
                text: "Remove desktops on the wheel click"
            }

            HintIcon {
                visible: !mouseWheelRemoveDesktopOnClickCheckBox.enabled
                tooltipText: "Not available if dynamic desktops are enabled"
            }
        }

        CheckBox {
            id: mouseWheelSwitchDesktopOnScrollCheckBox
            text: "Switch desktops by scrolling the wheel"
        }

        CheckBox {
            id: mouseWheelInvertDesktopSwitchingDirectionCheckBox
            enabled: mouseWheelSwitchDesktopOnScrollCheckBox.checked
            text: "Invert wheel scrolling desktop switching direction"
        }

        CheckBox {
            id: mouseWheelWrapDesktopNavigationWhenScrollingCheckBox
            enabled: mouseWheelSwitchDesktopOnScrollCheckBox.checked
            text: "Wrap desktop navigation after reaching first or last one"
        }
    }
}
