import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../components"

PanelWindow {
    id: root
    required property NotificationServer server
    
    property bool isOpen: false
    
    // Waits for the inner rectangle to finish fading out before hiding the window entirely
    visible: isOpen || innerBg.opacity > 0
    
    anchors {
        top: true
        bottom: true
        right: true
    }
    
    margins.top: 45
    margins.bottom: 10
    margins.right: isOpen ? 10 : -width - 20 
    
    width: 380
    color: "transparent" 
    
    Behavior on margins.right { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }
    
    exclusionMode: ExclusionMode.Ignore
    
    // The internal Rectangle handles the glassy background, borders, radius, AND opacity!
    Rectangle {
        id: innerBg
        anchors.fill: parent
        color: Qt.rgba(30/255, 30/255, 46/255, 0.95)
        border.color: Theme.surface2
        border.width: 1
        radius: Theme.moduleRadius
        
        // Opacity moved here!
        opacity: root.isOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        
        ColumnLayout {
            anchors.fill: parent
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
                            for (let i = 0; i < root.server.trackedNotifications.count; i++) {
                                root.server.trackedNotifications.get(i).dismiss();
                            }
                        }
                    }
                }
            }
            
            // Notification History
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                Column {
                    width: parent.width
                    spacing: 10
                    
                    Repeater {
                        model: root.server.trackedNotifications
                        delegate: NotificationToast {
                            notification: modelData
                            width: parent.width
                        }
                    }
                }
            }
        }
    }
}
