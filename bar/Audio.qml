pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

// Wraps the default audio sink so the rest of the bar can just read
// Audio.volume / Audio.muted without touching Pipewire directly.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink !== null && sink.ready
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false

    function toggleMute() {
        if (ready) sink.audio.muted = !sink.audio.muted;
    }

    // step matches waybar's "scroll-step": 5
    function changeVolume(deltaPercent) {
        if (!ready) return;
        let v = sink.audio.volume + deltaPercent / 100;
        sink.audio.volume = Math.max(0, Math.min(1, v));
    }

    // Binds the sink so Pipewire actually reports live volume/mute changes.
    PwObjectTracker {
        objects: [root.sink]
    }
}
