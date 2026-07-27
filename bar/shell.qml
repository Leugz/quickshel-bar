//@ pragma UseQApplication
import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "components"
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

    PowerMenu {
        id: globalPowerMenu
    }

    // --- Multi-Monitor Bar Setup ---
    Instantiator {
        model: Quickshell.screens

        delegate: Scope {
            id: screenScope
            required property var modelData

            NotificationCenter {
                id: notifCenter
                server: notifServer
                screen: screenScope.modelData
            }

            NotificationOverlay {
                server: notifServer
                screen: screenScope.modelData
                linkedCenter: notifCenter
            }

            PanelWindow {
                id: bar
                screen: screenScope.modelData

                property var centers: centerInstantiator
                property int screenIndex: index

                WlrLayershell.namespace: "quickshell:bar"

                anchors.top: true
                anchors.left: true
                anchors.right: true
                implicitHeight: Theme.barHeight
                color: "transparent"

                Item {
                    anchors.fill: parent

                    // ---- LEFT ----
                    BarGroup {
                        anchors {
                            left: parent.left;
                            leftMargin: 10;
                            top: parent.top;
                            topMargin: 5;
                            bottom: parent.bottom
                        }

                        LauncherButton {}
                        Workspaces {}
                        MprisWidget {}
                    }

                    // ---- CENTER ----
                    BarGroup {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            top: parent.top
                            topMargin: 5
                            bottom: parent.bottom
                        }

                        ClockCenter {}
                    }

                    // ---- RIGHT ----
                    BarGroup {
                        anchors {
                            right: parent.right;
                            rightMargin: 10;
                            top: parent.top;
                            topMargin: 5;
                            bottom: parent.bottom
                        }

                        TrayWidget {
                            parentWindow: bar
                        }
                        VolumeWidget {}
                        NetworkWidget {}
                        CalendarWidget {}
                        NotificationWidget {
                            server: notifServer
                            center: notifCenter
                        }
                        PowerButton {}
                    }
                }
            }
        }
    }
}
