import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common/Utils.js" as Utils

Component {
    Rectangle {
        readonly property string objectType: "DesktopButton"

        property int number: 0
        property string id: ""
        property string name: ""
        property bool isCurrent: false
        property bool isEmpty: false
        property bool isUrgent: false
        property string activeWindowName: ""
        property var windowNameList: []

        property bool isDragged: container.draggedDesktopButton == this
        property bool ignoreMouseArea: container.isDragging

        property bool isVisible: {
            if (config.DesktopButtonsShowOnlyForCurrentDesktop &&
                config.DesktopButtonsShowOnlyForOccupiedDesktops) {
                return isCurrent || !isEmpty;
            }
            if (config.DesktopButtonsShowOnlyForCurrentDesktop) {
                return isCurrent;
            }
            if (config.DesktopButtonsShowOnlyForOccupiedDesktops) {
                return !isEmpty;
            }
            return true;
        }

        onIsVisibleChanged: {
            if (isVisible) {
                show();
            } else {
                hide();
            }
        }

        property alias _label: label
        property alias _indicator: indicator

        Layout.fillWidth: isVerticalOrientation
        Layout.fillHeight: !isVerticalOrientation

        clip: true
        color: "transparent"
        opacity: !config.AnimationsEnable ? 1 : 0

        readonly property int tooltipWaitDuration: 800
        readonly property int animationWidthDuration: 100
        readonly property int animationColorDuration: 150
        readonly property int animationOpacityDuration: 150

        Behavior on opacity {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationOpacityDuration
            }
        }

        Behavior on implicitWidth {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationWidthDuration
                onRunningChanged: {
                    if (!running) {
                        Utils.delay(100, container.updateLargestDesktopButton);
                    }
                }
            }
        }

        Behavior on implicitHeight {
            enabled: config.AnimationsEnable
            animation: NumberAnimation {
                duration: animationWidthDuration
            }
        }

        /* Indicator */
        Rectangle {
            id: indicator

            readonly property int lineWidth: 3

            visible: config.DesktopIndicatorsStyle != 5

            color: {
                if (isCurrent) {
                    return config.DesktopIndicatorsCustomColorForCurrentDesktop || theme.buttonFocusColor;
                }
                if (isEmpty && config.DesktopIndicatorsCustomColorForIdleDesktops) {
                    return config.DesktopIndicatorsCustomColorForIdleDesktops;
                }
                if (!isEmpty && config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops) {
                    return config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops;
                }
                if (isUrgent && config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention) {
                    return config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention;
                }
                return theme.textColor;
            }

            Behavior on color {
                enabled: config.AnimationsEnable
                animation: ColorAnimation {
                    duration: animationColorDuration
                }
            }

            opacity: {
                if (isCurrent) {
                    return 1.0;
                }
                if ((!ignoreMouseArea && mouseArea.containsMouse) || isDragged) {
                    return config.DesktopIndicatorsStyle == 5 ? 1.0 : 0.75;
                }
                if (config.DesktopIndicatorsDoNotOverrideOpacityOfCustomColors) {
                    if ((isCurrent && config.DesktopIndicatorsCustomColorForCurrentDesktop) ||
                        (isEmpty && config.DesktopIndicatorsCustomColorForIdleDesktops) ||
                        (!isEmpty && config.DesktopIndicatorsCustomColorForOccupiedIdleDesktops) ||
                        (isUrgent && config.DesktopIndicatorsCustomColorForDesktopsNeedingAttention)) {
                        return 1.0;
                    }
                }
                if (!isEmpty && config.DesktopIndicatorsDistinctForOccupiedIdleDesktops) {
                    return config.DesktopIndicatorsStyle == 5 ? 1.0 : 0.5;
                }
                return config.DesktopIndicatorsStyle == 5 ? 0.5 : 0.25;
            }

            Behavior on opacity {
                enabled: config.AnimationsEnable
                animation: NumberAnimation {
                    duration: animationOpacityDuration
                }
            }

            width: {
                if (isVerticalOrientation) {
                    if (config.DesktopIndicatorsStyle == 1) {
                        return lineWidth;
                    }
                    if (config.DesktopIndicatorsStyle == 4) {
                        return parent.width;
                    }
                    if (config.DesktopButtonsSetCommonSizeForAll &&
                        container.largestDesktopButton &&
                        container.largestDesktopButton != parent &&
                        container.largestDesktopButton._label.implicitWidth > label.implicitWidth) {
                        return container.largestDesktopButton._indicator.width;
                    }
                    return label.implicitWidth + 2 * config.DesktopButtonsHorizontalMargin;
                }
                if (config.DesktopIndicatorsStyle == 1) {
                    return lineWidth;
                }
                return parent.width + 0.5 - 2 * config.DesktopButtonsSpacing;
            }

            height: {
                if (config.DesktopIndicatorsStyle == 4) {
                    if (isVerticalOrientation) {
                        return parent.height + 0.5 - 2 * config.DesktopButtonsSpacing;
                    }
                    return parent.height;
                }
                if (config.DesktopIndicatorsStyle > 0) {
                    return label.implicitHeight + 2 * config.DesktopButtonsVerticalMargin;
                }
                return lineWidth;
            }

            x: {
                if (isVerticalOrientation) {
                    if (config.DesktopIndicatorsStyle != 1) {
                        return (parent.width - width) / 2;
                    }
                    return config.DesktopIndicatorsInvertPosition ?
                           parent.width - lineWidth : 0;
                }
                if (config.DesktopIndicatorsStyle == 1 &&
                    config.DesktopIndicatorsInvertPosition) {
                    return parent.width - width - (config.DesktopButtonsSpacing || 0);
                }
                return config.DesktopButtonsSpacing || 0;
            }

            y: {
                if (config.DesktopIndicatorsStyle > 0) {
                    return (parent.height - height) / 2;
                }
                if (isTopLocation) {
                    return !config.DesktopIndicatorsInvertPosition ? parent.height - height : 0;
                }
                return !config.DesktopIndicatorsInvertPosition ? 0 : parent.height - height;
            }

            radius: {
                if (config.DesktopIndicatorsStyle == 2) {
                    return config.DesktopIndicatorsStyleBlockRadius;
                }
                if (config.DesktopIndicatorsStyle == 3) {
                    return 300;
                }
                return 0;
            }
        }

        /* Label */
        Text {
            id: label

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: name

            color: config.DesktopIndicatorsStyle == 5 ?
                   indicator.color :
                   config.DesktopLabelsCustomColor || theme.textColor

            Behavior on color {
                enabled: config.AnimationsEnable
                animation: ColorAnimation {
                    duration: animationColorDuration
                }
            }

            opacity: {
                if (config.DesktopIndicatorsStyle == 5) {
                    return indicator.opacity;
                }
                if (isCurrent) {
                    return 1.0;
                }
                if (config.DesktopLabelsDimForIdleDesktops) {
                    if ((!ignoreMouseArea && mouseArea.containsMouse) || isDragged) {
                        return 1.0;
                    }
                    return 0.75;
                }
                return 1.0;
            }

            Behavior on opacity {
                enabled: config.AnimationsEnable
                animation: NumberAnimation {
                    duration: animationOpacityDuration
                }
            }

            font.family: config.DesktopLabelsCustomFont || theme.defaultFont.family
            font.pixelSize: config.DesktopLabelsCustomFontSize || theme.defaultFont.pixelSize
            font.bold: isCurrent && config.DesktopLabelsBoldFontForCurrentDesktop
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            property var tooltipTimer

            function killTooltipTimer() {
                if (tooltipTimer) {
                    tooltipTimer.stop();
                    tooltipTimer = null;
                }
            }

            onEntered: {
                container.lastHoveredButton = parent;

                if (!config.TooltipsEnable) {
                    return;
                }

                tooltipTimer = Utils.delay(tooltipWaitDuration, function() {
                    if (containsMouse && !isDragged) {
                        tooltip.show(parent);
                    }
                });
            }

            onExited: {
                if (config.TooltipsEnable) {
                    killTooltipTimer();
                    tooltip.visible = false;
                }
            }

            onClicked: {
                if (config.TooltipsEnable) {
                    killTooltipTimer();
                    tooltip.visible = false;
                }

                if (mouse.button == Qt.LeftButton) {
                    backend.showDesktop(number);
                } else if (mouse.button == Qt.MiddleButton) {
                    if (!config.DynamicDesktopsEnable &&
                        config.MouseWheelRemoveDesktopOnClick) {
                        backend.removeDesktop(number);
                    }
                }
            }
        }

        function updateLabel() {
            label.text = Qt.binding(function() {
                var labelText = name;

                if (config.DesktopLabelsStyle == 1) {
                    labelText = number;
                } else if (config.DesktopLabelsStyle == 2) {
                    labelText = number + ": " + name;
                } else if (config.DesktopLabelsStyle == 3) {
                    labelText = activeWindowName || name;
                } else if (config.DesktopLabelsStyle == 4) {
                    if (config.DesktopLabelsStyleCustomFormat) {
                        var format = config.DesktopLabelsStyleCustomFormat.trim();
                        if (format.length > 0) {
                            labelText = format;
                            labelText = labelText.replace("$WX", !isEmpty ? activeWindowName : number);
                            labelText = labelText.replace("$WR", !isEmpty ? activeWindowName : Utils.arabicToRoman(number));
                            labelText = labelText.replace("$WN", !isEmpty ? activeWindowName : name);
                            labelText = labelText.replace("$X", number);
                            labelText = labelText.replace("$R", Utils.arabicToRoman(number));
                            labelText = labelText.replace("$N", name);
                            labelText = labelText.replace("$W", activeWindowName);
                        } else {
                            labelText = number + ": " + name;
                        }
                    }
                }

                if (labelText.length > config.DesktopLabelsMaximumLength) {
                    labelText = labelText.substr(0, config.DesktopLabelsMaximumLength - 1) + "…";
                }
                if (config.DesktopLabelsDisplayAsUppercased) {
                    labelText = labelText.toUpperCase();
                }

                return labelText;
            });
        }

        function update(desktopInfo) {
            number = desktopInfo.number;
            id = desktopInfo.id;
            name = desktopInfo.name;
            isCurrent = desktopInfo.isCurrent;
            isEmpty = desktopInfo.isEmpty;
            isUrgent = desktopInfo.isUrgent;
            activeWindowName = desktopInfo.activeWindowName
            windowNameList = desktopInfo.windowNameList;

            updateLabel();
        }

        function show() {
            if (!isVisible) {
                return;
            }

            visible = true;
            var self = this;

            implicitWidth = Qt.binding(function() {
                if (isVerticalOrientation) {
                    return parent.width;
                }

                var newImplicitWidth = label.implicitWidth +
                                       2 * config.DesktopButtonsHorizontalMargin +
                                       2 * config.DesktopButtonsSpacing;

                if (config.DesktopButtonsSetCommonSizeForAll &&
                    container.largestDesktopButton &&
                    container.largestDesktopButton != self &&
                    container.largestDesktopButton.implicitWidth > newImplicitWidth) {
                    return container.largestDesktopButton.implicitWidth;
                }

                return newImplicitWidth;
            });

            implicitHeight = Qt.binding(function() {
                if (!isVerticalOrientation) {
                    return parent.height;
                }
                return label.implicitHeight +
                       2 * config.DesktopButtonsVerticalMargin +
                       2 * config.DesktopButtonsSpacing;
            });

            if (config.AnimationsEnable) {
                Utils.delay(animationWidthDuration, function() {
                    opacity = 1;
                });
            } else {
                opacity = 1;
            }
        }

        function hide(callback, force) {
            if (!force && isVisible) {
                return;
            }

            opacity = 0;

            var resetDimensions = function() {
                implicitWidth = isVerticalOrientation ? parent.width : 0;
                implicitHeight = isVerticalOrientation ? 0: parent.height;
            }

            var self = this;
            var postHideCallback = callback ? callback : function() {
                self.visible = false;
            };

            if (config.AnimationsEnable) {
                Utils.delay(animationOpacityDuration, function() {
                    resetDimensions();
                    Utils.delay(animationWidthDuration, postHideCallback);
                });
            } else {
                resetDimensions();
                postHideCallback();
            }
        }

        onImplicitWidthChanged: {
            if (!config.AnimationsEnable) {
                Utils.delay(100, container.updateLargestDesktopButton);
            }
        }
    }
}
