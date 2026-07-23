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
    
    visible: isOpen || innerBg.height > 0
    
    anchors {
        top: true
        right: true
    }
    
    margins.top: 45
    margins.right: 10
    
    width: 380
    color: "transparent" 
    
    implicitHeight: Math.min(500, innerLayout.implicitHeight + 32)
    
    exclusionMode: ExclusionMode.Ignore

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.isOpen = false
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                hideTimer.stop();
            } else if (root.isOpen) {
                hideTimer.restart();
            }
        }
    }

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
        height: root.isOpen ? root.implicitHeight : 0
        Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }

        anchors.top: parent.top
        clip: true
        
        color: Qt.rgba(30/255, 30/255, 46/255, 0.6)
        border.color: Theme.surface2
        border.width: 1
        radius: Theme.moduleRadius
        
        ColumnLayout {
            id: innerLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            spacing: 16
            
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
                
                Rectangle {
                    width: 84
                    height: 26
                    radius: 6
                    color: clearMouse.containsMouse ? Qt.alpha(Theme.blue, 0.15) : Qt.rgba(127/255, 127/255, 127/255, 0.08)
                    border.color: clearMouse.containsMouse ? Qt.alpha(Theme.blue, 0.4) : Qt.rgba(255/255, 255/255, 255/255, 0.12)
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent

                        text: "Clear All"
                        color: clearMouse.containsMouse ? Theme.blue : Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    MouseArea {
                        id: clearMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.isOpen = false;
                            const list = [...root.server.trackedNotifications.values];
                            list.forEach(n => n.dismiss());
                        }
                    }
                }
            }
            
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
