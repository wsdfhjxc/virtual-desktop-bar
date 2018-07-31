import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.mds 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

RowLayout {
    id: root
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    MDSModel {
        id: mdsModel
    }

    DesktopSwitcher {
        id: desktopSwitcher
    }

    Connections {
        target: mdsModel

        onDesktopChanged: {
            desktopSwitcher.onDesktopChanged(desktopNumber);
        }

        onDesktopAmountChanged: {
            desktopSwitcher.onDesktopAmountChanged(desktopAmount);
        }

        onDesktopNamesChanged: {
            desktopSwitcher.onDesktopNamesChanged();
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
}
