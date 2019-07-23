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
    property alias cfg_entrySpacing: entrySpacing.currentIndex 

    property var labelFontPixelSize: theme.defaultFont.pixelSize + 4

    GridLayout {
        columns: 1

        Item {
            height: 8
        }

        Label {
            text: "Desktop entries"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        RowLayout {
            Label {
                text: "Spacing between desktop entries:"
            }

            ComboBox {
                id: entrySpacing
                Layout.fillWidth: true
                model: [ "Small", "Medium", "Large" ]
            }
        }

        Item {
            height: 8
        }

        Label {
            text: "Desktop label"
            font.pixelSize: labelFontPixelSize
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
                checked: cfg_labelFont
                onCheckedChanged: cfg_labelFont = checked ?
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

                    var foundIndex = find(cfg_labelFont);
                    if (foundIndex == -1) {
                        foundIndex = find(theme.defaultFont.family);
                    }
                    if (foundIndex >= 0) {
                        currentIndex = foundIndex;
                    } 
                }

                onCurrentIndexChanged: {
                    if (enabled && currentIndex) {
                        cfg_labelFont = model[currentIndex].value;
                    }
                }
            }
        }

        RowLayout {
            CheckBox {
                id: labelSizeCheckBox
                text: "Custom desktop label font size:"
                checked: cfg_labelSize > 0
                onCheckedChanged: cfg_labelSize = checked ? labelSize.value : 0;
            }

            SpinBox {
                id: labelSize
                enabled: labelSizeCheckBox.checked
                Layout.fillWidth: true
                value: cfg_labelSize || theme.defaultFont.pixelSize
                minimumValue: 8
                maximumValue: 64
                suffix: " px"
                onValueChanged: {
                    if (labelSizeCheckBox.checked) {
                        cfg_labelSize = value;
                    }
                }
            }
        }

        Row {
            CheckBox {
                id: labelColorCheckBox
                text: "Custom desktop label color:"
                onCheckedChanged: {
                    cfg_labelColor = checked ? labelColorButton.getColor() : "";
                    labelColorButton.setEnabled(checked);
                }

                Component.onCompleted: {
                    if (cfg_labelColor) {
                        checked = true;
                    }
                }
            }

            MyColorButton {
                id: labelColorButton
                anchors.left: labelColorCheckBox.right
            }

            MyColorDialog {
                id: labelColorDialog
            }

            Component.onCompleted: {
                labelColorButton.setEnabled(labelColorCheckBox.checked);
                labelColorButton.setColor(cfg_labelColor || theme.textColor);
                labelColorButton.setDialog(labelColorDialog);

                labelColorDialog.setColor(labelColorButton.getColor());
                labelColorDialog.setColorButton(labelColorButton);
                labelColorDialog.setAcceptedCallback(function(color) {
                    cfg_labelColor = color;
                });
            }
        }

        Item {
            height: 8
        }

        Label {
            text: "Desktop indicator"
            font.pixelSize: labelFontPixelSize
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

        Row {
            CheckBox {
                id: indicatorColorCheckBox
                text: "Custom desktop indicator color:"
                onCheckedChanged:  {
                    cfg_indicatorColor = checked ? indicatorColorButton.getColor() : "";
                    indicatorColorButton.setEnabled(checked);
                }

                Component.onCompleted: {
                    if (cfg_indicatorColor) {
                        checked = true;
                    }
                }
            }

            MyColorButton {
                id: indicatorColorButton
                anchors.left: indicatorColorCheckBox.right
            }

            MyColorDialog {
                id: indicatorColorDialog
            }

            Component.onCompleted: {
                indicatorColorButton.setEnabled(labelColorCheckBox.checked);
                indicatorColorButton.setColor(cfg_indicatorColor || theme.buttonFocusColor);
                indicatorColorButton.setDialog(indicatorColorDialog);

                indicatorColorDialog.setColor(indicatorColorButton.getColor());
                indicatorColorDialog.setColorButton(indicatorColorButton);
                indicatorColorDialog.setAcceptedCallback(function(color) {
                    cfg_indicatorColor = color;
                });
            }
        }

        Item {
            height: 8
        }

        Label {
            text: "Misc"
            font.pixelSize: labelFontPixelSize
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

        Item {
            height: 8
        }
    }
}
