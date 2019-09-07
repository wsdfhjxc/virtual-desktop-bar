import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Component {
    RowLayout {
        id: desktopSwitcher
        spacing: 0
        implicitHeight: parent.height

        property int desktopAmount: 0
        property int currentDesktopNumber;
        property var desktopButtons: []

        DesktopButton {
            id: desktopButtonComponent
        }

        RowLayout {
            id: desktopButtonsLayout
            spacing: parent.spacing
            implicitHeight: parent.height
            anchors.fill: parent
        }

        Item {
            implicitWidth: plasmoid.configuration.buttonSpacing < 0 &&
                           plasmoid.configuration.showPlusButton ? 4 : 0
        }

        PlusButton {}

        Component.onCompleted: {
            var desktopNames = virtualDesktopBar.getDesktopNames();
            currentDesktopNumber = virtualDesktopBar.getCurrentDesktopNumber();

            for (var i = 0; i < desktopNames.length; i++) {
                var desktopNumber = i + 1;
                var desktopName = desktopNames[i];
                var isCurrentDesktop = currentDesktopNumber == desktopNumber;
                registerDesktopButton(desktopName, isCurrentDesktop);
            }

            desktopAmount = desktopNames.length;

            var emptyDesktops = virtualDesktopBar.getEmptyDesktops();
            onEmptyDesktopsUpdated(emptyDesktops);
        }

        function onCurrentDesktopChanged(desktopNumber) {
            for (var i = 0; i < desktopButtons.length; i++) {
                var desktopButton = desktopButtons[i];
                var isCurrentDesktop = desktopNumber == i + 1;
                desktopButton.setIsCurrentDesktop(isCurrentDesktop);
                if (isCurrentDesktop) {
                    currentDesktopNumber = i + 1;
                }
            }
        }

        function onDesktopAmountChanged(desktopAmount) {
            var currentDesktopAmount = desktopButtons.length;
            var desktopAmountDifference = desktopAmount - currentDesktopAmount;
            if (desktopAmountDifference > 0) {
                addDesktops(desktopAmountDifference);
            } else if (desktopAmountDifference < 0) {
                removeDesktops(-desktopAmountDifference);
            }
            desktopSwitcher.desktopAmount = desktopButtons.length;
        }

        function onDesktopNamesChanged() {
            var desktopNames = virtualDesktopBar.getDesktopNames();
            for (var i = 0; i < desktopButtons.length; i++) {
                var desktopName = desktopNames[i];
                var desktopButton = desktopButtons[i];
                desktopButton.setDesktopName(desktopName);
            }
        }

        function onEmptyDesktopsUpdated(desktopNumbers) {
            for (var i = 0; i < desktopButtons.length; i++) {
                var desktopButton = desktopButtons[i];
                desktopButton.setIsEmptyDesktop(false);

                for (var j = 0; j < desktopNumbers.length; j++) {
                    var emptyDesktopNumber = desktopNumbers[j];
                    if (i + 1 == emptyDesktopNumber) {
                        desktopButton.setIsEmptyDesktop(true);
                        break;
                    }
                }
            }
        }

        function registerDesktopButton(desktopName, isCurrentDesktop) {
            var desktopButton = desktopButtonComponent.createObject(desktopButtonsLayout);
            desktopButton.setDesktopName(desktopName);
            desktopButton.setIsCurrentDesktop(!!isCurrentDesktop);
            desktopButtons.push(desktopButton);
        }

        function addDesktops(desktopAmountDifference) {
            var desktopNames = virtualDesktopBar.getDesktopNames();
            var desktopNumber = 1;
            for (var i = 1; i <= desktopAmountDifference; i++) {
                desktopNumber = desktopButtons.length + i;
                var desktopName = desktopNames[desktopNumber - 1];
                registerDesktopButton(desktopName);
            }
            if (plasmoid.configuration.switchToNewDesktop) {
                if (plasmoid.configuration.keepOneEmptyDesktop &&
                    virtualDesktopBar.getEmptyDesktops().length == 1) {
                    return;
                }

                virtualDesktopBar.switchToDesktop(desktopNumber);
                if (plasmoid.configuration.renameNewDesktop) {
                    delay(100, function() {
                        action_renameCurrentDesktop();
                    });
                }
            }
        }

        function removeDesktops(desktopAmountDifference) {
            var newDesktopAmount = desktopButtons.length - desktopAmountDifference;
            for (var i = desktopButtons.length - 1; i >= newDesktopAmount; i--) {
                var desktopButton = desktopButtons[i];
                desktopButton.remove();
                desktopButtons.splice(i, 1);
            }
        }

        function getDesktopNumberForDesktopButton(desktopButton, nextNumber) {
            for (var i = 0; i < desktopButtons.length; i++) {
                if (desktopButtons[i] == desktopButton) {
                    return i + 1;
                }
            }
            return nextNumber ? desktopButtons.length + 1 : -1;
        }

        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            property int wheelDelta: 0
            property int wheelDeltaLimit: 120

            onWheel: {
                if (!plasmoid.configuration.switchWithWheel) {
                    return;
                }

                var change = wheel.angleDelta.y || wheel.angleDelta.x;
                if (plasmoid.configuration.invertWheelSwitch) {
                    change = -change;
                }

                wheelDelta += change;

                while (wheelDelta >= wheelDeltaLimit) {
                    wheelDelta -= wheelDeltaLimit;
                    var nextDesktopNumber = currentDesktopNumber + 1;
                    if (nextDesktopNumber <= desktopAmount) {
                        virtualDesktopBar.switchToDesktop(nextDesktopNumber);
                    } else if (plasmoid.configuration.wheelSwitchWrap) {
                        virtualDesktopBar.switchToDesktop(1);
                    }
                }

                while (wheelDelta <= -wheelDeltaLimit) {
                    wheelDelta += wheelDeltaLimit;
                    var nextDesktopNumber = currentDesktopNumber - 1;
                    if (nextDesktopNumber >= 1) {
                        virtualDesktopBar.switchToDesktop(nextDesktopNumber);
                    } else if (plasmoid.configuration.wheelSwitchWrap) {
                        virtualDesktopBar.switchToDesktop(desktopAmount);
                    }
                }
            }
        }
    }
}
