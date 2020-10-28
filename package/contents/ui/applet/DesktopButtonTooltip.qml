import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import org.kde.plasma.plasmoid 2.0

import "../common" as UICommon

UICommon.TextTooltip {
    target: null
    location: plasmoid.location

    onVisibleChanged: {
        if (!visible) {
            Qt.callLater(function() {
                content = "";
            });
        }
    }

    function show(desktopButton) {
        if (renamePopup.visible) {
            return;
        }

        visualParent = desktopButton;

        var list = desktopButton.windowNameList;
        if (list.length == 0) {
            content = "No windows";
        }

        var map = {};
        for (var i in list) {
            var windowName = list[i];
            var counter = map[windowName] ? map[windowName] : 0
            map[windowName] = counter + 1;
        }

        var n = Object.keys(map).length;
        var limit = Math.min(n, 3);
        for (var i = 0; i < limit; i++) {
            var windowName = Object.keys(map)[i];

            var counter = map[windowName];
            if (counter > 1) {
                content += counter + "x ";
            }

            content += windowName;

            if (i < limit - 1) {
                content += ", ";
            }
        }

        if (n > limit) {
            content += " and more";
        }

        visible = true;
    }
}
