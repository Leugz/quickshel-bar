pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string stateClass: "none"
    property string tooltipText: ""
    property bool available: true

    function toggle() { Quickshell.execDetached(["bash", "-c", "sleep 0.1 && swaync-client -t -sw"]) }
    function openPanel() { Quickshell.execDetached(["bash", "-c", "sleep 0.1 && swaync-client -d -sw"]) }

    Process {
        id: proc
        command: ["bash", "-c", "command -v swaync-client >/dev/null 2>&1 && swaync-client -swb"]
        running: true
        
        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                try {
                    const obj = JSON.parse(data);
                    root.available = true;
                    if (obj.class) root.stateClass = obj.class;
                    root.tooltipText = obj.tooltip || "";
                } catch (e) {}
            }
        }
        onExited: exitCode => {
            root.available = false;
            retryTimer.start();
        }
    }

    Timer {
        id: retryTimer
        interval: 3000
        running: false
        repeat: false
        onTriggered: proc.running = true
    }
}
