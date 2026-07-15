import "../"

import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    spacing: 10

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property SystemTrayItem modelData
            implicitWidth: 18
            implicitHeight: 18

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
                implicitSize: 18
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        trayItem.modelData.activate();
                    } else if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                        trayItem.modelData.display(root.Window.window, mouse.x, mouse.y);
                    }
                }
            }
        }
    }
}
