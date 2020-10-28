import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0

import "../common" as UICommon

PlasmaCore.Dialog {
    visualParent: null
    location: plasmoid.location

    hideOnWindowDeactivate: true
    flags: Qt.WindowStaysOnTopHint
    type: PlasmaCore.Dialog.PopupMenu

    property var callback

    mainItem: RowLayout {
        width: implicitWidth

        Text {
            Layout.alignment: Qt.AlignVCenter
            color: theme.textColor
            text: "Rename as"
        }

        UICommon.GrowingTextField {
            id: desktopNameInput
            implicitHeight: 28
            maximumLength: 20
            onAccepted: function() {
                callback();
            }
        }
    }

    onVisibleChanged: {
        if (!visible) {
            callback = function() {};
            Qt.callLater(function() {
                visualParent = null;
                desktopNameInput.text = "";
            });
        }
    }

    function show(desktopButton) {
        visualParent = desktopButton;

        desktopNameInput.text = desktopButton.name;
        desktopNameInput.focus = true;
        desktopNameInput.selectAll();

        callback = function() {
            var name = desktopNameInput.text.trim();
            if (name.length > 0) {
                backend.renameDesktop(desktopButton.number, name);
                visible = false;
            }
        }

        visible = true;
    }
}
