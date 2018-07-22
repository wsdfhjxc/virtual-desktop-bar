import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.mds 2.0

RowLayout {
    id: root
    spacing: 8
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property var desktopEntries: []

    MDSModel {
        id: mdsModel
    }

    Component {
        id: desktopEntry

        Item {
            property int desktopLabelMargin: 2
            property int desktopIndicatorThickness: 2

            property int desktopNumber: 1
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

                onClicked: {
                    mdsModel.switchToDesktop(desktopNumber)
                }
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
                        color: theme.buttonHoverColor
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
                        opacity: 0.25
                    }
                }
            ]

            transitions: [
                Transition {
                    to: "hovered"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopIndicator
                            property: "opacity"
                            duration: 150
                        }
                    }
                },

                Transition {
                    to: "inactive"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopIndicator
                            property: "opacity"
                            duration: 300
                        }
                    }
                }
            ]
        }
    }

    Component.onCompleted: {
        var desktopNames = mdsModel.getDesktopNames();
        var activeDesktopNumber = mdsModel.getActiveDesktopNumber();

        for (var i = 0; i < desktopNames.length; i++) {
            var desktopNumber = i + 1;
            var desktopName = desktopNames[i];
            var activeDesktop = activeDesktopNumber == desktopNumber;

            desktopEntries.push(desktopEntry.createObject(root, {
                "desktopNumber": desktopNumber,
                "desktopName": desktopName,
                "activeDesktop": activeDesktop
            }));
        }
    }

    Connections {
        target: mdsModel

        onDesktopChanged: {
            var activeDesktopNumber = mdsModel.getActiveDesktopNumber();
            for (var i = 0; i < desktopEntries.length; i++) {
                var desktopEntry = desktopEntries[i];
                desktopEntry.activeDesktop = activeDesktopNumber == i + 1;
            }
        }
    }
}
