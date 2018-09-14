import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import com.github.wsdfhjxc.virtualdesktopbar 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

RowLayout {
    id: root

    VDBModel {
        id: vdbModel
    }

    Plasmoid.compactRepresentation: DesktopSwitcher {}
    Plasmoid.fullRepresentation: DesktopNamePopup {}
    Plasmoid.toolTipItem: Item { width: -999; height: -999 }

    Connections {
        target: vdbModel

        onCurrentDesktopChanged: {
            plasmoid.compactRepresentationItem.onCurrentDesktopChanged(desktopNumber);
        }

        onDesktopAmountChanged: {
            plasmoid.compactRepresentationItem.onDesktopAmountChanged(desktopAmount);
        }

        onDesktopNamesChanged: {
            plasmoid.compactRepresentationItem.onDesktopNamesChanged();
        }

        onCurrentDesktopNameChangeRequested: {
            action_renameCurrentDesktop();
        }

        onDesktopRemoveRequested: {
            plasmoid.compactRepresentationItem.onDesktopRemoveRequested(desktopNumber);
        }
    }

    Component.onCompleted: {
        plasmoid.setAction("addNewDesktop", "Add New Virtual Desktop", "list-add");
        plasmoid.setAction("removeLastDesktop", "Remove Last Virtual Desktop", "list-remove");
        plasmoid.setActionSeparator("separator1");
        plasmoid.setAction("removeCurrentDesktop", "Remove Current Virtual Desktop", "list-remove");
        plasmoid.setAction("moveCurrentDesktopToLeft", "Move Current Virtual Desktop To Left", "arrow-left");
        plasmoid.setAction("moveCurrentDesktopToRight", "Move Current Virtual Desktop To Right", "arrow-right");
        plasmoid.setAction("renameCurrentDesktop", "Rename Current Virtual Desktop", "edit-rename");
        plasmoid.setActionSeparator("separator2");
        plasmoid.setAction("openDesktopSettings", "Configure Virtual Desktops...", "configure");
        plasmoid.action("removeDesktop").enabled = Qt.binding(function() {
            return plasmoid.compactRepresentationItem.desktopAmount > 1;
        });
    }

    function action_addNewDesktop() {
        vdbModel.addNewDesktop();
    }

    function action_moveCurrentDesktopToLeft() {
        vdbModel.moveCurrentDesktopToLeft();
    }

    function action_moveCurrentDesktopToRight() {
        vdbModel.moveCurrentDesktopToRight()
    }

    function action_removeLastDesktop() {
        vdbModel.removeLastDesktop();
    }

    function action_removeCurrentDesktop() {
        vdbModel.removeCurrentDesktop();
    }

    function action_renameCurrentDesktop() {
        plasmoid.expanded = true;
        plasmoid.fullRepresentationItem.refreshDesktopNameInput();
    }

    function action_openDesktopSettings() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop");
    }
}
