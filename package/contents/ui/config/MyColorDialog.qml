import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Dialogs 1.0

Item {
    property var colorButton
    property var acceptedCallback

    ColorDialog {
        id: dialog
        title: "Choose a color"
        visible: false
        onAccepted: {
            colorButton.setColor(color);
            acceptedCallback(color);
            setVisible(false);
        }
    }

    function setColor(color) {
        dialog.color = color;
    }

    function setColorButton(button) {
        colorButton = button;
    }

    function setAcceptedCallback(func) {
        acceptedCallback = func;
    }

    function setVisible(visible) {
        dialog.visible = visible;
    }
}
