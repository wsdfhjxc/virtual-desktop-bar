import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {
    id: advancedConfig

    property alias cfg_enableKWinScriptsAPI: enableKWinScriptsAPI.checked

    property var labelFontPixelSize: theme.defaultFont.pixelSize + 4

    GridLayout {
        columns: 1

        Item {
            height: 10
        }

        Label {
            text: "Tweaks for KWin scripts"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: enableKWinScriptsAPI
            text: "Enable API for compatible KWin Scripts"
            Layout.columnSpan: 1
        }

        Label {
            text: "<html><a href='a'>Click here for more information about this option</a></html>"
            onLinkActivated: Qt.openUrlExternally("https://github.com/wsdfhjxc/virtual-desktop-bar#compatibility-with-kwin-tiling-scripts")
        }

        Item {
            height: 10
        }
    }
}
