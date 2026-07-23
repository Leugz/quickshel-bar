import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris
import "../"

PopupWindow {
    id: root

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
        
        radius: 12
        color: Theme.base
        border.color: Theme.surface2
        border.width: 1
        
        HoverHandler { id: hoverHandler }

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
                color: Theme.crust
                
                Text {
                    anchors.centerIn: parent
                    text: "󰎆"
                    font.family: Theme.fontFamilyAlt
                    font.pixelSize: 32
                    color: Theme.surface2
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

                    onStatusChanged: console.log("Cover art status:", status, source)
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
                    }
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
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
                        color: Theme.surface2
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
                        color: Theme.unactive
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
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
                            color: Theme.text
                            font.family: Theme.fontFamilyAlt
                            font.pixelSize: 22
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (root.activePlayer) root.activePlayer.previous()
                            }
                        }

                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            color: Theme.mauve 
                            
                            Text {
                                anchors.centerIn: parent
                                text: root.activePlayer && root.activePlayer.isPlaying ? "" : ""
                                color: Theme.crust 
                                font.family: Theme.fontFamilyAlt
                                font.pixelSize: 20
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (root.activePlayer) root.activePlayer.togglePlaying()
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "󰒭" 
                            color: Theme.text
                            font.family: Theme.fontFamilyAlt
                            font.pixelSize: 22
                            MouseArea {
                                anchors.fill: parent
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
