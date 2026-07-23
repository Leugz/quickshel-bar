import QtQuick
import QtQuick.Effects
import Quickshell
// import Quickshell.Wayland
import Quickshell.Services.Mpris
import "../"

PopupWindow {
    id: root
    // WlrLayershell.namespace: "quickshell:mediaplayer"
    
    Component.onCompleted: console.log("### POPUP COMPONENT LOADED ###")
    property bool shown: false
    property Item target: null
    property var activePlayer: null
    
    property alias isHovered: hoverHandler.hovered
    visible: shown || bg.opacity > 0
    color: "transparent"
    implicitWidth: bg.width
    implicitHeight: bg.height
    
    anchor {
        item: root.target
        edges: Edges.Bottom
        gravity: Edges.Bottom | Edges.Right
        margins.top: 6
    }

    Rectangle {
        id: bg
        width: 350
        height: 115
        
        opacity: root.shown && root.activePlayer ? 1.0 : 0.0
        scale: root.shown && root.activePlayer ? 1.0 : 0.95
        transformOrigin: Item.Top
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        
        color: Qt.rgba(15/255, 15/255, 25/255, 0.4)
        border.color: hoverHandler.hovered ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.05)
        border.width: 1
        radius: Theme.moduleRadius + 4 
        clip: true
        
        Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.OutQuart } }
        HoverHandler { id: hoverHandler }

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * 0.6 
            radius: parent.radius
            
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Theme.blue }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            opacity: hoverHandler.hovered ? 0.25 : 0.15 
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutQuart } }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 12

            Rectangle {
                id: cover
                width: 85
                height: 85
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                radius: 8
                clip: true
                color: Qt.rgba(255, 255, 255, 0.05)
                border.color: Qt.rgba(255, 255, 255, 0.1)
                border.width: 1
                
                Text {
                    anchors.centerIn: parent
                    text: ""
                    font.family: Theme.fontFamilyAlt
                    font.pixelSize: 32
                    color: Qt.rgba(255, 255, 255, 0.2)
                    visible: coverArtImg.status !== Image.Ready
                }
                
                Image {
                    id: coverArtImg
                    anchors.fill: parent
                    cache: false
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    property string lastGoodSource: ""
                    source: lastGoodSource
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: coverMask
                    }
                }
                
                Rectangle { 
                    id: coverMask
                    anchors.fill: coverArtImg
                    radius: 8
                    layer.enabled: true
                    visible: false
                }
                
                Connections {
                    target: root.activePlayer
                    function onTrackArtUrlChanged() {
                        const raw = root.activePlayer ? root.activePlayer.trackArtUrl : "";
                        if (raw) {
                            coverArtImg.lastGoodSource = raw.startsWith("/") ? ("file://" + raw) : raw;
                        }
                    }
                }
                
                Connections {
                    target: root
                    function onActivePlayerChanged() {
                        if (!root.activePlayer) coverArtImg.lastGoodSource = "";
                        else if (root.activePlayer.trackArtUrl) {
                            const raw = root.activePlayer.trackArtUrl;
                            coverArtImg.lastGoodSource = raw.startsWith("/") ? ("file://" + raw) : raw;
                        }
                    }
                }
            }

            Item {
                anchors.left: cover.right
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                Item {
                    id: closeBtn
                    anchors.top: parent.top
                    anchors.right: parent.right
                    width: 24 
                    height: 24
                    z: 100
                    
                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: closeMouse.containsMouse ? Theme.text : Theme.unactive
                        font.pixelSize: 14
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        anchors.margins: -8 
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (root.target) {
                                root.target.popupOpen = false;
                            }
                        }
                    }
                }

                Row {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    spacing: 4 
                    z: 100
                    
                    Image {
                        id: appIcon
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20
                        height: 20
                        source: {
                            if (!root.activePlayer || !root.activePlayer.desktopEntry) return "";
                            return Quickshell.iconPath(root.activePlayer.desktopEntry, true);
                        }
                        visible: source.toString() !== "" && status === Image.Ready 
                    }
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            if (!root.activePlayer) return "";
                            if (root.activePlayer.identity) return root.activePlayer.identity;
                            if (root.activePlayer.desktopEntry) return root.activePlayer.desktopEntry;
                            const svc = root.activePlayer.dbusName || "";
                            const match = svc.match(/^org\.mpris\.MediaPlayer2\.([^.]+)/);
                            if (match) return match[1];
                            return "Unknown source";
                        }
                        color: Qt.rgba(255, 255, 255, 0.5)
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        visible: !appIcon.visible 
                    }
                }

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 24 
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        width: parent.width
                        text: root.activePlayer ? (root.activePlayer.trackTitle || "Unknown Track") : ""
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        width: parent.width
                        text: root.activePlayer ? (root.activePlayer.trackArtist || "") : ""
                        color: Qt.rgba(255, 255, 255, 0.7) 
                        font.family: Theme.fontFamily
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }

                    Item { width: 1; height: 4 } 

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 20
                        
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰒮" 
                            color: prevMouse.containsMouse ? Theme.text : Theme.unactive
                            font.family: Theme.fontFamilyAlt
                            font.pixelSize: 22
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            MouseArea {
                                id: prevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (root.activePlayer) root.activePlayer.previous()
                            }
                        }
                        
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 18
                            color: playMouse.containsMouse ? Qt.rgba(Theme.blue.r, Theme.blue.g, Theme.blue.b, 0.4) : Qt.rgba(255, 255, 255, 0.1)
                            border.color: playMouse.containsMouse ? Theme.blue : Qt.rgba(255, 255, 255, 0.2)
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 150 } }
                            Behavior on border.color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                text: root.activePlayer && root.activePlayer.isPlaying ? "󰏤" : "󰐊"
                                color: Theme.text 
                                font.family: Theme.fontFamilyAlt
                                font.pixelSize: 20
                            }
                            MouseArea {
                                id: playMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (root.activePlayer) root.activePlayer.togglePlaying()
                            }
                        }
                        
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰒭"
                            color: nextMouse.containsMouse ? Theme.text : Theme.unactive
                            font.family: Theme.fontFamilyAlt
                            font.pixelSize: 22
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            MouseArea {
                                id: nextMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (root.activePlayer) root.activePlayer.next()
                            }
                        }
                    }
                }
            }
        }
    }
}
