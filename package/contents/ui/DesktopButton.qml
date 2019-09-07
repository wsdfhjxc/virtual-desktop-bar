import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore

Component {
    Item {
        id: desktopButton

        property int desktopButtonSpacing: {
            if (plasmoid.configuration.buttonSpacing < 0) {
                return 0;
            } else if (plasmoid.configuration.buttonSpacing == 0) {
                return 4;
            } else if (plasmoid.configuration.buttonSpacing == 1) {
                return 8;
            }
            return 12;
        }
        property int desktopLabelMargin: {
            if (plasmoid.configuration.buttonWidth == 0) {
                return 3;
            } else if (plasmoid.configuration.buttonWidth == 1) {
                return 6;
            }
            return 9;
        }
        property int desktopIndicatorThickness: 3

        property string desktopName: "Desktop"
        property bool isCurrentDesktop: false
        property bool isEmptyDesktop: true

        implicitWidth: desktopButtonRect.width > 0 ?
                       desktopButtonRect.width + desktopButtonSpacing : 0
        implicitHeight: parent.height

        Component.onCompleted: {
            if (plasmoid.configuration.enableAnimations) {
                delay(75, function() {
                    desktopButtonRect.opacity = 1;
                });
            };
            desktopButtonRect.width = Qt.binding(function() {
                return desktopLabel.implicitWidth + 2 * desktopLabelMargin;
            });
        }

        Rectangle {
            id: desktopButtonRect
            width: 0
            height: parent.height
            color: "transparent"
            opacity: plasmoid.configuration.enableAnimations ? 0 : 1

            Behavior on opacity {
                enabled: plasmoid.configuration.enableAnimations
                animation: NumberAnimation {
                    duration: 150
                }
            }

            Behavior on width {
                enabled: plasmoid.configuration.enableAnimations
                animation: NumberAnimation {
                    duration: 75
                }
            }

            Rectangle {
                id: desktopIndicator
                width: {
                    if (plasmoid.configuration.indicatorStyle == 1) {
                        return desktopIndicatorThickness;
                    }
                    return parent.width + 0.5;
                }
                height: {
                    if (plasmoid.configuration.indicatorStyle == 4) {
                        return parent.height;
                    } else if (plasmoid.configuration.indicatorStyle == 1) {
                        return parent.height - 16;
                    } else if (plasmoid.configuration.indicatorStyle > 1) {
                        return parent.height - 10;
                    }
                    return desktopIndicatorThickness;
                }
                x: {
                    if (plasmoid.configuration.indicatorStyle == 1 &&
                        plasmoid.configuration.invertIndicator) {
                        return parent.width - width;
                    }
                    return 0;
                }
                y: {
                    if (plasmoid.configuration.indicatorStyle > 0) {
                        return (parent.height - height) / 2;
                    }
                    if (plasmoid.location == PlasmaCore.Types.TopEdge) {
                        return !plasmoid.configuration.invertIndicator ? parent.height - height : 0;
                    }
                    return !plasmoid.configuration.invertIndicator ? 0 : parent.height - height;
                }
                radius: {
                    if (plasmoid.configuration.indicatorStyle == 2) {
                        return 2;
                    } else if (plasmoid.configuration.indicatorStyle == 3) {
                        return 300;
                    }
                    return 0;
                }
            }

            Label {
                id: desktopLabel
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                text: desktopName
                color: plasmoid.configuration.labelColor || theme.textColor
                font.family: plasmoid.configuration.labelFont || theme.defaultFont.family
                font.pixelSize: plasmoid.configuration.labelSize || theme.defaultFont.pixelSize

                Behavior on width {
                    enabled: plasmoid.configuration.enableAnimations
                    animation: NumberAnimation {
                        duration: 75
                    }
                }
            }

            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent

                onClicked: {
                    var desktopNumber = getDesktopNumberForDesktopButton(desktopButton);
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
                        opacity: plasmoid.configuration.dimLabelForIdle ? 0.8 : 1
                    }
                    PropertyChanges {
                        target: desktopIndicator
                        color: {
                            if (!isEmptyDesktop && plasmoid.configuration.occupiedIndicatorColor) {
                                return plasmoid.configuration.occupiedIndicatorColor;
                            }
                            return plasmoid.configuration.idleIndicatorColor ||
                                   plasmoid.configuration.labelColor || theme.textColor;
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
                        opacity: plasmoid.configuration.dimLabelForIdle ? 0.9 : 1
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
                    return getDesktopNumberForDesktopButton(desktopButton, true);
                } else if (plasmoid.configuration.labelStyle == 1) {
                    return getDesktopNumberForDesktopButton(desktopButton, true) + ": " + desktopName;
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
                desktopButtonRect.opacity = 0;
                delay(150, function() {
                    desktopButtonRect.width = 0;
                });
                destroy(225);
            } else {
                destroy(10);
            }
        }
    }
}
