import QtQuick
import Quickshell
import "../"

PopupWindow {
    id: root

    property string text: ""
    property Item target: null
    property bool shown: false
    property bool isEffectivelyShown: shown && text.length > 0

    visible: isEffectivelyShown || bg.opacity > 0
    color: "transparent"

    implicitWidth: bg.width
    implicitHeight: bg.height

    anchor {
        item: root.target
        edges: Edges.Bottom
        gravity: Edges.Bottom | Edges.Right
        margins.top: 6
    }

    Rectangle {
        id: bg

        opacity: root.isEffectivelyShown ? 1.0 : 0.0
        scale: root.isEffectivelyShown ? 1.0 : 0.95
        transformOrigin: Item.Top

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

        width: label.implicitWidth + 16
        height: label.implicitHeight + 10
        radius: 6
        color: Theme.base
        border.color: Theme.surface2
        border.width: 1

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: Theme.text
            font.family: Theme.fontFamily 
            font.pixelSize: 12
            font.bold: true
        }
    }
}
