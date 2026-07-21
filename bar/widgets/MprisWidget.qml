import QtQuick
import Quickshell.Services.Mpris
import "../"
import "../components"

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    property bool popupOpen: false
    
    property var activePlayer: {
        const players = Mpris.players.values;
        if (players.length === 0) return null;
        const playing = players.find(p => p.isPlaying);
        return playing !== undefined ? playing : players[0];
    }
    
    property bool hasPlayer: activePlayer !== null
    visible: hasPlayer

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: {
            if (!popup.isHovered) {
                root.popupOpen = false;
            }
        }
    }
    
    Row {
        id: row
        spacing: 8
        anchors.centerIn: parent

        Text {
            text: {
                if (!root.activePlayer) return "";
                return root.activePlayer.isPlaying ? "▶" : "⏸"; 
            }
            color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.lightblue : Theme.unactive
            font.family: Theme.fontFamilyAlt
            font.pixelSize: Theme.fontSize

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (root.activePlayer) root.activePlayer.togglePlaying();
            }
        }

        Text {
            text: {
                if (!root.activePlayer) return "";

                let dynamic = root.activePlayer.trackTitle;
                if (!dynamic) dynamic = root.activePlayer.identity || "";

                if (dynamic.length > 20) dynamic = dynamic.slice(0, 19) + "\u2026";
                return dynamic;
            }
            color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.lightblue : Theme.unactive
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.popupOpen = true;
                    hideTimer.restart();
                }
            }
        }
    }


    MediaPlayerPopup {
        id: popup
        target: root
        shown: root.popupOpen
        activePlayer: root.activePlayer

        onIsHoveredChanged: {
            if (isHovered) {
                hideTimer.stop();
            } else if (root.popupOpen) {
                hideTimer.restart();
            }
        }
    }
}
