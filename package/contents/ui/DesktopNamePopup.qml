import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

RowLayout {
    Text {
        Layout.alignment: Qt.AlignVCenter
        color: theme.textColor
        text: "Current Desktop Name:"
    }

    Item {
        width: 4
        height: 1
    }

    TextInput {
        id: hiddenTextInput
        visible: false
        text: desktopNameInput.text
    }

    TextField {
        id: desktopNameInput
        implicitWidth: Math.max(16, hiddenTextInput.contentWidth + 16)
        implicitHeight: 28
        horizontalAlignment: TextInput.AlignHCenter
        maximumLength: 20
        onAccepted: {
            virtualDesktopBar.renameCurrentDesktop(text);
            plasmoid.expanded = false;
        }
    }

    function refreshDesktopNameInput() {
        desktopNameInput.focus = true;
        desktopNameInput.text = virtualDesktopBar.getCurrentDesktopName();
        desktopNameInput.selectAll();
    }
}
