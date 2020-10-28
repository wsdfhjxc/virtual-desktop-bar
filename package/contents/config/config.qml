import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: "Behavior"
        icon: "preferences-desktop"
        source: "config/BehaviorTab.qml"
    }
    ConfigCategory {
        name: "Appearance"
        icon: "preferences-desktop-display-color"
        source: "config/AppearanceTab.qml"
    }
}
