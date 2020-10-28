import QtQuick 2.7
import QtQuick.Controls 1.4

Item {
    readonly property string objectType: "AddDesktopButton"

    implicitWidth: isVerticalOrientation ? parent.width : label.width
    implicitHeight: !isVerticalOrientation ? parent.height : label.height
    anchors.horizontalCenter: isVerticalOrientation ? parent.horizontalCenter : null
    visible: config.AddDesktopButtonShow && !config.DynamicDesktopsEnable

    Label {
        id: label

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: isVerticalOrientation ?
                           implicitHeight / -15 :
                           (parent.height - height) / 2 - 1
        anchors.leftMargin: isVerticalOrientation ?
                            (parent.width - width) / 2 :
                            implicitWidth / 2.5

        opacity: 1.0
        color: config.DesktopLabelsCustomColor || theme.textColor

        text: "+"
        font.weight: Font.Light
        font.family: config.DesktopLabelsCustomFont || theme.defaultFont.family
        font.pixelSize: (config.DesktopLabelsCustomFontSize || theme.defaultFont.pixelSize) * 1.5
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: container.lastHoveredButton = parent
        onClicked: backend.addDesktop()
    }
}
