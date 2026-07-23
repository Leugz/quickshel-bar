import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../"
import "../components"

PanelWindow {
    id: root
    required property NotificationServer server
    WlrLayershell.namespace: "quickshell:notifcenter"
    
    property bool isOpen: false
    
    visible: isOpen || implicitHeight > 0
    
    anchors {
        top: true
        right: true
    }
    
    margins.top: 45
    margins.right: 10
    
    width: 380
    color: "transparent" 
    
    implicitHeight: isOpen ? Math.min(500, innerLayout.implicitHeight + 32) : 0
    Behavior on implicitHeight { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }
    
    exclusionMode: ExclusionMode.Ignore

    // --- NEW: Hover & Auto-Hide Logic ---
    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.isOpen = false
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                hideTimer.stop(); // Stops closing if your mouse is inside
            } else if (root.isOpen) {
                hideTimer.restart(); // Starts the countdown when your mouse leaves
            }
        }
    }

    // Automatically triggers the timer when opened from the top bar
    onIsOpenChanged: {
        if (isOpen && !hoverHandler.hovered) {
            hideTimer.restart();
        } else if (!isOpen) {
            hideTimer.stop();
        }
    }
    
    Rectangle {
        id: innerBg
        width: parent.width
        height: Math.min(500, innerLayout.implicitHeight + 32)
        anchors.bottom: parent.bottom // Anchors bottom so it pulls down

        clip: true
        
        color: Qt.rgba(30/255, 30/255, 46/255, 0.6) // More transparent for blur
        border.color: Theme.surface2
        border.width: 1
        radius: Theme.moduleRadius
        
        opacity: root.isOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        
        ColumnLayout {
            id: innerLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            spacing: 16
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: "Notifications"
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.bold: true
                    Layout.fillWidth: true
                }
                
                // Clear All Button
                Rectangle {
                    width: 80
                    height: 24
                    radius: 4
                    color: Theme.surface2
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Clear All"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.isOpen = false;
                            const list = [...root.server.trackedNotifications.values];
                            list.forEach(n => n.dismiss());
                        }
                    }
                }
            }
            
            // FIXED: Notification History (Replaced ScrollView/Repeater with ListView)
            ListView {
                id: popupList
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                Layout.maximumHeight: 400
                clip: true
                spacing: 10
                
                model: root.server.trackedNotifications
                
                delegate: NotificationToast {
                    notification: modelData
                    width: popupList.width
                }

                // Smooth animations for items arriving/leaving the center
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
                }
                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 150 }
                    NumberAnimation { property: "scale"; to: 0.9; duration: 150 }
                }
            }
        }
    }
}
