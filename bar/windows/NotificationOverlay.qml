import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../components"

PanelWindow {
    id: root
    required property NotificationServer server
    property var linkedCenter

    WlrLayershell.namespace: "quickshell:notifoverlay"

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
            
            delegate: Item {
                id: toastWrapper
                width: parent.width
                
                property bool expired: false
                
                clip: true
                
                HoverHandler { id: wrapperHover }

                Timer {
                    interval: 5000
                    running: !wrapperHover.hovered 
                    onTriggered: toastWrapper.expired = true
                }
                
                Connections {
                    target: root.linkedCenter
                    function onIsOpenChanged() {
                        if (root.linkedCenter && root.linkedCenter.isOpen) {
                            toastWrapper.expired = true;
                        }
                    }
                }

                Component.onCompleted: {
                    if (root.linkedCenter && root.linkedCenter.isOpen) {
                        toastWrapper.expired = true;
                    }
                }
                
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
