import QtQuick
import Quickshell.Services.Mpris

// waybar: mpris -> "{player_icon} {dynamic}" / "{status_icon} {dynamic}", max-length 20
Text {
    id: root

    property var activePlayer: {
        const players = Mpris.players.values;
        if (players.length === 0) return null;
        const playing = players.find(p => p.isPlaying);
        return playing !== undefined ? playing : players[0];
    }
    property bool hasPlayer: activePlayer !== null

    visible: hasPlayer
    width: hasPlayer ? implicitContentWidth + leftPadding + rightPadding : 0
    property real implicitContentWidth: contentWidth

    text: {
        if (!activePlayer) return "";
        const icon = activePlayer.isPlaying ? "▶" : "⏸";
        let dynamic = [activePlayer.trackArtist, activePlayer.trackTitle].filter(s => s && s.length > 0).join(" - ");
        if (!dynamic) dynamic = activePlayer.identity || "";
        if (dynamic.length > 20) dynamic = dynamic.slice(0, 19) + "\u2026";
        return icon + " " + dynamic;
    }
    color: (activePlayer && activePlayer.isPlaying) ? Theme.lightblue : Theme.unactive
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true

    Tooltip {
        text: root.activePlayer ? (root.activePlayer.trackTitle || "") : ""
        shown: hoverHandler.hovered && root.hasPlayer
    }

    HoverHandler { id: hoverHandler }

    WheelHandler {
        // waybar: on-scroll-up "playerctl next", on-scroll-down "playerctl previous"
        onWheel: event => {
            if (!root.activePlayer) return;
            if (event.angleDelta.y > 0 && root.activePlayer.canGoNext) root.activePlayer.next();
            else if (event.angleDelta.y < 0 && root.activePlayer.canGoPrevious) root.activePlayer.previous();
        }
    }
}
