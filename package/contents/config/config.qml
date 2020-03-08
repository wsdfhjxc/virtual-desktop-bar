import QtQuick 2.0
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: "Behavior"
        icon: "preferences-desktop-virtual"
        source: "config/BehaviorConfig.qml"
    }
    ConfigCategory {
        name: "Appearance"
        icon: "preferences-desktop-display-color"
        source: "config/AppearanceConfig.qml"
    }
    ConfigCategory {
        name: "Advanced"
        icon: "preferences-desktop"
        source: "config/AdvancedConfig.qml"
    }
}
