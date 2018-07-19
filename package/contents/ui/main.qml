import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0

RowLayout {
    id: root
    spacing: 8
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    Component {
        id: desktopEntry

        Item {
            property int desktopLabelMargin: 2
            property int desktopIndicatorThickness: 2

            property string desktopName: "Desktop"
            property bool activeDesktop: false

            implicitWidth: desktopLabel.width + 2 * desktopLabelMargin
            implicitHeight: parent.height

            Label {
                id: desktopLabel
                text: desktopName
                x: desktopLabelMargin
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                id: desktopIndicator
                width: parent.width
                height: desktopIndicatorThickness
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
            }

            state: {
                if (activeDesktop) {
                    return "active"
                }
                if (mouseArea.containsMouse) {
                    return "hovered"
                }
                return "inactive"
            }

            states: [
                State {
                    name: "inactive"

                    PropertyChanges {
                        target: desktopLabel
                        opacity: 0.75
                    }

                    PropertyChanges {
                        target: desktopIndicator
                        opacity: 0
                    }

                },

                State {
                    name: "active"

                    PropertyChanges {
                        target: desktopLabel
                        opacity: 1
                    }

                    PropertyChanges {
                        target: desktopIndicator
                        color: theme.buttonHoverColor
                        opacity: 1
                    }
                },

                State {
                    name: "hovered"

                    PropertyChanges {
                        target: desktopLabel
                        opacity: 0.75
                    }

                    PropertyChanges {
                        target: desktopIndicator
                        color: theme.textColor
                        opacity: 0.15
                    }
                }
            ]
        }
    }

    Component.onCompleted: {
        desktopEntry.createObject(root, {"activeDesktop": true})
        desktopEntry.createObject(root, {"desktopName": "Other desktop"})
        desktopEntry.createObject(root, {"desktopName": "Another one"})
    }
}
