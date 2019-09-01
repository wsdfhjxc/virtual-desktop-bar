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

    TextField {
        id: desktopNameInput
        implicitWidth: 162
        implicitHeight: 28
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
