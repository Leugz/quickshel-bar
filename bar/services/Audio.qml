pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink !== null && sink.ready
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false

    function toggleMute() {
        if (ready) sink.audio.muted = !sink.audio.muted;
    }

    function changeVolume(deltaPercent) {
        if (!ready) return;
        let v = sink.audio.volume + deltaPercent / 100;
        sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
