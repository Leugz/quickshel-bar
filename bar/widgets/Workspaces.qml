import "../"

import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root
    spacing: 4

    property var activeWorkspaces: {
        let arr = Array.from(Hyprland.workspaces.values);
        arr.sort((a, b) => a.id - b.id);
        return arr.filter(w => w.id > 0);
    }

    Repeater {
        model: root.activeWorkspaces

        delegate: Rectangle {
            id: wsDelegate
            required property var modelData 

            property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id
            property bool isUrgent: modelData.urgent
            property bool hovered: false

            height: 12
            width: isActive ? 24 : 12
            radius: height / 2

            // --- Colors ---
            color: {
                if (isUrgent) return Theme.red;
                if (isActive) return Theme.mauve;
                if (hovered) return Theme.lightblue;
                return Theme.surface2;
            }

            // --- Smooth Animations ---
            Behavior on width {
                NumberAnimation { 
                    duration: 250 
                    easing.type: Easing.OutExpo 
                }
            }
            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            // --- Interaction ---
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: wsDelegate.hovered = true
                onExited: wsDelegate.hovered = false
                onClicked: Quickshell.execDetached(["/usr/bin/hyprctl", "dispatch", "hl.dsp.focus({workspace='" + String(modelData.id) + "'})"])
            }
        }
    }
}
