import QtQuick
import Quickshell
import "../"
import "../services"
import "../windows"

Text {
    id: root
    property int pct: Math.round(Audio.volume * 100)
    
    property bool popupOpen: false

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

    Timer {
        id: hideTimer
        interval: 800
        onTriggered: {
            if (!popup.isHovered && !hoverHandler.hovered) {
                root.popupOpen = false;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onWheel: wheel => {
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            Audio.setVolume(Audio.volume + step);
        }
        
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                root.popupOpen = !root.popupOpen;
                
            } else if (mouse.button === Qt.MiddleButton) {
                Quickshell.execDetached(Config.mixerCmd);
                root.popupOpen = false; 
                
            } else if (mouse.button === Qt.RightButton) {
                Audio.toggleMute();
            }
        }
    }

    HoverHandler { 
        id: hoverHandler 
        onHoveredChanged: {
            if (!hovered && root.popupOpen) {
                hideTimer.restart();
            } else if (hovered) {
                hideTimer.stop();
            }
        }
    }

    Tooltip {
        target: root
        shown: hoverHandler.hovered && !root.popupOpen
        text: Audio.muted ? "Muted" : root.pct + "% volume"
    }

    VolumePopup {
        id: popup
        target: root
        shown: root.popupOpen
        
        onIsHoveredChanged: {
            if (isHovered) {
                hideTimer.stop();
            } else if (root.popupOpen) {
                hideTimer.restart();
            }
        }
    }
}
