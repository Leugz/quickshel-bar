import QtQuick
import "../"
import "../windows"

Item {
    id: root
    property date now: new Date()
    property bool popupOpen: false // Controls the popup state
    
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
            text: "󰃭" // Calendar icon
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

    // Delay timer to allow the mouse to travel to the popup
    Timer {
        id: hideTimer
        interval: 300 // 300ms grace period
        onTriggered: {
            if (!popup.isHovered) {
                root.popupOpen = false;
            }
        }
    }

    HoverHandler { 
        id: hoverHandler 
        onHoveredChanged: {
            if (hovered) {
                root.popupOpen = true;
                hideTimer.stop();
            } else {
                hideTimer.restart();
            }
        }
    }

    CalendarPopup {
        id: popup
        target: root
        shown: root.popupOpen
        viewDate: root.now
        
        // Tells the timer to stop counting if the mouse is on the calendar
        onIsHoveredChanged: {
            if (isHovered) {
                hideTimer.stop();
            } else if (root.popupOpen) {
                hideTimer.restart();
            }
        }
    }
}
