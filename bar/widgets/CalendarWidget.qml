import QtQuick
import "../"
import "../components"

Item {
    id: root
    property date now: new Date()
    
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Row {
        id: row
        spacing: 6
        
        Text {
            text: "" 
            color: Theme.text
            font.family: Theme.fontFamilyAlt 
            font.pixelSize: Theme.fontSize
        }

        Text {
            text: Qt.formatDateTime(root.now, "ddd. dd MMM")
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            font.bold: true
        }
    }

    HoverHandler { id: hoverHandler }

    CalendarPopup {
        target: root
        shown: hoverHandler.hovered
        viewDate: root.now
    }
}
