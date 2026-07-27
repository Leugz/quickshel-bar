import QtQuick
import "../"

Rectangle {
    id: root
    property alias hovered: hoverHandler.hovered
    property real glowWidthFactor: 0.6

    color: Qt.rgba(15 / 255, 15 / 255, 25 / 255, 0.4)
    border.color: hoverHandler.hovered ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.05)
    border.width: 1

    Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.OutQuart } }
    HoverHandler { id: hoverHandler }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * root.glowWidthFactor
        radius: parent.radius

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: Theme.indigo }
            GradientStop { position: 1.0; color: "transparent" }
        }

        opacity: hoverHandler.hovered ? 0.25 : 0.15
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuart } }
    }
}
