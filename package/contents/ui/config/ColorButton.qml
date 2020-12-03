import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0

Button {
    id: button
    enabled: false
    implicitWidth: theme.defaultFont.pixelSize * 2.1
    implicitHeight: theme.defaultFont.pixelSize * 1.67
    opacity: enabled ? 1 : 0.3

    property string color
    property var colorAcceptedCallback

    style: ButtonStyle {
        background: Rectangle {
            radius: 4
            border.width: 1
            color: button.color
            border.color: "gray"
        }
    }

    ColorDialog {
        id: dialog
        title: "Choose a color"
        showAlphaChannel: true
        visible: false
        onAccepted: {
            button.color = color;
            colorAcceptedCallback(color);
            dialog.visible = false;
        }
    }

    onClicked: dialog.visible = true

    Component.onCompleted: dialog.color = color
}
