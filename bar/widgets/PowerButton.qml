import QtQuick
import Quickshell
import "../"

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
        onClicked: globalPowerMenu.visible = true
    }
}
