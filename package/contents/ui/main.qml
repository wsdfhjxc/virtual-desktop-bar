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
                color: theme.buttonHoverColor
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
                        opacity: 0.7
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
                        opacity: 1
                    }
                },

                State {
                    name: "hovered"
                    PropertyChanges {
                        target: desktopLabel
                        opacity: 0.9
                    }
                    PropertyChanges {
                        target: desktopIndicator
                        opacity: 0
                    }

                }
            ]

            transitions: [
                Transition {
                    to: "hovered"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopLabel
                            property: "opacity"
                            duration: 150
                        }
                    }
                },

                Transition {
                    to: "inactive"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopLabel
                            property: "opacity"
                            duration: 300
                        }
                        NumberAnimation {
                            target: desktopIndicator
                            property: "opacity"
                            duration: 300
                        }
                    }
                },

                Transition {
                    to: "active"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopLabel
                            property: "opacity"
                            duration: 150
                        }
                        NumberAnimation {
                            target: desktopIndicator
                            property: "opacity"
                            duration: 150
                        }
                    }
                }
            ]
        }
    }

    Component {
        id: addDesktopButton

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
            }

            state: {
                return mouseArea.containsMouse ? "hovered" : "default"
            }

            states: [
                State {
                    name: "default"
                    PropertyChanges {
                        target: label
                        opacity: 0.7
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

        addDesktopButton.createObject(root);
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
