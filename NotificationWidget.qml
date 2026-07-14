import QtQuick

// waybar: custom/notification -> swaync-client -swb, click toggles panel,
// right-click toggles do-not-disturb
Text {
    id: root

    readonly property var iconMap: ({
        "notification": "󱅫",
        "none": "",
        "dnd-notification": "",
        "dnd-none": "󰂛",
        "inhibited-notification": "\uf0a2",
        "inhibited-none": "\uf0a2",
        "dnd-inhibited-notification": "\uf1f7",
        "dnd-inhibited-none": "\uf1f7"
    })

    visible: NotificationStatus.available
    text: iconMap[NotificationStatus.stateClass] || iconMap["none"]
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true
    rightPadding: 4

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) NotificationStatus.toggle();
            else NotificationStatus.openPanel();
        }
    }
}
