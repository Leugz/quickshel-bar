import "../"

import QtQuick
import Quickshell

Text {
    id: root
    text: "󰐥"
    color: Theme.maroon
    font.family: Theme.fontFamilyAlt
    font.pixelSize: 16
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["wlogout", "-b", "4"])
    }
}
