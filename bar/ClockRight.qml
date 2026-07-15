import QtQuick

// waybar: clock -> "<icon> {:L%a. %d %b}", calendar tooltip on hover
Text {
    id: root
    text: "  " + Qt.formatDateTime(now, "ddd. dd MMM")
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

    HoverHandler { id: hoverHandler }

    CalendarPopup {
        shown: hoverHandler.hovered
        viewDate: root.now
    }
}
