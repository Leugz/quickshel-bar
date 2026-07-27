import QtQuick
import QtQuick.Layouts
import Quickshell
import "../"
import "../components"
import "../services"

PopupWindow {
    id: root
    property bool shown: false
    property Item target: null

    property alias isHovered: bg.hovered

    visible: shown || bg.implicitHeight > 0
    color: "transparent"
    implicitWidth: bg.width
    implicitHeight: bg.implicitHeight

    anchor {
        item: root.target
        edges: Edges.Bottom
        gravity: Edges.Bottom
        margins.top: 6
    }

    GlassPanel {
        id: bg
        width: 280
        radius: Theme.moduleRadius + 4
        clip: true

        implicitHeight: root.shown ? mainCol.implicitHeight + 24 : 1
        opacity: root.shown ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on implicitHeight { NumberAnimation { duration: 400; easing.type: Easing.OutQuart } }

        ColumnLayout {
            id: mainCol
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 12
            width: parent.width - 24
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: Audio.muted ? "󰝟" : "󰕾"
                    color: Audio.muted ? Theme.indigo : Theme.text
                    font.family: Theme.fontFamilyAlt
                    font.pixelSize: 18
                    
                    MouseArea { 
                        anchors.fill: parent
                        anchors.margins: -4
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Audio.toggleMute() 
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24

                    Rectangle {
                        id: track
                        width: parent.width
                        height: 6
                        radius: 3
                        color: Qt.rgba(1, 1, 1, 0.1)
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: track.width * Audio.volume
                            height: parent.height
                            radius: 3
                            color: Theme.mauve
                            Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: mouse => Audio.setVolume(mouse.x / width)
                        onPositionChanged: mouse => { 
                            if (pressed) Audio.setVolume(Math.max(0, Math.min(1, mouse.x / width))) 
                        }
                    }
                }
                
                Text {
                    text: Math.round(Audio.volume * 100) + "%"
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 12
                    font.bold: true
                    Layout.preferredWidth: 32
                    horizontalAlignment: Text.AlignRight
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Repeater {
                    model: Audio.sinks
                    delegate: Rectangle {
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.preferredHeight: 32
                        radius: 6
                        
                        color: modelData === Audio.sink ? Qt.alpha(Theme.indigo, 0.2) : (sinkMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.05) : "transparent")
                        border.color: modelData === Audio.sink ? Qt.alpha(Theme.indigo, 0.4) : "transparent"
                        border.width: 1
                        
                        Behavior on color { ColorAnimation { duration: 150 } }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 10
                            
                            Text {
                                text: "󰋎" 
                                color: modelData === Audio.sink ? Theme.indigo : Theme.unactive
                                font.family: Theme.fontFamilyAlt
                                font.pixelSize: 14
                            }
                            
                            Text {
                                Layout.fillWidth: true
                                text: modelData.description || modelData.name
                                color: modelData === Audio.sink ? Theme.text : Theme.unactive
                                font.family: Theme.fontFamily
                                font.pixelSize: 12
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea { 
                            id: sinkMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Audio.setSink(modelData) 
                        }
                    }
                }
            }
        }
    }
}
