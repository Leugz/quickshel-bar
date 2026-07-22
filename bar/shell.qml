//@ pragma UseQApplication
import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "widgets"
import "windows"

Scope {
    id: root

    NotificationServer {
        id: notifServer
        persistenceSupported: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true
    
        onNotification: notification => {
            notification.tracked = true
        }
    }

    // --- Global Fullscreen Windows ---
    PowerMenu {
        id: globalPowerMenu
    }

    NotificationOverlay {
        id: globalNotificationOverlay
        server: notifServer
    }

    NotificationCenter {
        id: globalNotificationCenter
        server: notifServer
    }

    // --- Multi-Monitor Bar Setup ---
    Instantiator {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: bar
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: Theme.barHeight
            color: "transparent"

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
                    
                    implicitWidth: leftRow.implicitWidth + 32
                    
                    RowLayout {
                        id: leftRow
                        anchors.centerIn: parent
                        spacing: 16

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
                    
                    implicitWidth: centerRow.implicitWidth + 32 
                    implicitHeight: parent.height - 10
                    
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
                    
                    implicitWidth: rightRow.implicitWidth + 32 
                    
                    RowLayout {
                        id: rightRow
                        anchors.centerIn: parent
                        spacing: 16

                        TrayWidget {
                            parentWindow: bar
                        }
                        VolumeWidget {}
                        NetworkWidget {}
                        CalendarWidget {}
                        NotificationWidget {
                            server: notifServer
                        }
                        PowerButton {}
                    }
                }
            }
        }
    }
}
