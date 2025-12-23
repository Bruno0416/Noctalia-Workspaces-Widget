// BarWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "."

WorkspacePill {
  id: root

  
  required property var pluginApi
  required property var screen
  required property string widgetId
  required property string section


  readonly property string monitorName: (screen && screen.name) ? screen.name : ""

  function getWorkspacesForMonitor(name) {
    const mapping = pluginApi?.pluginSettings?.monitors ?? {}
    const list = mapping[name]
    return Array.isArray(list) ? list : []
  }

  
  readonly property var wsModel: getWorkspacesForMonitor(monitorName)

  
  visible: wsModel.length > 0

  Repeater {
    model: root.wsModel

    delegate: Rectangle {
      required property int modelData
      readonly property int wsId: modelData
      readonly property bool isActive: Hyprland.focusedWorkspace?.id === wsId

      height: 18
      radius: 999

      
      width: isActive ? 56 : 18
      Behavior on width { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

      
      color: isActive ? Color.mPrimary : Color.mSurfaceVariant
      border.color: Color.mOutline
      border.width: 1
      opacity: isActive ? 1.0 : 0.85
      Behavior on color { ColorAnimation { duration: 160 } }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("workspace " + wsId)
      }

      
    }
  }
}
