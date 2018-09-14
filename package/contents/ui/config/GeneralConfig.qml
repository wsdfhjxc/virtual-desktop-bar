import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: generalConfig

    property alias cfg_showPlusButton: showPlusButton.checked

    GridLayout {
        columns: 1

        CheckBox {
            id: showPlusButton
            text: "Show Add New Virtual Desktop button at the end"
            Layout.columnSpan: 1
        }
    }
}
