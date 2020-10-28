import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "../common/Utils.js" as Utils

GridLayout {
    rowSpacing: 0
    columnSpacing: 0
    flow: isVerticalOrientation ?
          GridLayout.TopToBottom :
          GridLayout.LeftToRight

    property var desktopButtonList: []

    property Item lastHoveredButton
    property Item lastDesktopButton
    property Item currentDesktopButton
    property Item largestDesktopButton

    DesktopButton { id: desktopButtonComponent }

    GridLayout {
        id: desktopButtonContainer
        rowSpacing: parent.rowSpacing
        columnSpacing: parent.columnSpacing
        flow: parent.flow
    }

    AddDesktopButton {}

    readonly property int pressToDragDuration: 300

    property bool isDragging: false
    property Item draggedDesktopButton

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true

        readonly property int wheelDeltaLimit: 120

        property int currentWheelDelta: 0

        onClicked: {
            mouse.accepted = isDragging;
        }

        onPressed: {
            var initialDesktopButton = desktopButtonContainer.childAt(mouse.x, mouse.y);
            if (!initialDesktopButton) {
                return;
            }

            Utils.delay(pressToDragDuration, function() {
                if (!pressed) {
                    return;
                }

                var desktopButton = desktopButtonContainer.childAt(mouse.x, mouse.y);
                if (desktopButton && desktopButton == initialDesktopButton) {
                    isDragging = true;
                    draggedDesktopButton = desktopButton;
                }
            });
        }

        onPositionChanged: {
            if (isDragging) {
                var desktopButton = desktopButtonContainer.childAt(mouse.x, mouse.y);

                if (desktopButton) {
                    if (desktopButton != draggedDesktopButton) {

                        var maxOffset = desktopButton.width * 0.3;
                        var centerPos = desktopButton.x + desktopButton.width / 2;
                        if (!((mouse.x >= centerPos - maxOffset && mouse.x <= centerPos) ||
                              (mouse.x <= centerPos + maxOffset && mouse.x >= centerPos))) {
                            return;
                        }

                        backend.replaceDesktops(draggedDesktopButton.number, desktopButton.number);
                        draggedDesktopButton = desktopButton;
                    }
                }
            }
        }

        onReleased: {
            if (isDragging) {
                draggedDesktopButton = null;

                Qt.callLater(function() {
                    isDragging = false;
                });
            }
        }

        onWheel: {
            if (!config.MouseWheelSwitchDesktopOnScroll) {
                return;
            }

            var desktopNumber = 0;

            var change = wheel.angleDelta.y || wheel.angleDelta.x;
            if (!config.MouseWheelInvertDesktopSwitchingDirection) {
                change = -change;
            }

            currentWheelDelta += change;

            if (currentWheelDelta >= wheelDeltaLimit) {
                currentWheelDelta = 0;

                if (currentDesktopButton && currentDesktopButton.number < desktopButtonList.length) {
                    desktopNumber = currentDesktopButton.number + 1;
                } else if (config.MouseWheelWrapDesktopNavigationWhenScrolling) {
                    desktopNumber = 1;
                }
            }

            if (currentWheelDelta <= -wheelDeltaLimit) {
                currentWheelDelta = 0;

                if (currentDesktopButton && currentDesktopButton.number > 1) {
                    desktopNumber = currentDesktopButton.number - 1;
                } else if (config.MouseWheelWrapDesktopNavigationWhenScrolling) {
                    desktopNumber = desktopButtonList.length;
                }
            }

            if (desktopNumber > 0) {
                if (config.TooltipsEnable) {
                    tooltip.visible = false;
                }

                backend.showDesktop(desktopNumber);
            }
        }
    }

    function update(desktopInfoList) {
        var difference = desktopInfoList.length - desktopButtonList.length;
        var synchronousUpdate = true;

        if (difference > 0) {
            addDesktopButtons(difference);
        } else if (difference < 0) {
            removeDesktopButtons(desktopInfoList);
            synchronousUpdate = !config.AnimationsEnable;
        }

        if (synchronousUpdate) {
            updateDesktopButtons(desktopInfoList);
        }

        lastDesktopButton = desktopButtonList[desktopButtonList.length - 1];
    }

    function addDesktopButtons(difference) {
        var init = desktopButtonList.length == 0;
        var temp = difference;

        while (temp-- > 0) {
            var desktopButton = desktopButtonComponent.createObject(desktopButtonContainer);
            desktopButtonList.push(desktopButton);
        }

        if (!init && difference != 0 &&
            !config.DynamicDesktopsEnable) {
            if (config.AddingDesktopsSwitchTo) {
                Utils.delay(100, function() {
                    backend.showDesktop(desktopButtonList.length);
                });
            }
            if (config.AddingDesktopsPromptToRename) {
                Utils.delay(100, function() {
                    renamePopup.show(desktopButtonList[desktopButtonList.length - 1]);
                });
            }
        }
    }

    function removeDesktopButtons(desktopInfoList) {
        var list = getRemovedDesktopButtonIndexList(desktopInfoList);

        while (list.length > 0) {
            var index = list.pop();
            var desktopButton = desktopButtonList[index];
            desktopButtonList.splice(index, 1);

            if (lastHoveredButton == desktopButton) {
                lastHoveredButton = null;
            }

            if (currentDesktopButton == desktopButton) {
                currentDesktopButton = null;
            }

            if (largestDesktopButton == desktopButton) {
                largestDesktopButton = null;
            }

            if (config.AnimationsEnable) {
                desktopButton.hide(function() {
                    desktopButton.destroy();

                    if (list.length == 0) {
                        updateDesktopButtons(desktopInfoList);
                    }
                });
                continue;
            }

            desktopButton.destroy();
        }
    }

    function getRemovedDesktopButtonIndexList(desktopInfoList) {
        var removedDesktopButtonIndexList = [];

        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];

            var keepDesktopButton = false;
            for (var j = 0; j < desktopInfoList.length; j++) {
                var desktopInfo = desktopInfoList[j];
                if (desktopButton.number == desktopInfo.number) {
                    keepDesktopButton = true;
                    break;
                }
            }
            if (!keepDesktopButton) {
                removedDesktopButtonIndexList.push(i);
            }
        }

        return removedDesktopButtonIndexList;
    }

    function updateDesktopButtons(desktopInfoList) {
        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];
            var desktopInfo = desktopInfoList[i];
            desktopButton.update(desktopInfo);
            desktopButton.show();

            if (desktopButton.isCurrent) {
                currentDesktopButton = desktopButton;
            }
        }
    }

    function updateLargestDesktopButton() {
        var temp = largestDesktopButton;

        for (var i = 0; i < desktopButtonList.length; i++) {
            var desktopButton = desktopButtonList[i];

            if (!temp || temp.implicitWidth < desktopButton.implicitWidth) {
                temp = desktopButton;
            }
        }

        if (temp != largestDesktopButton) {
            largestDesktopButton = temp;
        }
    }
}
