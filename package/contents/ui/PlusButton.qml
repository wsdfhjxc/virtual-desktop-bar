import QtQuick 2.1
import QtQuick.Controls 1.4

Item {
    implicitWidth: vertical ? parent.width : label.width 
    implicitHeight: !vertical ? parent.height : label.height
    anchors.horizontalCenter: vertical ? parent.horizontalCenter : null
    visible: plasmoid.configuration.showPlusButton && !plasmoid.configuration.dropRedundantDesktops

    Label {
        id: label
        text: plasmoid.configuration.plusButtonSymbol || "＋"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: {
            var margin = 0;
            if (!desktopSwitcher.vertical) {
                margin = (parent.height - height) / 2;
                if (text == "＋") {
                    margin -= 1;
                }
            } else {
                margin = implicitHeight / -4.5;
            }
            return margin;
        }
        font.pixelSize: plasmoid.configuration.plusButtonSize ||
                        plasmoid.configuration.labelSize || theme.defaultFont.pixelSize
        color: plasmoid.configuration.labelColor || theme.textColor
        font.family: plasmoid.configuration.labelFont || theme.defaultFont.family
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent

        onClicked: {
            virtualDesktopBar.addNewDesktop();
        }
    }

    state: {
        return mouseArea.containsMouse ? "hovered" : "default"
    }

    states: [
        State {
            name: "default"
            PropertyChanges {
                target: label
                opacity: plasmoid.configuration.dimLabelForIdle ? 0.7 : 0.9
            }
        },

        State {
            name: "hovered"
            PropertyChanges {
                target: label
                opacity: plasmoid.configuration.dimLabelForIdle ? 0.8 : 0.9
            }
        }
    ]

    transitions: [
        Transition {
            enabled: plasmoid.configuration.enableAnimations
            to: "hovered"
            ParallelAnimation {
                NumberAnimation {
                    target: label
                    property: "opacity"
                    duration: 150
                }
            }
        },

        Transition {
            enabled: plasmoid.configuration.enableAnimations
            to: "default"
            ParallelAnimation {
                NumberAnimation {
                    target: label
                    property: "opacity"
                    duration: 300
                }
            }
        }
    ]
}
