import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property bool shown: false
    property date viewDate: new Date()

    visible: shown
    z: 1000
    radius: 10
    color: Theme.base
    border.color: Theme.surface2
    border.width: 1
    implicitWidth: grid.implicitWidth + 24
    implicitHeight: content.implicitHeight + 24

    anchors.top: parent.bottom
    anchors.topMargin: 6
    anchors.right: parent.right

    function daysInMonth(y, m) { return new Date(y, m + 1, 0).getDate(); }
    function isSameDay(a, b) {
        return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
    }
    // rough (non-ISO) week-of-year number, good enough for a bar tooltip
    function weekNumber(d) {
        const onejan = new Date(d.getFullYear(), 0, 1);
        return Math.ceil((((d - onejan) / 86400000) + onejan.getDay() + 1) / 7);
    }

    function buildWeeks() {
        const y = viewDate.getFullYear();
        const m = viewDate.getMonth();
        const firstDow = new Date(y, m, 1).getDay(); // 0=Sun
        const totalDays = daysInMonth(y, m);
        const weeks = [];
        let week = [];
        // leading blanks
        for (let i = 0; i < firstDow; i++) week.push(null);
        for (let day = 1; day <= totalDays; day++) {
            week.push(new Date(y, m, day));
            if (week.length === 7) { weeks.push(week); week = []; }
        }
        if (week.length > 0) {
            while (week.length < 7) week.push(null);
            weeks.push(week);
        }
        return weeks;
    }

    property var weeks: buildWeeks()
    onViewDateChanged: weeks = buildWeeks()

    MouseArea {
        // waybar: "on-scroll": 1 -> change month by one per scroll notch
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
    }
    WheelHandler {
        onWheel: event => {
            const d = root.viewDate;
            const delta = event.angleDelta.y > 0 ? -1 : 1;
            root.viewDate = new Date(d.getFullYear(), d.getMonth() + delta, 1);
        }
    }

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        spacing: 6

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDateTime(root.viewDate, "MMMM yyyy")
            color: Theme.text
            font.bold: true
            font.pixelSize: 14
        }

        GridLayout {
            id: grid
            columns: 8
            rowSpacing: 4
            columnSpacing: 10

            Text { text: "W"; color: Theme.green; font.bold: true; font.pixelSize: 11 }
            Repeater {
                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                delegate: Text {
                    required property string modelData
                    text: modelData
                    color: Theme.yellow
                    font.bold: true
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Repeater {
                model: root.weeks
                delegate: Item {
                    required property var modelData
                    required property int index
                    Layout.columnSpan: 8
                    Layout.fillWidth: true
                    implicitHeight: weekRow.implicitHeight

                    RowLayout {
                        id: weekRow
                        anchors.fill: parent
                        spacing: 10

                        Text {
                            text: "W" + root.weekNumber(modelData.find(d => d !== null) || root.viewDate)
                            color: Theme.green
                            font.bold: true
                            font.pixelSize: 11
                            Layout.preferredWidth: 18
                        }

                        Repeater {
                            model: modelData
                            delegate: Text {
                                required property var modelData
                                Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 18
                                text: modelData ? modelData.getDate() : ""
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 12
                                font.underline: modelData && root.isSameDay(modelData, new Date())
                                font.bold: modelData && root.isSameDay(modelData, new Date())
                                color: modelData && root.isSameDay(modelData, new Date()) ? Theme.red : Theme.text
                            }
                        }
                    }
                }
            }
        }
    }
}
