package com.android.server.soundtrigger_middleware;
public final class SoundTriggerHalEnforcer {
    public SoundTriggerHalWatchdog mUnderlying;
    public final void reboot() { throw new RuntimeException(); }
}
