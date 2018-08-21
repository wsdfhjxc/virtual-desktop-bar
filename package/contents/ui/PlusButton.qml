import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Item {
    implicitWidth: label.width
    implicitHeight: parent.height

    Label {
        id: label
        text: "＋"
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent

        onClicked: {
            vdbModel.addNewDesktop();
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
