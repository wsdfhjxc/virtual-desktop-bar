import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Component {
    Item {
        id: self

        property int desktopLabelMargin: 6
        property int desktopIndicatorThickness: 3

        property string desktopName: "Desktop"
        property bool isCurrentDesktop: false

        implicitWidth: desktopEntryRect.width > 0 ?
                       desktopEntryRect.width + desktopEntrySpacing : 0
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

        Timer {
            id: removeTimer1
            interval: 0
            onTriggered: {
                opacity = 0;
            }
        }

        Timer {
            interval: 0
            running: true
            onTriggered: {
                desktopEntryRect.width = Qt.binding(function() {
                    return desktopLabel.implicitWidth + 2 * desktopLabelMargin;
                });
            }
        }

        Timer {
            id: removeTimer2
            interval: 150
            onTriggered: {
                desktopEntryRect.width = 0
            }
        }

        Rectangle {
            id: desktopEntryRect
            width: 0
            height: parent.height
            color: "transparent"

            Behavior on width {
                NumberAnimation {
                    duration: 75
                }
            }

            Label {
                id: desktopLabel
                text: desktopName
                x: desktopLabelMargin
                width: desktopLabel.implicitWidth
                anchors.verticalCenter: parent.verticalCenter
                clip: true

                Behavior on width {
                    NumberAnimation {
                        duration: 75
                    }
                }
            }

            Rectangle {
                id: desktopIndicator
                width: parent.width
                height: desktopIndicatorThickness
                anchors.bottom: parent.bottom
                color: theme.buttonFocusColor
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent

                onClicked: {
                    var desktopNumber = getDesktopNumberForDesktopEntry(self);
                    mdsModel.switchToDesktop(desktopNumber)
                }
            }

            state: {
                if (isCurrentDesktop) {
                    return "current"
                }
                if (mouseArea.containsMouse) {
                    return "hovered"
                }
                return "default"
            }

            states: [
                State {
                    name: "default"
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
                    name: "current"
                    PropertyChanges {
                        target: desktopLabel
                        opacity: 1
                    }
                    PropertyChanges {
                        target: desktopIndicator
                        opacity: 0.7
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
                    to: "default"
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
                    to: "current"
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
                },

                Transition {
                    to: "hovered"
                    ParallelAnimation {
                        NumberAnimation {
                            target: desktopLabel
                            property: "opacity"
                            duration: 150
                        }
                    }
                }
            ]
        }

        function remove() {
            removeTimer1.start();
            removeTimer2.start();
            destroy(500);
        }
    }
}
