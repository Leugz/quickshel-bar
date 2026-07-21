import QtQuick
import Quickshell
import Quickshell.Wayland
import "../"

PanelWindow {
    id: root
    WlrLayershell.namespace: "quickshell:powermenu"
    visible: false
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    color: "transparent"

    Rectangle {
        id: dimBg
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.7)
        focus: true
        Keys.onEscapePressed: root.visible = false

        MouseArea {
            anchors.fill: parent
            onClicked: root.visible = false
        }

        Row {
            anchors.centerIn: parent
            spacing: 0 // wlogout's buttons sit flush against each other

            Repeater {
                model: [
                    { name: "Suspend", icon: "\uf28c", cmd: "systemctl suspend", accent: Theme.blue, edge: "left" },
                    { name: "Logout", icon: "\udb80\udf43", cmd: "hyprctl dispatch exit", accent: Theme.lightblue, edge: "none" },
                    { name: "Reboot", icon: "\uead2", cmd: "systemctl reboot", accent: Theme.mauve, edge: "none" },
                    { name: "Shutdown", icon: "\uf011", cmd: "systemctl poweroff", accent: Theme.maroon, edge: "right" }
                ]

                delegate: Rectangle {
                    id: actionButton
                    height: {
                        const base = mouseArea.containsMouse ? 0.28 : 0.24;
                        return Math.max(200, Math.min(400, dimBg.height * base));
                    }
                    width: Math.max(120, Math.min(220, dimBg.width * 0.11))
                    anchors.verticalCenter: parent.verticalCenter

                    color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 1, 1, 0.06)

                    topLeftRadius: modelData.edge === "left" ? 40 : (mouseArea.containsMouse ? 20 : 0)
                    bottomLeftRadius: modelData.edge === "left" ? 40 : (mouseArea.containsMouse ? 20 : 0)
                    topRightRadius: modelData.edge === "right" ? 40 : (mouseArea.containsMouse ? 20 : 0)
                    bottomRightRadius: modelData.edge === "right" ? 40 : (mouseArea.containsMouse ? 20 : 0)

                    Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on topLeftRadius { NumberAnimation { duration: 200 } }
                    Behavior on topRightRadius { NumberAnimation { duration: 200 } }
                    Behavior on bottomLeftRadius { NumberAnimation { duration: 200 } }
                    Behavior on bottomRightRadius { NumberAnimation { duration: 200 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.icon
                        font.family: Theme.fontFamilyAlt
                        font.pixelSize: mouseArea.containsMouse ? 68 : 52
                        color: mouseArea.containsMouse ? modelData.accent : "#ffffff"

                        Behavior on font.pixelSize { NumberAnimation { duration: 200 } }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.visible = false;
                            Quickshell.execDetached(["bash", "-c", modelData.cmd]);
                        }
                    }
                }
            }
        }
    }
}
