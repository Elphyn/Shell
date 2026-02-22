import Quickshell
import QtQuick
import "modules/bar"

ShellRoot {
  id: root

  property var barWindow: null

  Bar {
    Component.onCompleted: root.barWindow = this
  }
}
