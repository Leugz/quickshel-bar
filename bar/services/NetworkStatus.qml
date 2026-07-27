pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string state: "disconnected"
    property string connectionName: ""

    function refresh() { 
        if (!proc.running) proc.running = true; 
    }

    Process {
        id: proc
        running: false
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.split("\n").find(l => {
                    const p = l.split(":");
                    return (p[0] === "wifi" || p[0] === "ethernet") && p[1] === "connected";
                });
                if (line) {
                    const p = line.split(":");
                    root.state = p[0];
                    root.connectionName = p[2] || "";
                } else {
                    root.state = "disconnected";
                    root.connectionName = "";
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
