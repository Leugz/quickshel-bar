pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    // "wifi" | "ethernet" | "disconnected"
    property string state: "disconnected"
    property string connectionName: ""

    function refresh() { proc.running = true }

    Process {
        id: proc
        command: ["bash", "-c",
            "nmcli -t -f TYPE,STATE,CONNECTION device status 2>/dev/null | " +
            "awk -F: '($1==\"wifi\"||$1==\"ethernet\") && $2==\"connected\"{print; f=1; exit} END{if(!f) print \"none:disconnected:\"}'"
        ]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                const parts = data.trim().split(":");
                const type = parts[0];
                root.connectionName = parts[2] || "";
                root.state = type === "wifi" ? "wifi" : type === "ethernet" ? "ethernet" : "disconnected";
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
