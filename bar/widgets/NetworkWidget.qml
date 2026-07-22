import "../"
import "../store"
import "../windows"
import QtQuick
import Quickshell

Text {
    id: root
    text: NetworkStatus.state === "wifi" ? ""
        : NetworkStatus.state === "ethernet" ? "󰈀"
        : "󰤭"
    color: NetworkStatus.state === "disconnected" ? Theme.surface2 : Theme.blue
    font.family: Theme.fontFamilyAlt
    font.pixelSize: Theme.fontSize
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["kitty", "-e", "nmtui"])
    }

    HoverHandler { id: hoverHandler }

    Tooltip {
        target: root
        shown: hoverHandler.hovered
        text: NetworkStatus.state === "wifi" ? "Connected to " + NetworkStatus.connectionName
            : NetworkStatus.state === "ethernet" ? "Connected (" + NetworkStatus.connectionName + ")"
            : "Disconnected"
    }
}
