import QtQuick
import Quickshell.Services.Notifications
import "../"

Text {
    id: root
    required property NotificationServer server
    property var center
    
    readonly property int count: server.trackedNotifications.values.length

    text: count > 0 ? "󱅫" : "󰂜"
    color: count > 0 ? Theme.mauve : Theme.text
    
    font.family: Theme.fontFamilyAlt
    font.pixelSize: Theme.fontSize
    font.bold: true
    rightPadding: 4

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) center.isOpen = !center.isOpen;
        }
    }
}
