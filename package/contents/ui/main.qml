import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.mds 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

RowLayout {
    id: root
    spacing: 0
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property int desktopAmount: 0
    property var desktopEntries: []
    property int desktopEntrySpacing: 12

    MDSModel {
        id: mdsModel
    }

    RowLayout {
        id: desktopEntriesLayout
        spacing: root.spacing
        implicitHeight: parent.height
        anchors.verticalCenter: parent.verticalCenter
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

        plasmoid.setAction("addDesktop", "Add new Virtual Desktop", "list-add");
        plasmoid.setAction("removeDesktop", "Remove last Virtual Desktop", "list-remove");
        plasmoid.setAction("openDesktopSettings", "Configure Virtual Desktops...", "configure");
        plasmoid.action("removeDesktop").enabled = Qt.binding(function() {
            return desktopAmount > 1;
        });
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
            root.desktopAmount = desktopAmount;
            var currentDesktopAmount = desktopEntries.length;
            var desktopAmountDifference = desktopAmount - currentDesktopAmount;
            if (desktopAmountDifference > 0) {
                addDesktops(currentDesktopAmount, desktopAmountDifference);
            } else {
                removeDesktops(currentDesktopAmount);
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

    function action_addDesktop() {
        mdsModel.addDesktop();
    }

    function action_removeDesktop() {
        mdsModel.removeDesktop();
    }

    function action_openDesktopSettings() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop");
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
