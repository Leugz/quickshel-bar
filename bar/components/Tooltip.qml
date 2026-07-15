import QtQuick

Rectangle {
    id: root
    property string text: ""
    property bool shown: false

    visible: shown && text.length > 0
    z: 1000
    radius: 6
    color: Theme.base
    border.color: Theme.surface2
    border.width: 1
    implicitWidth: label.implicitWidth + 16
    implicitHeight: label.implicitHeight + 10

    anchors.top: parent.bottom
    anchors.topMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter

    Text {
        id: label
        anchors.centerIn: parent
        text: root.text
        color: Theme.text
        font.family: Theme.fontFamilyAlt
        font.pixelSize: 12
    }
}
