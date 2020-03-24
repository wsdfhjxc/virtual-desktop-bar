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
            text: "Applet version"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        Label {
            text: "Current version is 0.8"
            Layout.columnSpan: 1
        }

        Label {
            text: "<html><a href='a'>Click here to check for updates</a></html>"
            onLinkActivated: Qt.openUrlExternally("https://store.kde.org/p/1315319/#updates-panel")
        }

        Item {
            height: 10
        }

        Label {
            text: "Compatibility with KWin tiling scripts"
            font.pixelSize: labelFontPixelSize
            Layout.columnSpan: 1
        }

        Item {
            height: 1
        }

        CheckBox {
            id: enableKWinScriptsAPI
            text: "Enable communication with KWin tiling scripts"
            Layout.columnSpan: 1
        }

        Label {
            text: "<html><a href='a'>Click here to see more information about this option</a></html>"
            onLinkActivated: Qt.openUrlExternally("https://github.com/wsdfhjxc/virtual-desktop-bar#compatibility-with-kwin-tiling-scripts")
        }
    }
}
