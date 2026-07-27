import QtQuick
import "../"
import "../services"
import "../windows"

Item {
    id: root
    property bool popupOpen: false
    
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

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
            text: Qt.formatDateTime(Time.now, "ddd. dd MMM")
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
