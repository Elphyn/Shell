pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property int height: 30
  readonly property int padding: 8

  readonly property int workspaceSpacing: 8
  readonly property int workspacePadding: 6

  property var leftComponents: ["workspaces"]
  property var centerComponents: ["clock"]
  property var rightComponents: []
}
