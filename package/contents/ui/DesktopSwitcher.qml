import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4

RowLayout {
    id: desktopSwitcher
    spacing: 0
    implicitHeight: parent.height
    anchors.fill: parent

    property int desktopAmount: 0
    property var desktopEntries: []
    property int desktopEntrySpacing: 12

    RowLayout {
        id: desktopEntriesLayout
        spacing: parent.spacing
        implicitHeight: parent.height
        anchors.fill: parent
    }

    DesktopEntry {
        id: desktopEntryComponent
    }

    AddDesktopButton {}

    Component.onCompleted: {
        var desktopNames = mdsModel.getDesktopNames();
        var activeDesktopNumber = mdsModel.getActiveDesktopNumber();

        for (var i = 0; i < desktopNames.length; i++) {
            var desktopNumber = i + 1;
            var desktopName = desktopNames[i];
            var activeDesktop = activeDesktopNumber == desktopNumber;
            registerDesktopEntry(desktopNumber, desktopName, activeDesktop);
        }

        desktopAmount = desktopNames.length;
    }

    function onDesktopChanged(desktopNumber) {
        for (var i = 0; i < desktopEntries.length; i++) {
            var desktopEntry = desktopEntries[i];
            desktopEntry.activeDesktop = desktopNumber == i + 1;
        }
    }

    function onDesktopAmountChanged(desktopAmount) {
        desktopSwitcher.desktopAmount = desktopAmount;
        var currentDesktopAmount = desktopEntries.length;
        var desktopAmountDifference = desktopAmount - currentDesktopAmount;
        if (desktopAmountDifference > 0) {
            addDesktops(currentDesktopAmount, desktopAmountDifference);
        } else {
            removeDesktops(currentDesktopAmount);
        }
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

    function registerDesktopEntry(desktopNumber, desktopName, activeDesktop) {
        desktopEntries.push(desktopEntryComponent.createObject(desktopEntriesLayout, {
            "desktopNumber": desktopNumber,
            "desktopName": desktopName,
            "activeDesktop": activeDesktop
        }));
    }

    function addDesktops(currentDesktopAmount, addDesktopAmount) {
        var desktopNames = mdsModel.getDesktopNames();
        for (var i = 1; i <= addDesktopAmount; i++) {
            var desktopNumber = currentDesktopAmount + i;
            var desktopName = desktopNames[desktopNumber - 1];
            registerDesktopEntry(desktopNumber, desktopName);
        }
    }

    function removeDesktops(currentDesktopAmount) {
        for (var i = currentDesktopAmount - 1; i >= desktopAmount; i--) {
            var desktopEntry = desktopEntries[i];
            desktopEntry.remove();
            desktopEntries.splice(i, 1);
        }
    }
}
