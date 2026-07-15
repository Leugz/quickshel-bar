import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

// waybar: hyprland/workspaces, persistent-workspaces 1-4, sort-by-number
RowLayout {
    id: root
    spacing: 4

    property var persistentIds: [1, 2, 3, 4]

    Repeater {
        model: root.persistentIds

        delegate: Text {
            id: wsDelegate
            required property var modelData

            property var ws: Hyprland.workspaces.values.find(w => w.id === modelData)
            property bool isActive: Hyprland.focusedWorkspace?.id === modelData
            property bool isUrgent: ws ? ws.urgent : false
            property bool hovered: false

            text: isUrgent ? "" : isActive ? "" : String(modelData)
            color: hovered ? Theme.blue : isUrgent ? Theme.red : isActive ? Theme.mauve : (ws ? Theme.blue : Theme.surface2)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: wsDelegate.hovered = true
                onExited: wsDelegate.hovered = false
                onClicked: Hyprland.dispatch("workspace " + modelData)
            }
        }
    }
}
