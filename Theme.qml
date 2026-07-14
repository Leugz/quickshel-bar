pragma Singleton
import QtQuick

// Ported 1:1 from your original style.css @define-color palette,
// plus a couple of extra colors (yellow/green) that only showed up
// inside the waybar calendar tooltip markup.
QtObject {
    readonly property color base: "#1e1e2e"
    readonly property color crust: Qt.rgba(11 / 255, 12 / 255, 16 / 255, 0.5)
    readonly property color text: "#cdd6f4"
    readonly property color surface2: "#585b70"
    readonly property color unactive: "#94a3b8"
    readonly property color blue: "#818cf8"
    readonly property color lightblue: "#8fc4e0"
    readonly property color red: "#f38ba8"
    readonly property color mauve: "#cba6f7"
    readonly property color maroon: "#b14d8d"

    // used only by the calendar popup, taken from the clock.calendar.format block
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"

    readonly property string fontFamily: "Symbols Nerd Font"
    readonly property string fontFamilyAlt: "SF Pro Display"
    readonly property string launcherFont: "FiraCode Nerd Font"
    readonly property int fontSize: 14

    readonly property int barHeight: 37
    readonly property int barSpacing: 5
    readonly property int moduleRadius: 10
}
