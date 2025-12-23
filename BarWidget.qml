// BarWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
  id: root

  required property var pluginApi
  required property var screen
  required property string widgetId
  required property string section

  
  readonly property string barPosition: Settings.data.bar.position
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"

  
  Row {
    id: content
    anchors.centerIn: parent
    spacing: Style.marginS    
  }

  
  implicitWidth:  isVertical
                  ? Style.capsuleHeight
                  : content.implicitWidth + Style.marginM * 2
  implicitHeight: isVertical
                  ? content.implicitHeight + Style.marginM * 2
                  : Style.capsuleHeight

  radius: height / 2

  color: Qt.rgba(Color.mSurface.r, Color.mSurface.g, Color.mSurface.b, 0.85)
  border.color: Color.mOutline
  border.width: 1

  readonly property var settings: pluginApi?.pluginSettings ?? {}
  readonly property var monitorMapping: settings.monitors ?? {}
  readonly property string monitorName: (screen && screen.name) ? screen.name : ""

  function getWorkspacesForMonitor(name) {
    const list = monitorMapping[name]
    return Array.isArray(list) ? list : []
  }

  readonly property var wsModel: getWorkspacesForMonitor(monitorName)
  visible: wsModel.length > 0

  Repeater {
    model: root.wsModel
    parent: content

    delegate: Rectangle {
      required property int modelData
      readonly property int wsId: modelData
      readonly property bool isActive: Hyprland.focusedWorkspace?.id === wsId

      height: Style.capsuleHeight - Style.marginS * 2
      radius: height / 2

      width: isActive ? 56 : height
      Behavior on width {
        NumberAnimation {
          duration: 220
          easing.type: Easing.OutCubic
        }
      }

      color: isActive ? Color.mPrimary : Color.mSurfaceVariant
      border.color: Color.mOutline
      border.width: 1
      opacity: isActive ? 1.0 : 0.85
      Behavior on color { ColorAnimation { duration: 160 } }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: Hyprland.dispatch("workspace " + wsId)
        onEntered: parent.opacity = 1.0
        onExited: parent.opacity = isActive ? 1.0 : 0.85
      }
    }
  }
}
