import QtQuick
import Quickshell
import Quickshell.Wayland
import "../" 

PanelWindow {
    id: root
    
    visible: false 
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    exclusionMode: ExclusionMode.Ignore
    
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    color: "transparent"

    // 2. The Dimmed Background
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7) 
        
        // Force focus on this rectangle so it catches the key presses
        focus: true
        Keys.onEscapePressed: root.visible = false
        
        MouseArea {
            anchors.fill: parent
            onClicked: root.visible = false
        }
    }

    // 3. The Button Grid
    Row {
        anchors.centerIn: parent
        spacing: 30

        Repeater {
            model: [
                { name: "Lock", icon: "", cmd: "loginctl lock-session", hoverColor: Theme.blue },
                { name: "Suspend", icon: "󰤄", cmd: "systemctl suspend", hoverColor: Theme.mauve },
                { name: "Reboot", icon: "󰜉", cmd: "systemctl reboot", hoverColor: Theme.green },
                { name: "Shutdown", icon: "", cmd: "systemctl poweroff", hoverColor: "#f38ba8" } 
            ]

            delegate: Rectangle {
                id: actionButton
                width: 140
                height: 140
                radius: 20
                color: Theme.crust 
                
                scale: mouseArea.containsMouse ? 1.05 : 1.0
                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                
                Column {
                    anchors.centerIn: parent
                    spacing: 12
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.icon
                        font.family: Theme.fontFamilyAlt 
                        font.pixelSize: 48
                        color: mouseArea.containsMouse ? modelData.hoverColor : Theme.text
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.name
                        font.family: Theme.fontFamily
                        font.pixelSize: 16
                        color: Theme.text
                        opacity: 0.7
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        root.visible = false;
                        Quickshell.execDetached(["bash", "-c", modelData.cmd]);
                    }
                }
            }
        }
    }
}
