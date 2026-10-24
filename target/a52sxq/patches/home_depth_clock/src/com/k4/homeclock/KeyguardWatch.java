package com.k4.homeclock;

import android.app.KeyguardManager;
import android.content.Context;
import android.util.Log;

/**
 * Keyguard state for the shared home+lock instance: its single surface is the lock screen, AOD and home wallpaper at
 * once, so its clock is drawn only while the keyguard is gone (and the display is ON, see DepthClock.showing).
 * Installed once per process, only when such a clock is about to be built (needs SUBSCRIBE_TO_KEYGUARD_LOCKED_STATE,
 * which SpriteWallpaper holds). On a change every engine with a clock redraws if its clock is now stale (shown <->
 * hidden), visible or not, so the next frame shown is already right.
 * Fail closed: {@link #locked} stays true until the listener is registered and the state was read; if that fails no
 * shared clock is built at all (HomeDepthClock.afterBuild) and the next build tries again.
 */
final class KeyguardWatch {
    static volatile boolean locked = true; // until known: never risk a clock on the lock screen
    private static boolean installed;

    private KeyguardWatch() {}

    /** True once the listener is registered and {@link #locked} follows the keyguard. */
    static synchronized boolean ensure(Context context) {
        if (installed) {
            return true;
        }
        try {
            KeyguardManager km = context.getSystemService(KeyguardManager.class);
            if (km == null) {
                Log.w(HomeDepthClock.TAG, "keyguard watch: no KeyguardManager");
                return false;
            }
            // listener first, state second: a change after the read reaches the listener, which waits for this lock
            km.addKeyguardLockedStateListener(context.getApplicationContext().getMainExecutor(),
                    new KeyguardManager.KeyguardLockedStateListener() {
                        @Override
                        public void onKeyguardLockedStateChanged(boolean isLocked) {
                            synchronized (KeyguardWatch.class) {
                                locked = isLocked;
                            }
                            for (EngineState st : HomeDepthClock.states()) {
                                st.redrawIfStale(isLocked ? "keyguard shown" : "keyguard gone", true);
                            }
                        }
                    });
            installed = true;
            locked = km.isKeyguardLocked();
            Log.i(HomeDepthClock.TAG, "keyguard watch installed, locked=" + locked);
            return true;
        } catch (Throwable t) {
            locked = true;
            Log.e(HomeDepthClock.TAG, "keyguard watch: not installed, the shared clock stays off", t);
            return installed;
        }
    }
}
