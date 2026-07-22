import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../components"

PanelWindow {
    id: root
    required property NotificationServer server

    anchors {
        top: true
        right: true
    }
    
    margins.top: 50 
    margins.right: 15
    
    width: 360
    
    // FIXED: Strictly tracks the height of the column inside it!
    implicitHeight: popupColumn.height
    
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore 
    
    Column {
        id: popupColumn
        width: parent.width
        spacing: 12
        
        Repeater {
            model: root.server.trackedNotifications 
            
            delegate: NotificationToast {
                // The property mapping is now safely handled inside the Toast itself!
            }
        }
    }
}
