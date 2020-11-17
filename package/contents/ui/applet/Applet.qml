import QtQuick 2.7

import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import org.kde.plasma.virtualdesktopbar 1.2

Item {
    id: root

    DesktopRenamePopup { id: renamePopup }
    DesktopButtonTooltip { id: tooltip }

    Plasmoid.fullRepresentation: Container {}
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property QtObject config: plasmoid.configuration
    property Item container: plasmoid.fullRepresentationItem

    property bool isTopLocation: plasmoid.location == PlasmaCore.Types.TopEdge
    property bool isVerticalOrientation: plasmoid.formFactor == PlasmaCore.Types.Vertical

    VirtualDesktopBar {
        id: backend

        cfg_EmptyDesktopsRenameAs: config.EmptyDesktopsRenameAs
        cfg_AddingDesktopsExecuteCommand: config.AddingDesktopsExecuteCommand
        cfg_DynamicDesktopsEnable: config.DynamicDesktopsEnable
        cfg_MultipleScreensFilterOccupiedDesktops: config.MultipleScreensFilterOccupiedDesktops
    }

    Connections {
        target: backend
        onDesktopInfoListSent: container.update(desktopInfoList)
        onRequestRenameCurrentDesktop: renamePopup.show(container.currentDesktopButton)
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            initializeContextMenuActions();
            backend.requestDesktopInfoList();
        });
    }

    function initializeContextMenuActions() {
        plasmoid.setAction("renameDesktop", "Rename Desktop", "edit-rename");
        plasmoid.setAction("removeDesktop", "Remove Desktop", "list-remove");
        plasmoid.setActionSeparator("separator1");
        plasmoid.setAction("addDesktop", "Add Desktop", "list-add");
        plasmoid.setAction("removeLastDesktop", "Remove Last Desktop", "list-remove");
        plasmoid.setActionSeparator("separator2");

        var renameRemoveDesktopVisible = Qt.binding(function() {
            return container.lastHoveredButton &&
                   container.lastHoveredButton.objectType == "DesktopButton";
        });

        var renameDesktopEnabled = Qt.binding(function() {
            return config.DesktopLabelsStyle != 1;
        });

        var addRemoveDesktopEnabled = Qt.binding(function() {
            return !config.DynamicDesktopsEnable;
        });

        plasmoid.action("renameDesktop").visible = renameRemoveDesktopVisible;
        plasmoid.action("renameDesktop").enabled = renameDesktopEnabled;
        plasmoid.action("removeDesktop").visible = renameRemoveDesktopVisible;
        plasmoid.action("removeDesktop").enabled = addRemoveDesktopEnabled;
        plasmoid.action("separator1").visible = renameRemoveDesktopVisible;
        plasmoid.action("addDesktop").enabled = addRemoveDesktopEnabled;
        plasmoid.action("removeLastDesktop").enabled = addRemoveDesktopEnabled;
    }

    function action_renameDesktop() {
        renamePopup.show(container.lastHoveredButton);
    }

    function action_removeDesktop() {
        backend.removeDesktop(container.lastHoveredButton.number);
    }

    function action_addNewDesktop() {
        backend.addDesktop();
    }

    function action_removeLastDesktop() {
        backend.removeDesktop(container.lastDesktopButton.number);
    }
}
