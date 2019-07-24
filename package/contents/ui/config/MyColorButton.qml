import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Button {
    id: button
    enabled: false
    implicitWidth: 25
    implicitHeight: 20
    opacity: enabled ? 1 : 0.3
    tooltip: "Click to choose a color"

    property var buttonColor: "red"
    property var dialog

    style: ButtonStyle {
        background: Rectangle {
            radius: 4
            color: buttonColor
            border.width: 1
            border.color: "gray"
        }
    }

    onClicked: dialog.setVisible(true)

    function setEnabled(enabled) {
        button.enabled = enabled;
    }

    function setColor(color) {
        buttonColor = color;
    }

    function setDialog(dialog) {
        this.dialog = dialog;
    }

    function getColor() {
        return buttonColor;
    }
}
