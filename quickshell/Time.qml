pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property string time: Qt.formatDateTime(clock.date, "ddd HH:mm - MMM d")

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
