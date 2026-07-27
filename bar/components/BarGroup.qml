import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
  default property alias content: row.data
  
  color: Theme.crust
  radius: Theme.moduleRadius
  implicitWidth: row.implicitWidth + 32
  
  RowLayout {
    id: row
    anchors.centerIn: parent
    spacing: 16
  }
}
