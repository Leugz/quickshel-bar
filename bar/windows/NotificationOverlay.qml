import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../components"

PanelWindow {
    id: root
    required property NotificationServer server

    property var linkedCenter

    anchors {
        top: true
        right: true
    }
    
    margins.top: 50 
    margins.right: 15
    
    width: 360
    implicitHeight: popupColumn.height
    
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore 
    
    Column {
        id: popupColumn
        width: parent.width
        spacing: 12
        
        Repeater {
            model: root.server.trackedNotifications
            
            // Wraps the Toast in a smart container that handles the visibility logic
            delegate: Item {
                id: toastWrapper
                width: parent.width
                
                property bool expired: false
                
                clip: true // Prevents the toast from spilling out during the shrink animation
                
                // 1. Hide automatically after 5 seconds
                Timer {
                    interval: 5000
                    running: true
                    onTriggered: toastWrapper.expired = true
                }
                
                // 2. Hide immediately if the user opens the Notification Center
                Connections {
                    target: root.linkedCenter
                    function onIsOpenChanged() {
                        if (globalNotificationCenter.isOpen) {
                            toastWrapper.expired = true;
                        }
                    }
                }
                
                // 3. Smoothly fade out and shrink to 0 height when expired
                opacity: expired ? 0 : 1
                visible: opacity > 0
                height: expired ? 0 : toast.implicitHeight
                
                Behavior on opacity { NumberAnimation { duration: 250 } }
                Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }
                
                NotificationToast {
                    id: toast
                    notification: modelData
                    width: parent.width
                }
            }
        }
    }
}
