import "../"

import QtQuick
import Quickshell.Services.Notifications

Text {
    id: root
    required property NotificationServer server

    text: server.trackedNotifications.count > 0 ? "󱅫" : ""
    color: Theme.text
    font.family: Theme.fontFamilyAlt
    font.pixelSize: Theme.fontSize
    font.bold: true
    rightPadding: 4

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                globalNotificationCenter.isOpen = !globalNotificationCenter.isOpen;
            }
        }
    }
}
