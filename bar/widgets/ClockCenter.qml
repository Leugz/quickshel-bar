import "../"

import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4
    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    Text {
        text: ""
        color: Theme.text
        font.family: Theme.fontFamilyAlt
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: Qt.formatDateTime(root.now, "hh:mm AP")
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.bold: true
    }
}
