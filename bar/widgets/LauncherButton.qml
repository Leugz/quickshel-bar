import "../"

import QtQuick
import Quickshell

Text {
    id: root
    text: ""
    color: Theme.blue
    font.family: Theme.launcherFont
    font.pixelSize: 18
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["wofi", "--show", "drun"])
    }
}
