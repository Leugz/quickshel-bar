import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "../"
import "../windows"

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
        anchors.centerIn: parent

        Item {
            id: playPauseBtn
            width: 22
            height: 22
            anchors.verticalCenter: parent.verticalCenter
        
            Text {
                anchors.centerIn: parent
                text: root.activePlayer && root.activePlayer.isPlaying ? "" : ""
                color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.cyan : Theme.unactive
                font.family: Theme.fontFamilyAlt
            }
        
            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: if (root.activePlayer) root.activePlayer.togglePlaying();
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: 12

            text: {
                if (!root.activePlayer) return "";
                let dynamic = root.activePlayer.trackTitle;
                if (!dynamic) dynamic = root.activePlayer.identity || "";
                if (dynamic.length > 20) dynamic = dynamic.slice(0, 19) + "\u2026";
                return dynamic;
            }
            color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.text : Theme.unactive
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

        Item {
            id: visualizer
            width: barsRow.implicitWidth
            height: 16
            anchors.verticalCenter: parent.verticalCenter

            property bool isPlaying: root.activePlayer && root.activePlayer.isPlaying
            property var heights: [10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

            Process {
                id: cavaProc
                running: visualizer.isPlaying
                command: ["cava", "-p", Quickshell.env("HOME") + "/.config/quickshell/bar/config/cava.conf"]
                stdout: SplitParser {
                    onRead: data => {
                        if (!data) return;
                        const vals = data.trim().split(";").filter(s => s !== "").map(Number);
                        if (vals.length >= 9)
                            visualizer.heights = vals.map(h => (isNaN(h) || h < 4) ? 4 : h);
                    }
                }
            }

            onIsPlayingChanged: if (!isPlaying) heights = [6, 6, 6, 6, 6, 6, 6, 6, 6, 6]

            Row {
                id: barsRow
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: 9
                    Rectangle {
                        width: 3
                        height: visualizer.heights[index] ?? 4
                        radius: 1.5
                        anchors.verticalCenter: parent.verticalCenter
                        color: visualizer.isPlaying ? Theme.cyan : Theme.surface2
                        Behavior on height { NumberAnimation { duration: 50 } }
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onClicked: { root.popupOpen = true; hideTimer.restart(); }
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
