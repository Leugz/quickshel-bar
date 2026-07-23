import "../"
import "../services"
import "../windows"
import QtQuick
import Quickshell

Text {
    id: root
    property int pct: Math.round(Audio.volume * 100)

    text: {
        if (Audio.muted) return "";
        if (pct < 34) return "";
        if (pct < 67) return "";
        return "";
    }
    color: Audio.muted ? Theme.surface2 : Theme.mauve
    font.family: Theme.fontFamilyAlt
    font.pixelSize: Theme.fontSize
    font.bold: true

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) Quickshell.execDetached(["pavucontrol"]);
            else Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
        }
    }
    WheelHandler {
        onWheel: event => Audio.changeVolume(event.angleDelta.y > 0 ? 5 : -5)
    }

    HoverHandler { id: hoverHandler }

    Tooltip {
        target: root
        shown: hoverHandler.hovered
        text: Audio.muted ? "Muted" : root.pct + "% volume"
    }
}
