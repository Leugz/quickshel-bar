import "../"
import QtQuick
import Quickshell.Services.Notifications

Text {
    id: root
    required property NotificationServer server
    property var parentWindow
    
    // 1. The Invisible Tracker
    // This actively listens to the model's background signals to update its own count
    Repeater {
        id: notifTracker
        model: root.server.trackedNotifications
        delegate: Item {} // Spawns an empty, invisible item just to keep tally
    }

    // 2. Dynamic Bindings
    // Now wired to 'notifTracker.count', forcing the UI to update in real-time
    text: notifTracker.count > 0 ? "󱅫" : "󰂜"
    color: notifTracker.count > 0 ? Theme.mauve : Theme.text
    
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
                for (let i = 0; i < parentWindow.centers.count; i++) {
                    let center = parentWindow.centers.objectAt(i);
                    
                    if (i === parentWindow.screenIndex) {
                        center.isOpen = !center.isOpen;
                    } else {
                        center.isOpen = false;
                    }
                }
            }
        }
    }
}
