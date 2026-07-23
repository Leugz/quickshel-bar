import QtQuick
import "../"
import "../windows"

Item {
    id: root
    property date now: new Date()
    property bool popupOpen: false
    
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
            text: "󰃭"
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

    Timer {
        id: hideTimer
        interval: 300
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
        
        onIsHoveredChanged: {
            if (isHovered) {
                hideTimer.stop();
            } else if (root.popupOpen) {
                hideTimer.restart();
            }
        }
    }
}
