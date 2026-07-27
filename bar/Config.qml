pragma Singleton
import QtQuick

QtObject {
    readonly property var launcherCmd: ["wofi", "--show", "drun"]
    readonly property var networkCmd: ["ghostty", "-e", "nmtui"]
    readonly property var mixerCmd: ["pavucontrol"]
    readonly property var trayHiddenIds: ["nm-applet"]
    readonly property int trayThreshold: 3
}
