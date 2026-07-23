import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../"

Rectangle {
    id: root
    
    // Safely catches the notification whether Quickshell exposes it as 'modelData' or 'model.notification'
    property var notification: typeof modelData !== "undefined" ? modelData : (typeof model !== "undefined" ? model.notification : null)
    
    width: 320
    implicitHeight: layout.implicitHeight + 24
    
    // color: Qt.rgba(30/255, 30/255, 46/255, 0.7)
    color: hoverHandler.hovered ? Qt.rgba(30/255, 30/255, 46/255, 0.9) : Qt.rgba(30/255, 30/255, 46/255, 0.6) 
    border.color: Qt.rgba(255, 255, 255, 0.1)
    border.width: 1
    radius: Theme.moduleRadius
    clip: true
    Behavior on color { ColorAnimation { duration: 150 } }
    HoverHandler { id: hoverHandler }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Image {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            source: root.notification && root.notification.appIcon ? "image://icon/" + root.notification.appIcon : "image://icon/dialog-information"
            fillMode: Image.PreserveAspectFit
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    Layout.fillWidth: true
                    text: root.notification ? (root.notification.summary || "Notification") : "Loading..."
                    color: Theme.text
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight
                }
                
                Text {
                    text: ""
                    color: Theme.unactive
                    font.pixelSize: 12
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -5
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // FIXED: Now uses .dismiss() instead of .close()
                            if(root.notification) root.notification.dismiss()
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.notification ? (root.notification.body || "") : ""
                color: Theme.unactive
                font.family: Theme.fontFamily
                font.pixelSize: 13
                wrapMode: Text.Wrap
                maximumLineCount: 3
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
            if (root.notification) {
                // Safely invokes the default action and then dismisses the notification
                if (typeof root.notification.invokeDefaultAction === "function") {
                    root.notification.invokeDefaultAction();
                }
                if (typeof root.notification.dismiss === "function") {
                    root.notification.dismiss();
                }
            }
        }
    }
}
