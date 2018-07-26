import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.mds 2.0

RowLayout {
    id: root
    spacing: 12
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property var desktopEntries: []

    MDSModel {
        id: mdsModel
    }

    RowLayout {
        id: desktopEntriesLayout
        spacing: root.spacing
        implicitHeight: parent.height
        anchors.verticalCenter: parent.verticalCenter
    }

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
                mdsModel.addDesktop();
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

    Component {
        id: desktopEntryComponent

        Item {
            property int desktopLabelMargin: 2
            property int desktopIndicatorThickness: 2

            property int desktopNumber: 1
            property string desktopName: "Desktop"
            property bool activeDesktop: false

            implicitWidth: desktopLabel.width + 2 * desktopLabelMargin
            implicitHeight: parent.height
            opacity: 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }

            Timer {
                interval: 75
                running: true
                onTriggered: {
                    opacity = 1
                }
            }

            Label {
                id: desktopLabel
                text: desktopName
                x: desktopLabelMargin
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                width: 0

                Behavior on width {
                    NumberAnimation {
                        duration: 75
                    }
                }
            }

            Timer {
                interval: 0
                running: true
                onTriggered: {
                    desktopLabel.width = desktopLabel.implicitWidth
                }
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

    Component.onCompleted: {
        var desktopNames = mdsModel.getDesktopNames();
        var activeDesktopNumber = mdsModel.getActiveDesktopNumber();

        for (var i = 0; i < desktopNames.length; i++) {
            var desktopNumber = i + 1;
            var desktopName = desktopNames[i];
            var activeDesktop = activeDesktopNumber == desktopNumber;

            desktopEntries.push(desktopEntryComponent.createObject(desktopEntriesLayout, {
                "desktopNumber": desktopNumber,
                "desktopName": desktopName,
                "activeDesktop": activeDesktop
            }));
        }
    }

    Connections {
        target: mdsModel

        onDesktopChanged: {
            for (var i = 0; i < desktopEntries.length; i++) {
                var desktopEntry = desktopEntries[i];
                desktopEntry.activeDesktop = desktopNumber == i + 1;
            }
        }

        onDesktopAmountChanged: {
            var currentDesktopAmount = desktopEntries.length;
            var desktopAmountDifference = desktopAmount - currentDesktopAmount;
            if (desktopAmountDifference > 0) {
                var desktopNames = mdsModel.getDesktopNames();
                for (var i = 1; i <= desktopAmountDifference; i++) {
                    var desktopNumber = currentDesktopAmount + i;
                    var desktopName = desktopNames[desktopNumber - 1];

                    desktopEntries.push(desktopEntryComponent.createObject(desktopEntriesLayout, {
                        "desktopNumber": desktopNumber,
                        "desktopName": desktopName
                    }));
                }
            } else {
                for (var i = currentDesktopAmount - 1; i >= desktopAmount; i--) {
                    var desktopEntry = desktopEntries[i];
                    desktopEntry.destroy();
                    desktopEntries.splice(i, 1);
                }
            }
        }

        onDesktopNamesChanged: {
            var desktopNames = mdsModel.getDesktopNames();
            for (var i = 0; i < desktopNames.length; i++) {
                var desktopName = desktopNames[i];
                var desktopEntry = desktopEntries[i];
                if (desktopEntry.desktopName != desktopName) {
                    desktopEntry.desktopName = desktopName;
                }
            }
        }
    }
}
