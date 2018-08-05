import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

RowLayout {
    Text {
        anchors.verticalCenter: parent.verticalCenter
        color: theme.textColor
        text: "Current Virtual Desktop Name:"
    }

    Item {
        width: 4
        height: 1
    }

    TextField {
        id: desktopNameInput
        implicitWidth: 162
        implicitHeight: 28
        text: "Desktop"
    }

    Timer {
        repeat: true
        running: true
        interval: 500
        onTriggered: {
            if (visible && !desktopNameInput.focus) {
                desktopNameInput.focus = true;
                desktopNameInput.selectAll();
            }
        }
    }

    Component.onCompleted: {
        refreshDesktopNameInput();
    }

    function refreshDesktopNameInput() {
        desktopNameInput.text = mdsModel.getActiveDesktopName();
        desktopNameInput.selectAll();
    }
}
