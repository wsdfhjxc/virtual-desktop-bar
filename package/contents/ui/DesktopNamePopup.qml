import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

RowLayout {
    Text {
        anchors.verticalCenter: parent.verticalCenter
        color: theme.textColor
        text: "Virtual Desktop name:"
    }

    Item {
        width: 4
        height: 1
    }

    TextField {
        id: desktopNameInput
        width: 200
        text: "Desktop"

        Component.onCompleted: {
            selectAll();
            focus = true;
        }
    }
}
