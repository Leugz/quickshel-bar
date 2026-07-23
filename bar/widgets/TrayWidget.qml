import "../"

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Row {
    id: root
    spacing: 0 
    
    property var parentWindow

    property int threshold: 3

    property bool isPinned: false
    property bool isHovered: hoverHandler.hovered
    property bool isOpen: isPinned || isHovered
    
    property bool hasDrawer: trayRepeater.count > root.threshold

    HoverHandler { id: hoverHandler }

    Item {
        id: arrowContainer
        visible: root.hasDrawer
        width: root.hasDrawer ? 24 : 0
        height: 18
        clip: true
        opacity: root.hasDrawer ? 1 : 0

        Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }
        Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }

        Text {
            anchors.centerIn: parent
            text: root.isPinned ? "┃" : (root.isOpen ? "" : "") 
            color: root.isPinned ? Theme.mauve : Theme.text
            font.family: Theme.fontFamilyAlt
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.isPinned = !root.isPinned
        }
    }

    Repeater {
        id: trayRepeater
        model: SystemTray.items

        delegate: Item {
            id: trayItemWrapper
            required property SystemTrayItem modelData

            property bool isValid: modelData.id !== "nm-applet"
            
            property bool shouldShow: isValid && (!root.hasDrawer || root.isOpen)

            width: shouldShow ? 28 : 0
            height: 18
            clip: true
            opacity: shouldShow ? 1 : 0

            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }
            Behavior on opacity { NumberAnimation { duration: 250; easing.type: Easing.OutExpo } }

            IconImage {
                source: trayItemWrapper.modelData.icon
                width: 18
                height: 18
                anchors.right: parent.right 
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        trayItemWrapper.modelData.activate();
                    } else if (mouse.button === Qt.RightButton && trayItemWrapper.modelData.hasMenu) {
                        let mappedPos = mouseArea.mapToItem(null, mouse.x, mouse.y);
                        trayItemWrapper.modelData.display(root.parentWindow, mappedPos.x, mappedPos.y);
                    }
                }
            }
        }
    }
}
