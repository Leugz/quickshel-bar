import "../"
import "../services"

import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4

    Text {
        text: ""
        color: Theme.text
        font.family: Theme.fontFamilyAlt
        font.pixelSize: Theme.fontSize
    }

    Text {
        text: Qt.formatDateTime(Time.now, "hh:mm AP")
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        font.bold: true
    }
}
