import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

Item {
    id: appearanceConfig

    property alias cfg_enableAnimations: enableAnimations.checked
    property alias cfg_labelStyle: labelStyle.currentIndex
    property string cfg_labelFont: ""
    property int cfg_labelSize: 0
    property string cfg_labelColor: ""
    property alias cfg_invertIndicator: invertIndicator.checked
    property string cfg_indicatorColor: ""
    property alias cfg_showPlusButton: showPlusButton.checked

    GridLayout {
        columns: 1

        Item {
            height: 8
        }

        Label {
            text: "Desktop label"
            font.pixelSize: theme.defaultFont.pixelSize + 4
            Layout.columnSpan: 1
        }

        Item {
            height: 1
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

        RowLayout {
            CheckBox {
                id: labelFontCheckBox
                text: "Custom desktop label font:"
                checked: appearanceConfig.cfg_labelFont != ""
                onCheckedChanged: appearanceConfig.cfg_labelFont = labelFontCheckBox.checked ?
                                  labelFontComboBox.model[labelFontComboBox.currentIndex].value : "";
            }

            ComboBox {
                id: labelFontComboBox
                enabled: labelFontCheckBox.checked
                Layout.fillWidth: true

                Component.onCompleted: {
                    var arr = [];
                    var fonts = Qt.fontFamilies()
                    for (var i = 0; i < fonts.length; i++) {
                        arr.push({text: fonts[i], value: fonts[i]});
                    }
                    model = arr;

                    var foundIndex = labelFontComboBox.find(appearanceConfig.cfg_labelFont);
                    if (foundIndex == -1) {
                        foundIndex = labelFontComboBox.find(theme.defaultFont.family);
                    }
                    if (foundIndex >= 0) {
                        labelFontComboBox.currentIndex = foundIndex;
                    } 
                }

                onCurrentIndexChanged: {
                    if (enabled && currentIndex) {
                        appearanceConfig.cfg_labelFont = model[currentIndex].value;
                    }
                }
            }
        }

        RowLayout {
            CheckBox {
                id: labelSizeCheckBox
                text: "Custom desktop label font size:"
                checked: appearanceConfig.cfg_labelSize > 0
                onCheckedChanged: appearanceConfig.cfg_labelSize = labelSizeCheckBox.checked ? labelSize.value : 0;
            }

            SpinBox {
                id: labelSize
                enabled: labelSizeCheckBox.checked
                Layout.fillWidth: true
                value: appearanceConfig.cfg_labelSize || theme.defaultFont.pixelSize
                minimumValue: 8
                maximumValue: 64
                suffix: " px"
                onValueChanged: {
                    if (labelSizeCheckBox.checked) {
                        appearanceConfig.cfg_labelSize = value;
                    }
                }
            }
        }

        ColorDialog {
            id: labelColorDialog
            title: "Choose a color"
            visible: false
            color: labelColorButton.color
            onAccepted: {
                labelColorButton.color = labelColorDialog.color;
                appearanceConfig.cfg_labelColor = labelColorCheckBox.checked ? labelColorButton.color : "";
                Qt.quit();
            }
        }

        RowLayout {
            CheckBox {
                id: labelColorCheckBox
                text: "Custom desktop label color:"
                checked: appearanceConfig.cfg_labelColor != ""
                onCheckedChanged: appearanceConfig.cfg_labelColor = labelColorCheckBox.checked ? labelColorButton.color : "";
            }

            Button {
                id: labelColorButton
                enabled: labelColorCheckBox.checked
                implicitWidth: 25
                implicitHeight: 20
                opacity: labelColorCheckBox.checked ? 1 : 0.3
                onClicked: labelColorDialog.visible = true;

                property var color: cfg_labelColor != "" ? cfg_labelColor : theme.textColor
                
                style: ButtonStyle {
                    background: Rectangle {
                        radius: 4
                        color: labelColorButton.color
                        border.width: 1
                        border.color: "gray"
                    }
                }
            }
        }

        Item {
            height: 8
        }

        Label {
            text: "Desktop indicator"
            font.pixelSize: theme.defaultFont.pixelSize + 4
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: invertIndicator
            text: "Invert desktop indicator position"
            Layout.columnSpan: 1
        }

        ColorDialog {
            id: indicatorColorDialog
            title: "Choose a color"
            visible: false
            color: indicatorColorButton.color
            onAccepted: {
                indicatorColorButton.color = indicatorColorDialog.color;
                appearanceConfig.cfg_indicatorColor = indicatorColorCheckBox.checked ? indicatorColorButton.color : "";
                Qt.quit();
            }
        }

        RowLayout {
            CheckBox {
                id: indicatorColorCheckBox
                text: "Custom desktop indicator color:"
                checked: appearanceConfig.cfg_indicatorColor != ""
                onCheckedChanged: appearanceConfig.cfg_indicatorColor = indicatorColorCheckBox.checked ? indicatorColorButton.color : "";
            }

            Button {
                id: indicatorColorButton
                enabled: indicatorColorCheckBox.checked
                implicitWidth: 25
                implicitHeight: 20
                opacity: indicatorColorCheckBox.checked ? 1 : 0.3
                onClicked: indicatorColorDialog.visible = true;

                property var color: cfg_indicatorColor != "" ? cfg_indicatorColor : theme.buttonFocusColor
                
                style: ButtonStyle {
                    background: Rectangle {
                        radius: 4
                        color: indicatorColorButton.color
                        border.width: 1
                        border.color: "gray"
                    }
                }
            }
        }

        Item {
            height: 8
        }

        Label {
            text: "Misc"
            font.pixelSize: theme.defaultFont.pixelSize + 4
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: enableAnimations
            text: "Enable plasmoid animations"
            Layout.columnSpan: 1
        }

        CheckBox {
            id: showPlusButton
            text: "Show a plus button for adding new desktops"
            Layout.columnSpan: 1
        }
    }
}
