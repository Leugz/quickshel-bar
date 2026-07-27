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

    function setVolume(v) {
        if (!ready) return;
        sink.audio.volume = Math.max(0, Math.min(1, v));
    }
    
    readonly property var sinks: Pipewire.nodes.values.filter(n => n.isSink && !n.isStream && n.audio)
    
    function setSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}
