import QtQuick
import Quickshell

// waybar: custom/launcher -> on-click "rofi -show drun"
Text {
    id: root
    text: ""
    color: Theme.blue
    font.family: Theme.launcherFont
    font.pixelSize: 18
    font.bold: true
    rightPadding: 12

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
    }
}
