import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
  id: root

  
  default property alias content: contentRow.data

  
  implicitHeight: 28
  implicitWidth: contentRow.implicitWidth + 16

  radius: height / 2

  color: Qt.rgba(Color.mSurface.r, Color.mSurface.g, Color.mSurface.b, 0.85)
  border.color: Color.mOutline
  border.width: 1

  Row {
    id: contentRow
    anchors.centerIn: parent
    spacing: 6
  }
}
