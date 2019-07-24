import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.virtualdesktopbar 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

RowLayout {
    id: root

    VirtualDesktopBar {
        id: virtualDesktopBar
        cfg_dropRedundantDesktops: plasmoid.configuration.dropRedundantDesktops
        cfg_keepOneEmptyDesktop: plasmoid.configuration.keepOneEmptyDesktop
    }

    Plasmoid.compactRepresentation: DesktopSwitcher {}
    Plasmoid.fullRepresentation: DesktopNamePopup {}
    Plasmoid.toolTipItem: Item { width: -999; height: -999 }

    Connections {
        target: virtualDesktopBar

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

        onEmptyDesktopsUpdated: {
            plasmoid.compactRepresentationItem.onEmptyDesktopsUpdated(desktopNumbers);
        }
    }

    Component.onCompleted: {
        plasmoid.setAction("addNewDesktop", "Add New Desktop", "list-add");
        plasmoid.setAction("removeLastDesktop", "Remove Last Desktop", "list-remove");
        plasmoid.setActionSeparator("separator1");
        plasmoid.setAction("removeCurrentDesktop", "Remove Current Desktop", "list-remove");
        plasmoid.setAction("moveCurrentDesktopToLeft", "Move Current Desktop to Left", "arrow-left");
        plasmoid.setAction("moveCurrentDesktopToRight", "Move Current Desktop to Right", "arrow-right");
        plasmoid.setAction("renameCurrentDesktop", "Rename Current Desktop", "edit-rename");
        plasmoid.setActionSeparator("separator2");
        plasmoid.setAction("openDesktopSettings", "Configure Desktops...", "configure");
        
        var removeEnabledBinding = Qt.binding(function() {
            return plasmoid.compactRepresentationItem.desktopAmount > 1;
        });
        plasmoid.action("removeLastDesktop").enabled = removeEnabledBinding;
        plasmoid.action("removeCurrentDesktop").enabled = removeEnabledBinding;

        plasmoid.action("moveCurrentDesktopToLeft").enabled = Qt.binding(function() {
            return plasmoid.compactRepresentationItem.currentDesktopNumber > 1;
        });

        plasmoid.action("moveCurrentDesktopToRight").enabled = Qt.binding(function() {
            var desktopAmount = plasmoid.compactRepresentationItem.desktopAmount;
            return plasmoid.compactRepresentationItem.currentDesktopNumber < desktopAmount;
        });
    }

    function action_addNewDesktop() {
        virtualDesktopBar.addNewDesktop();
    }

    function action_moveCurrentDesktopToLeft() {
        virtualDesktopBar.moveCurrentDesktopToLeft();
    }

    function action_moveCurrentDesktopToRight() {
        virtualDesktopBar.moveCurrentDesktopToRight()
    }

    function action_removeLastDesktop() {
        virtualDesktopBar.removeLastDesktop();
    }

    function action_removeCurrentDesktop() {
        virtualDesktopBar.removeCurrentDesktop();
    }

    function action_renameCurrentDesktop() {
        plasmoid.expanded = true;
        plasmoid.fullRepresentationItem.refreshDesktopNameInput();
    }

    function action_openDesktopSettings() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop"); // old module
        KQuickControlsAddonsComponents.KCMShell.open("kcm_kwin_virtualdesktops"); // new module
    }
}
