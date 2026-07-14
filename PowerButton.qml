import QtQuick
import Quickshell

// waybar: custom/power -> on-click "wlogout -b 4"
Text {
    id: root
    text: "󰐥"
    color: Theme.maroon
    font.family: Theme.fontFamily
    font.pixelSize: 16
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["wlogout", "-b", "4"])
    }
}
