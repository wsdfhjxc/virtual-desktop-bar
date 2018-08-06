import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.mds 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

RowLayout {
    id: root

    MDSModel {
        id: mdsModel
    }

    Plasmoid.compactRepresentation: DesktopSwitcher {}
    Plasmoid.fullRepresentation: DesktopNamePopup {}
    Plasmoid.toolTipItem: Item { width: -999; height: -999 }

    Connections {
        target: mdsModel

        onActivated: {
            plasmoid.expanded = true;
        }

        onDesktopChanged: {
            plasmoid.compactRepresentationItem.onDesktopChanged(desktopNumber);
            plasmoid.fullRepresentationItem.refreshDesktopNameInput();
        }

        onDesktopAmountChanged: {
            plasmoid.compactRepresentationItem.onDesktopAmountChanged(desktopAmount);
        }

        onDesktopNamesChanged: {
            plasmoid.compactRepresentationItem.onDesktopNamesChanged();
            plasmoid.fullRepresentationItem.refreshDesktopNameInput();
        }
    }

    Component.onCompleted: {
        plasmoid.setAction("addDesktop", "Add New Virtual Desktop", "list-add");
        plasmoid.setAction("removeDesktop", "Remove Last Virtual Desktop", "list-remove");
        plasmoid.setAction("renameDesktop", "Rename Current Virtual Desktop", "edit-rename");
        plasmoid.setAction("openDesktopSettings", "Configure Virtual Desktops...", "configure");
        plasmoid.action("removeDesktop").enabled = Qt.binding(function() {
            return plasmoid.compactRepresentationItem.desktopAmount > 1;
        });
    }

    function action_addDesktop() {
        mdsModel.addDesktop();
    }

    function action_removeDesktop() {
        mdsModel.removeDesktop();
    }

    function action_renameDesktop() {
        plasmoid.expanded = true;
    }

    function action_openDesktopSettings() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop");
    }
}
