import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4

Dialog {
    title: "Minimal Desktop Switcher"
    standardButtons: StandardButton.Ok | StandardButton.Cancel

    Column {
        anchors.fill: parent

        Row {

            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: theme.textColor
                text: "Desktop name:"
            }

            Item {
                width: 10
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

        Item {
            width: 1
            height: 10
        }
    }
}
