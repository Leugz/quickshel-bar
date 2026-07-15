import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

// Migrated from waybar: layer "top", height 37, spacing 5.
// modules-left:   custom/launcher, hyprland/workspaces, mpris
// modules-center: clock#simpleclock
// modules-right:  tray, pulseaudio, network, clock, custom/notification, custom/power
PanelWindow {
    id: bar
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: Theme.barHeight
    color: "transparent"

    // container that holds the three independently-positioned module groups,
    // mirroring .modules-left/.modules-center/.modules-right in the old CSS
    Item {
        anchors.fill: parent

        // ---- LEFT ----
        Rectangle {
            id: leftBg
            color: Theme.crust
            radius: Theme.moduleRadius
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            implicitWidth: leftRow.implicitWidth + 20

            RowLayout {
                id: leftRow
                anchors.centerIn: parent
                spacing: Theme.barSpacing

                LauncherButton {}
                Workspaces {}
                MprisWidget {}
            }
        }

        // ---- CENTER ----
        Rectangle {
            id: centerBg
            color: Theme.crust
            radius: Theme.moduleRadius
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 2 // account for the 5px top margin like the side modules
            implicitWidth: centerRow.implicitWidth + 20
            implicitHeight: parent.height - 5

            RowLayout {
                id: centerRow
                anchors.centerIn: parent

                ClockCenter {}
            }
        }

        // ---- RIGHT ----
        Rectangle {
            id: rightBg
            color: Theme.crust
            radius: Theme.moduleRadius
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.bottom: parent.bottom
            implicitWidth: rightRow.implicitWidth + 20

            RowLayout {
                id: rightRow
                anchors.centerIn: parent
                spacing: Theme.barSpacing

                TrayWidget {}
                VolumeWidget {}
                NetworkWidget {}
                ClockRight {}
                NotificationWidget {}
                PowerButton {}
            }
        }
    }
}
