import QtQuick 2.1
import QtQuick.Controls 1.4

Item {
    implicitWidth: label.width
    implicitHeight: parent.height
    visible: plasmoid.configuration.showPlusButton

    Label {
        id: label
        text: "+"
        font.pixelSize: 17
        anchors.verticalCenter: parent.verticalCenter
        color: theme.textColor
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
                opacity: 0.8
            }
        },

        State {
            name: "hovered"
            PropertyChanges {
                target: label
                opacity: 0.9
            }
        }
    ]

    transitions: [
        Transition {
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
