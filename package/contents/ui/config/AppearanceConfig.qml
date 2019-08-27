import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0

Item {
    id: appearanceConfig

    property alias cfg_entryWidth: entryWidth.currentIndex
    property alias cfg_entrySpacing: entrySpacing.currentIndex
    property alias cfg_labelStyle: labelStyle.currentIndex
    property string cfg_labelFont: ""
    property int cfg_labelSize: 0
    property string cfg_labelColor: ""
    property alias cfg_dimLabelForIdle: dimLabelForIdle.checked
    property alias cfg_indicatorStyle: indicatorStyle.currentIndex
    property alias cfg_invertIndicator: invertIndicator.checked
    property string cfg_indicatorColor: ""
    property string cfg_idleIndicatorColor: ""
    property alias cfg_distinctIndicatorOccupied: distinctIndicatorOccupied.checked
    property string cfg_occupiedIndicatorColor: ""
    property alias cfg_enableAnimations: enableAnimations.checked
    property alias cfg_showPlusButton: showPlusButton.checked
    

    property var labelFontPixelSize: theme.defaultFont.pixelSize + 4

    GridLayout {
        columns: 1

        Item {
            height: 16
        }

        Label {
            text: "Desktop buttons"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        RowLayout {
            Label {
                text: "Desktop button width:"
            }

            ComboBox {
                id: entryWidth
                model: [ "Small", "Medium", "Large" ]
            }
        }

        RowLayout {
            Label {
                text: "Spacing between desktop buttons:"
            }

            ComboBox {
                id: entrySpacing
                model: [ "Small", "Medium", "Large" ]
            }
        }

        CheckBox {
            id: showPlusButton
            text: "Show ＋ button for adding new desktops"
            Layout.columnSpan: 1
        }

        Item {
            height: 16
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
                implicitWidth: 150
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
                implicitWidth: 150

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

        RowLayout {
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
                    if (!occupiedIndicatorColorCheckBox.checked) {
                        occupiedIndicatorColorButton.setColor(color);
                    }
                });
            }
        }

        CheckBox {
            id: dimLabelForIdle
            text: "Dim desktop label for idle desktops"
            Layout.columnSpan: 1
        }

        Item {
            height: 16
        }

        Label {
            text: "Desktop indicator"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        RowLayout {
            Label {
                text: "Desktop indicator style:"
            }

            ComboBox {
                id: indicatorStyle
                implicitWidth: 100
                model: [ "Line", "Block", "Rounded" ]
            }
        }

        CheckBox {
            id: invertIndicator
            text: "Invert desktop indicator position"
            enabled: cfg_indicatorStyle == 0
            Layout.columnSpan: 1
        }

        RowLayout {
            CheckBox {
                id: indicatorColorCheckBox
                text: "Custom current desktop indicator color:"
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
            }

            MyColorDialog {
                id: indicatorColorDialog
            }

            Component.onCompleted: {
                indicatorColorButton.setColor(cfg_indicatorColor || theme.buttonFocusColor);
                indicatorColorButton.setDialog(indicatorColorDialog);

                indicatorColorDialog.setColor(indicatorColorButton.getColor());
                indicatorColorDialog.setColorButton(indicatorColorButton);
                indicatorColorDialog.setAcceptedCallback(function(color) {
                    cfg_indicatorColor = color;
                });
            }
        }

        RowLayout {
            CheckBox {
                id: idleIndicatorColorCheckBox
                text: "Custom desktop indicator color for idle desktops:"
                onCheckedChanged:  {
                    cfg_idleIndicatorColor = checked ? idleIndicatorColorButton.getColor() : "";
                    idleIndicatorColorButton.setEnabled(checked);
                }

                Component.onCompleted: {
                    if (cfg_idleIndicatorColor) {
                        checked = true;
                    }
                }
            }

            MyColorButton {
                id: idleIndicatorColorButton
            }

            MyColorDialog {
                id: idleIndicatorColorDialog
            }

            Component.onCompleted: {
                idleIndicatorColorButton.setColor(cfg_idleIndicatorColor || cfg_labelColor || theme.textColor);
                idleIndicatorColorButton.setDialog(idleIndicatorColorDialog);

                idleIndicatorColorDialog.setColor(idleIndicatorColorButton.getColor());
                idleIndicatorColorDialog.setColorButton(idleIndicatorColorButton);
                idleIndicatorColorDialog.setAcceptedCallback(function(color) {
                    cfg_idleIndicatorColor = color;
                });
            }
        }

        RowLayout {
            CheckBox {
                id: occupiedIndicatorColorCheckBox
                text: "Custom desktop indicator color for occupied idle desktops:"
                onCheckedChanged:  {
                    cfg_occupiedIndicatorColor = checked ? occupiedIndicatorColorButton.getColor() : "";
                    occupiedIndicatorColorButton.setEnabled(checked);
                }

                Component.onCompleted: {
                    if (cfg_occupiedIndicatorColor) {
                        checked = true;
                    }
                }
            }

            MyColorButton {
                id: occupiedIndicatorColorButton
            }

            MyColorDialog {
                id: occupiedIndicatorColorDialog
            }

            Component.onCompleted: {
                occupiedIndicatorColorButton.setColor(cfg_occupiedIndicatorColor || cfg_labelColor || theme.textColor);
                occupiedIndicatorColorButton.setDialog(occupiedIndicatorColorDialog);

                occupiedIndicatorColorDialog.setColor(occupiedIndicatorColorButton.getColor());
                occupiedIndicatorColorDialog.setColorButton(occupiedIndicatorColorButton);
                occupiedIndicatorColorDialog.setAcceptedCallback(function(color) {
                    cfg_occupiedIndicatorColor = color;
                });
            }
        }

        CheckBox {
            id: distinctIndicatorOccupied
            text: "Distinct desktop indicator for occupied idle desktops"
            Layout.columnSpan: 1
        }

        Item {
            height: 16
        }

        Label {
            text: "Other"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: enableAnimations
            text: "Enable animations"
            Layout.columnSpan: 1
        }

        Item {
            height: 16
        }
    }
}
