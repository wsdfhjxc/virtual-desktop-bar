import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore

Component {
    Item {
        id: self

        property int desktopLabelMargin: 6
        property int desktopIndicatorThickness: 3

        property string desktopName: "Desktop"
        property bool isCurrentDesktop: false
        property bool isEmptyDesktop: true

        implicitWidth: desktopEntryRect.width > 0 ?
                       desktopEntryRect.width + desktopEntrySpacing : 0
        implicitHeight: parent.height
        opacity: plasmoid.configuration.enableAnimations ? 0 : 1

        Behavior on opacity {
            enabled: plasmoid.configuration.enableAnimations
            animation: NumberAnimation {
                duration: 150
            }
        }

        Timer {
            id: initTimer1
            interval: 75
            running: plasmoid.configuration.enableAnimations
            onTriggered: {
                opacity = 1
            }
        }

        Timer {
            id: initTimer2
            interval: 0
            running: true
            onTriggered: {
                desktopEntryRect.width = Qt.binding(function() {
                    return desktopLabel.implicitWidth + 2 * desktopLabelMargin;
                });
            }
        }

        Timer {
            id: removeTimer
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
                enabled: plasmoid.configuration.enableAnimations
                animation: NumberAnimation {
                    duration: 75
                }
            }

            Label {
                id: desktopLabel
                text: desktopName
                x: desktopLabelMargin
                width: desktopLabel.implicitWidth
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: plasmoid.configuration.labelSize || theme.defaultFont.pixelSize
                clip: true
                color: plasmoid.configuration.labelColor || theme.textColor
                font.family: plasmoid.configuration.labelFont || theme.defaultFont.family

                Behavior on width {
                    enabled: plasmoid.configuration.enableAnimations
                    animation: NumberAnimation {
                        duration: 75
                    }
                }
            }

            Rectangle {
                id: desktopIndicator
                width: parent.width
                height: desktopIndicatorThickness
                y: {
                    if (plasmoid.location == PlasmaCore.Types.TopEdge) {
                        return !plasmoid.configuration.invertIndicator ? parent.height - height : 0;
                    }
                    return !plasmoid.configuration.invertIndicator ? 0 : parent.height - height;
                }
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent

                onClicked: {
                    var desktopNumber = getDesktopNumberForDesktopEntry(self);
                    virtualDesktopBar.switchToDesktop(desktopNumber)
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
                        opacity: 0.8
                    }
                    PropertyChanges {
                        target: desktopIndicator
                        color: {
                            if (!isEmptyDesktop && plasmoid.configuration.occupiedIndicatorColor) {
                                return plasmoid.configuration.occupiedIndicatorColor;
                            }
                            return plasmoid.configuration.labelColor || theme.textColor;
                        }
                        opacity: !isEmptyDesktop && plasmoid.configuration.distinctIndicatorOccupied ? 0.35 : 0.15
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
                        color: plasmoid.configuration.indicatorColor || theme.buttonFocusColor
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
                        color: plasmoid.configuration.indicatorColor || theme.buttonFocusColor
                        opacity: 0.5
                    }
                }
            ]

            transitions: [
                Transition {
                    enabled: plasmoid.configuration.enableAnimations
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
                        ColorAnimation {
                            target: desktopIndicator
                            property: "color"
                            duration: 300
                        }
                    }
                },

                Transition {
                    enabled: plasmoid.configuration.enableAnimations
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
                        ColorAnimation {
                            target: desktopIndicator
                            property: "color"
                            duration: 150
                        }
                    }
                },

                Transition {
                    enabled: plasmoid.configuration.enableAnimations
                    to: "hovered"
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
                        ColorAnimation {
                            target: desktopIndicator
                            property: "color"
                            duration: 150
                        }
                    }
                }
            ]
        }

        function setDesktopName(desktopName) {
            this.desktopName = desktopName;
            desktopLabel.text = Qt.binding(function() {
                if (plasmoid.configuration.labelStyle == 0) {
                    return getDesktopNumberForDesktopEntry(self, true);
                } else if (plasmoid.configuration.labelStyle == 1) {
                    return getDesktopNumberForDesktopEntry(self, true) + ": " + desktopName;
                }
                return desktopName;
            });
        }

        function setIsCurrentDesktop(isCurrentDesktop) {
            this.isCurrentDesktop = isCurrentDesktop;
        }

        function setIsEmptyDesktop(isEmptyDesktop) {
            this.isEmptyDesktop = isEmptyDesktop;
        }

        function remove() {
            if (plasmoid.configuration.enableAnimations) {
                initTimer1.stop();
                initTimer2.stop();
                opacity = 0;
                removeTimer.start();
                destroy(500);
            } else {
                destroy(10);
            }
        }
    }
}
