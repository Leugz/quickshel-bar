import QtQuick
import QtQuick.Layouts
import Quickshell
import "../"

PopupWindow {
    id: root
    
    property bool shown: false
    property date viewDate: new Date()
    property Item target: null
    
    property alias isHovered: hoverHandler.hovered 
    
    visible: shown || bg.opacity > 0
    color: "transparent"
    implicitWidth: bg.width
    implicitHeight: bg.implicitHeight
    
    anchor {
        item: root.target
        edges: Edges.Bottom
        gravity: Edges.Bottom 
        margins.top: 6
    }

    function buildGrid() {
        const y = viewDate.getFullYear();
        const m = viewDate.getMonth();
        const firstDay = new Date(y, m, 1);
        const startDow = firstDay.getDay(); 
        
        let daysArr = [];
        const today = new Date();
        
        const prevMonthTotal = new Date(y, m, 0).getDate();
        for (let i = startDow - 1; i >= 0; i--) {
            daysArr.push({
                dayText: String(prevMonthTotal - i),
                isCurrentMonth: false,
                isToday: false
            });
        }
        
        const totalDays = new Date(y, m + 1, 0).getDate();
        for (let i = 1; i <= totalDays; i++) {
            const isT = y === today.getFullYear() && m === today.getMonth() && i === today.getDate();
            daysArr.push({
                dayText: String(i),
                isCurrentMonth: true,
                isToday: isT
            });
        }
        
        let nextDayNum = 1;
        while (daysArr.length < 42) {
            daysArr.push({
                dayText: String(nextDayNum++),
                isCurrentMonth: false,
                isToday: false
            });
        }
        
        return daysArr;
    }
    
    property var days: buildGrid()
    onViewDateChanged: days = buildGrid()

    HoverHandler { id: hoverHandler } 

    Rectangle {
        id: bg
        width: mainCol.implicitWidth + 24
        
        // --- Drawer Slide Animation Fix ---
        // Wayland allows 1 pixel, but bans 0. This gives us the exact Notification Center slide!
        implicitHeight: root.shown ? mainCol.implicitHeight + 24 : 1
        clip: true 
        
        opacity: root.shown ? 1.0 : 0.0
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on implicitHeight { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }
        
        // Deep Glass Base
        color: Qt.rgba(15/255, 15/255, 25/255, 0.4)
        border.color: hoverHandler.hovered ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.05)
        border.width: 1
        radius: Theme.moduleRadius + 4
        
        Behavior on border.color { ColorAnimation { duration: 200; easing.type: Easing.OutQuart } }

        // Indigo Glow Overlay
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

        WheelHandler {
            onWheel: event => {
                const d = root.viewDate;
                const delta = event.angleDelta.y > 0 ? -1 : 1;
                root.viewDate = new Date(d.getFullYear(), d.getMonth() + delta, 1);
            }
        }
        
        ColumnLayout {
            id: mainCol
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 12
            spacing: 12 

            // Header Row
            RowLayout {
                Layout.fillWidth: true
                
                Row {
                    spacing: 4
                    Text {
                        text: Qt.formatDateTime(root.viewDate, "MMMM")
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 14 
                        font.bold: true
                    }
                    Text {
                        text: Qt.formatDateTime(root.viewDate, "yyyy")
                        color: Theme.blue
                        font.family: Theme.fontFamily
                        font.pixelSize: 14 
                        font.bold: true
                    }
                }

                Item { Layout.fillWidth: true } 

                Row {
                    spacing: 10
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "❮" 
                        color: prevMouse.containsMouse ? Theme.mauve : Theme.unactive
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() - 1, 1)
                        }
                    }
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "TODAY"
                        color: todayMouse.containsMouse ? Theme.mauve : Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: 10
                        font.bold: true
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MouseArea {
                            id: todayMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.viewDate = new Date()
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "❯"
                        color: nextMouse.containsMouse ? Theme.mauve : Theme.unactive
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.bold: true
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            anchors.margins: -6
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
                        }
                    }
                }
            }

            // Compact Grid
            GridLayout {
                columns: 7
                columnSpacing: 10 
                rowSpacing: 4     
                
                Repeater {
                    model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                    delegate: Text {
                        text: modelData
                        color: Theme.lightblue 
                        font.family: Theme.fontFamily
                        font.pixelSize: 11
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                Repeater {
                    model: root.days
                    delegate: Item {
                        implicitWidth: 18 
                        implicitHeight: 18 
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData.dayText
                            font.family: Theme.fontFamily
                            font.pixelSize: 12
                            font.bold: modelData.isCurrentMonth
                            color: {
                                if (modelData.isToday) return Theme.mauve; 
                                if (modelData.isCurrentMonth) return Theme.text;
                                return Theme.surface2; 
                            }
                        }
                    }
                }
            }
        }
    }
}
