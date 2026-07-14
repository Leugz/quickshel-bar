import QtQuick

// waybar: clock#simpleclock -> "<icon> {:%I:%M %p}", tooltip false
Text {
    id: root
    text: "  " + Qt.formatDateTime(now, "hh:mm AP")
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true

    property date now: new Date()
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }
}
