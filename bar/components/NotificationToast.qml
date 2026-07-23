import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../"

Rectangle {
    id: root
    property var notification: typeof modelData !== "undefined" ? modelData : (typeof model !== "undefined" ? model.notification : null)
    
    width: 320
    implicitHeight: layout.implicitHeight + 24
    
    color: Qt.rgba(15/255, 15/255, 25/255, 0.4)
    border.color: hoverHandler.hovered ? Qt.rgba(255, 255, 255, 0.15) : Qt.rgba(255, 255, 255, 0.05)
    border.width: 1
    radius: Theme.moduleRadius
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

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        Image {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            source: root.notification && root.notification.appIcon ? "image://icon/" + root.notification.appIcon : "image://icon/dialog-information"
            fillMode: Image.PreserveAspectFit
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    Layout.fillWidth: true
                    text: root.notification ? (root.notification.summary || "Notification") : "Loading..."
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 15
                    font.bold: true
                    elide: Text.ElideRight
                }
                
                Text {
                    text: ""
                    color: closeMouse.containsMouse ? Theme.text : Theme.unactive
                    font.pixelSize: 14
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        anchors.margins: -8
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if(root.notification) root.notification.dismiss()
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.notification ? (root.notification.body || "") : ""
                color: Qt.rgba(255, 255, 255, 0.7)
                font.family: Theme.fontFamily
                font.pixelSize: 13
                lineHeight: 1.2
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                visible: text.length > 0
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1 
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!root.notification) return;

            let defaultInvoked = false;
            
            if (root.notification.actions) {
                for (let i = 0; i < root.notification.actions.length; i++) {
                    let action = root.notification.actions[i];
                    
                    if (action.identifier === "default") {
                        action.invoke(); 
                        defaultInvoked = true;
                        break;
                    }
                }
            }
            
            if (!defaultInvoked) {
                root.notification.dismiss();
            }
        }
    }
}
