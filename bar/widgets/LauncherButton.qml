import QtQuick
import Quickshell
import "../"

Text {
    id: root
    text: "󰣇"
    color: Theme.indigo
    font.family: Theme.launcherFont
    font.pixelSize: 18
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(Config.launcherCmd)
    }
}
