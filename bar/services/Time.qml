pragma Singleton
import Quickshell

Singleton {
    readonly property SystemClock clock: SystemClock { precision: SystemClock.Seconds }
    readonly property date now: clock.date
}
