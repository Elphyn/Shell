import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../.." as Root

PanelWindow {
  id: window

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: Root.BarConfig.height
  color: Root.Theme.bg

  property var monitor: Hyprland.focusedMonitor

  property var componentMap: ({
    "workspaces": workspacesComponent,
    "clock": clockComponent
  })

  Component {
    id: workspacesComponent

    Row {
      spacing: Root.BarConfig.workspaceSpacing

      Repeater {
        model: Hyprland.workspaces.values.filter(ws => ws.id >= 1 && ws.monitor === window.monitor)

        Text {
          required property var modelData
          text: modelData.id
          color: modelData.active ? Root.Theme.text : Root.Theme.textMuted
          font.bold: modelData.active
          leftPadding: Root.BarConfig.workspacePadding
          rightPadding: Root.BarConfig.workspacePadding

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onEntered: parent.color = Root.Theme.text
            onExited: parent.color = modelData.active ? Root.Theme.text : Root.Theme.textMuted
            onClicked: modelData.activate()
          }
        }
      }
    }
  }

  Component {
    id: clockComponent

    Text {
      text: Root.Time.time
      color: Root.Theme.text
    }
  }

  Row {
    id: leftSection

    anchors.left: parent.left
    anchors.leftMargin: Root.BarConfig.padding
    anchors.verticalCenter: parent.verticalCenter
    spacing: Root.BarConfig.padding

    Repeater {
      model: Root.BarConfig.leftComponents

      Loader {
        sourceComponent: componentMap[modelData]
      }
    }
  }

  Row {
    id: centerSection

    anchors.centerIn: parent
    spacing: Root.BarConfig.padding

    Repeater {
      model: Root.BarConfig.centerComponents

      Loader {
        sourceComponent: componentMap[modelData]
      }
    }
  }

  Row {
    id: rightSection

    anchors.right: parent.right
    anchors.rightMargin: Root.BarConfig.padding
    anchors.verticalCenter: parent.verticalCenter
    spacing: Root.BarConfig.padding

    Repeater {
      model: Root.BarConfig.rightComponents

      Loader {
        sourceComponent: componentMap[modelData]
      }
    }
  }
}
