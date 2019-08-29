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
        cfg_emptyDesktopName: plasmoid.configuration.emptyDesktopName
    }

    Plasmoid.compactRepresentation: DesktopSwitcher {}
    Plasmoid.fullRepresentation: DesktopNamePopup {}
    Plasmoid.toolTipItem: Item { width: -999; height: -999 }

    property var desktopSwitcher: plasmoid.compactRepresentationItem
    property var desktopNamePopup: plasmoid.fullRepresentationItem

    Connections {
        target: virtualDesktopBar

        onCurrentDesktopChanged: {
            desktopSwitcher.onCurrentDesktopChanged(desktopNumber);
        }

        onDesktopAmountChanged: {
            desktopSwitcher.onDesktopAmountChanged(desktopAmount);
        }

        onDesktopNamesChanged: {
            desktopSwitcher.onDesktopNamesChanged();
        }

        onCurrentDesktopNameChangeRequested: {
            action_renameCurrentDesktop();
        }

        onEmptyDesktopsUpdated: {
            desktopSwitcher.onEmptyDesktopsUpdated(desktopNumbers);
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

        plasmoid.action("addNewDesktop").enabled = Qt.binding(function() {
            if (desktopSwitcher.desktopAmount == 20) {
                return false;
            }
            return !(plasmoid.configuration.keepOneEmptyDesktop && plasmoid.configuration.dropRedundantDesktops);
        });

        var removeGuard = function(desktopNumber) {
            var emptyDesktopAmount = 0;
            for (var i = 0; i < desktopSwitcher.desktopAmount; i++) {
                var desktopButton = desktopSwitcher.desktopButtons[i];
                if (desktopButton && desktopButton.isEmptyDesktop) {
                    emptyDesktopAmount++;
                }
            }
            var desktopButton = desktopSwitcher.desktopButtons[desktopNumber - 1];
            return !(emptyDesktopAmount == 1 && desktopButton.isEmptyDesktop);
        };

        plasmoid.action("removeLastDesktop").enabled = Qt.binding(function() {
            return desktopSwitcher.desktopAmount > 1 &&
                   (!plasmoid.configuration.keepOneEmptyDesktop || removeGuard(desktopSwitcher.desktopAmount));
        });

        plasmoid.action("removeCurrentDesktop").enabled = Qt.binding(function() {
            return desktopSwitcher.desktopAmount > 1 &&
                   (!plasmoid.configuration.keepOneEmptyDesktop || removeGuard(desktopSwitcher.currentDesktopNumber));
        });

        plasmoid.action("moveCurrentDesktopToLeft").enabled = Qt.binding(function() {
            return desktopSwitcher.currentDesktopNumber > 1;
        });

        plasmoid.action("moveCurrentDesktopToRight").enabled = Qt.binding(function() {
            var desktopAmount = desktopSwitcher.desktopAmount;
            return desktopSwitcher.currentDesktopNumber < desktopAmount;
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
        desktopNamePopup.refreshDesktopNameInput();
    }

    function action_openDesktopSettings() {
        KQuickControlsAddonsComponents.KCMShell.open("desktop"); // old module
        KQuickControlsAddonsComponents.KCMShell.open("kcm_kwin_virtualdesktops"); // new module
    }
}
