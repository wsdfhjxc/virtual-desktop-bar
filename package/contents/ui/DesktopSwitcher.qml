import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

Component {
    RowLayout {
        id: desktopSwitcher
        spacing: 0
        implicitHeight: parent.height
        anchors.fill: parent

        property int desktopAmount: 0
        property var desktopEntries: []
        property int desktopEntrySpacing: 12

        DesktopEntry {
            id: desktopEntryComponent
        }

        RowLayout {
            id: desktopEntriesLayout
            spacing: parent.spacing
            implicitHeight: parent.height
            anchors.fill: parent
        }

        PlusButton {}

        Component.onCompleted: {
            var desktopNames = mdsModel.getDesktopNames();
            var currentDesktopNumber = mdsModel.getCurrentDesktopNumber();

            for (var i = 0; i < desktopNames.length; i++) {
                var desktopNumber = i + 1;
                var desktopName = desktopNames[i];
                var isCurrentDesktop = currentDesktopNumber == desktopNumber;
                registerDesktopEntry(desktopName, isCurrentDesktop);
            }

            desktopAmount = desktopNames.length;
        }

        function onCurrentDesktopChanged(desktopNumber) {
            for (var i = 0; i < desktopEntries.length; i++) {
                var desktopEntry = desktopEntries[i];
                desktopEntry.isCurrentDesktop = desktopNumber == i + 1;
            }
        }

        function onDesktopAmountChanged(desktopAmount) {
            desktopSwitcher.desktopAmount = desktopAmount;
            var currentDesktopAmount = desktopEntries.length;
            var desktopAmountDifference = desktopAmount - currentDesktopAmount;
            if (desktopAmountDifference > 0) {
                addDesktops(currentDesktopAmount, desktopAmountDifference);
            } else if (desktopAmountDifference < 0) {
                removeDesktops(currentDesktopAmount);
            }
        }

        function onDesktopRemoveRequested(desktopNumber) {
            removeDesktop(desktopNumber);
            mdsModel.removeDesktop(desktopNumber);
            onCurrentDesktopChanged(desktopNumber);
        }

        function onDesktopNamesChanged() {
            var desktopNames = mdsModel.getDesktopNames();
            for (var i = 0; i < desktopNames.length; i++) {
                var desktopName = desktopNames[i];
                var desktopEntry = desktopEntries[i];
                if (desktopEntry.desktopName != desktopName) {
                    desktopEntry.desktopName = desktopName;
                }
            }
        }

        function registerDesktopEntry(desktopName, isCurrentDesktop) {
            desktopEntries.push(desktopEntryComponent.createObject(desktopEntriesLayout, {
                "desktopName": desktopName,
                "isCurrentDesktop": isCurrentDesktop
            }));
        }

        function addDesktops(currentDesktopAmount, addDesktopAmount) {
            var desktopNames = mdsModel.getDesktopNames();
            for (var i = 1; i <= addDesktopAmount; i++) {
                var desktopNumber = currentDesktopAmount + i;
                var desktopName = desktopNames[desktopNumber - 1];
                registerDesktopEntry(desktopName);
            }
        }

        function removeDesktops(currentDesktopAmount) {
            for (var i = currentDesktopAmount - 1; i >= desktopAmount; i--) {
                var desktopEntry = desktopEntries[i];
                desktopEntry.remove();
                desktopEntries.splice(i, 1);
            }
        }

        function removeDesktop(desktopNumber) {
            var desktopEntry = desktopEntries[desktopNumber - 1];
            desktopEntry.remove();
            desktopEntries.splice(desktopNumber - 1, 1);
        }

        function getDesktopNumberForDesktopEntry(desktopEntry) {
            for (var i = 0; i < desktopEntries.length; i++) {
                if (desktopEntries[i] == desktopEntry) {
                    return i + 1;
                }
            }
            return -1;
        }
    }
}
