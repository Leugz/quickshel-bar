import QtQuick
import Quickshell.Services.Mpris
import "../"

Row {
    id: root
    spacing: 8
    
    property var activePlayer: {
        const players = Mpris.players.values;
        if (players.length === 0) return null;
        const playing = players.find(p => p.isPlaying);
        return playing !== undefined ? playing : players[0];
    }
    
    property bool hasPlayer: activePlayer !== null
    visible: hasPlayer
    
    Text {
        text: {
            if (!root.activePlayer) return "";
            return root.activePlayer.isPlaying ? "▶" : "⏸"; 
        }
        color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.lightblue : Theme.unactive
        font.family: Theme.fontFamilyAlt
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: {
            if (!root.activePlayer) return "";
            let dynamic = [root.activePlayer.trackArtist, root.activePlayer.trackTitle].filter(s => s && s.length > 0).join(" - ");
            if (!dynamic) dynamic = root.activePlayer.identity || "";
            if (dynamic.length > 20) dynamic = dynamic.slice(0, 19) + "\u2026";
            return dynamic;
        }
        color: (root.activePlayer && root.activePlayer.isPlaying) ? Theme.lightblue : Theme.unactive
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.bold: true
    }
}
