pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Polls `swaync-client -swb`, which prints the same waybar-style JSON
// object your old custom/notification module consumed:
// { "text": ..., "tooltip": ..., "class": "notification|none|dnd-notification|..." }
Singleton {
    id: root
    property string stateClass: "none"
    property string tooltipText: ""
    property bool available: true

    function refresh() { proc.running = true }
    function toggle() { Quickshell.execDetached(["bash", "-c", "sleep 0.1 && swaync-client -t -sw"]) }
    function openPanel() { Quickshell.execDetached(["bash", "-c", "sleep 0.1 && swaync-client -d -sw"]) }

    Process {
        id: proc
        command: ["bash", "-c", "command -v swaync-client >/dev/null 2>&1 && swaync-client -swb 2>/dev/null || exit 1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                try {
                    const obj = JSON.parse(data);
                    root.available = true;
                    if (obj.class) root.stateClass = obj.class;
                    root.tooltipText = obj.tooltip || "";
                } catch (e) {
                    // ignore malformed / partial lines
                }
            }
        }
        onExited: exitCode => {
            if (exitCode !== 0) root.available = false;
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
