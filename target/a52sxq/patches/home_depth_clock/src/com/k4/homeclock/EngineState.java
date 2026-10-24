package com.k4.homeclock;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.lang.ref.WeakReference;

/**
 * Per home-capable LayeredEngine (which & 1). Two receivers:
 *  - reload ({@link HomeDepthClock#ACTION_RELOAD}, sender must hold WRITE_SECURE_SETTINGS): registered for the
 *    engine's lifetime so the Settings switch can turn the clock on. It queues a check ({@link ReloadPolicy}) that
 *    rebuilds the sub engine only when its clock is missing, unwanted or built from other settings than the current
 *    ones (each build records what it read, HomeDepthClock.built). The editor's RELOAD (EXTRA_WALLPAPER_PENDING)
 *    comes before its wallpaper apply, which normally replaces this engine in-process (reapply: the old sub engine is
 *    destroyed, so its check never runs, then the new one is built from the settings written by then); the check runs
 *    when this engine is shown again (the editor has closed, the apply is done) or after 6 s, whichever comes first,
 *    but only while it is really on screen: visible, display ON and, for an engine that is also the lock screen and
 *    has a gated clock, the keyguard gone. Until then it stays pending (no rebuild during the AOD, the screen-on
 *    animation or on the lock screen): a visible engine looks again every 6 s (10 times at most), and becoming
 *    visible again or the keyguard going away re-arm it. A Settings RELOAD meanwhile keeps the editor's terms.
 *    A new engine elsewhere (a preview, another connection) no longer cancels it.
 *  - minute ticker (TIME_TICK, TIME_SET, TIMEZONE_CHANGED, LOCALE_CHANGED): registered only while the engine has a
 *    clock and is visible. ACTION_TIME_TICK is not a wakeup broadcast, so nothing here wakes the CPU or draws per
 *    frame; a redraw happens only when what the clock should show differs from what is on screen. The same tick asks
 *    again for weather the clock should show but has not got yet (AodHost.retryWeather, at most once a minute).
 */
final class EngineState {
    private final WeakReference<f3.a> engine;
    private final Context context;
    private final Handler main = new Handler(Looper.getMainLooper());
    private boolean visible;
    private boolean tickerOn;
    private boolean reloadOn;
    /** A RELOAD arrived and its check has not run yet. */
    private boolean reloadPending;
    /** That RELOAD (or one before it, still pending) came from the editor: check only while on screen. */
    private boolean editorPending;
    /** Looks at a pending editor check that found the engine not on screen (log once, poll at most 10 times). */
    private int deferrals;

    private final Runnable reload = new Runnable() {
        @Override
        public void run() {
            f3.a e = engine.get();
            if (e == null) {
                reloadPending = false;
                return;
            }
            try {
                int which = e.getWhich();
                if (editorPending && (which & 1) != 0) {
                    Object state = e.getDisplayState();
                    boolean on = state instanceof Enum && "ON".equals(((Enum<?>) state).name());
                    boolean keyguard = (which & 2) != 0 && HomeDepthClock.clockOf(e) != null && KeyguardWatch.locked;
                    if (!visible || !on || keyguard) {
                        if (deferrals++ == 0) {
                            Log.i(HomeDepthClock.TAG, "reload from the editor (which=" + which + "): not on screen (visible="
                                    + visible + ", display=" + state + ", keyguard=" + keyguard + "), checked once it is");
                        }
                        if (visible && deferrals <= 10) {
                            main.postDelayed(this, ReloadPolicy.WALLPAPER_WAIT_MS);
                        }
                        return; // still pending: setVisible(true) / the keyguard going away run it again
                    }
                }
                reloadPending = false;
                editorPending = false;
                deferrals = 0;
                check(e);
            } catch (Throwable t) {
                reloadPending = false;
                editorPending = false;
                Log.e(HomeDepthClock.TAG, "reload", t);
            }
        }
    };

    private void check(f3.a e) {
        int which = e.getWhich();
        boolean enabled = HomeDepthClock.enabled();
        boolean shared = HomeDepthClock.sharedEnabled();
        if ((which & 1) == 0) {
            // no longer a home screen engine (a shared wallpaper left on the lock screen after a new home one: 7 -> 6,
            // LayeredEngine keeps the engine): its gated clock is never drawn again, and a rebuild here would only
            // decode the lock screen wallpaper again as the lock screen or the AOD shows it
            logNothingToDo(which, enabled, shared);
            return;
        }
        h3.a p = e.g;
        // the shared clock only ever goes into Samsung's BgCachableLayeredPresenter (h3.b, HomeDepthClock.afterBuild);
        // a shared engine with another presenter would come back without a clock however often it is rebuilt
        boolean want = enabled && ((which & 3) == 1 || (shared && (which & 3) == 3 && p != null && p.getClass() == h3.b.class));
        boolean have = HomeDepthClock.clockOf(e) != null || p instanceof HomeClockPresenter;
        String built = have && p != null ? HomeDepthClock.builtFrom(p) : null;
        String now = want && have ? HomeDepthClock.fingerprint(context) : null;
        switch (ReloadPolicy.decide(want, have, built, now)) {
            case NONE:
                logNothingToDo(which, enabled, shared);
                return;
            case KEEP:
                Log.i(HomeDepthClock.TAG, "reload (which=" + which + "): clock already built from the current settings, no rebuild");
                return;
            default:
                Log.i(HomeDepthClock.TAG, "reload (which=" + which + ", clock " + have + " -> " + want
                        + (want && have ? ", " + (built == null ? "build settings unknown" : "settings changed since the build") : "")
                        + "): rebuilding the engine");
                e.stopSelf();
        }
    }

    private String lastSkip;
    private long lastSkipAt;

    /** Why a reload left this engine alone: once per reason, again after a minute (a Settings toggle can repeat it). */
    private void logNothingToDo(int which, boolean enabled, boolean shared) {
        String why = !enabled ? "switch off"
                : (which & 1) == 0 ? "not a home screen wallpaper"
                : (which & 3) == 3 && !shared ? "home+lock wallpaper, " + HomeDepthClock.PROP + "_shared=0"
                : "no clock for this wallpaper";
        String key = which + "/" + enabled + "/" + shared;
        long now = android.os.SystemClock.elapsedRealtime();
        if (key.equals(lastSkip) && now - lastSkipAt < 60_000) {
            return;
        }
        lastSkip = key;
        lastSkipAt = now;
        Log.i(HomeDepthClock.TAG, "reload (which=" + which + ", enabled=" + enabled + ", shared=" + shared
                + "): no clock wanted or shown, nothing to rebuild (" + why + ")");
    }

    private final BroadcastReceiver reloadReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context c, Intent intent) {
            main.removeCallbacks(reload);
            boolean wallpaperPending = intent.getBooleanExtra(HomeDepthClock.EXTRA_WALLPAPER_PENDING, false);
            reloadPending = true;
            deferrals = 0;
            // a Settings RELOAD while the editor's check waits keeps the editor's terms (its apply may still come)
            wallpaperPending |= editorPending;
            editorPending = wallpaperPending;
            if (wallpaperPending) {
                f3.a e = engine.get();
                Log.i(HomeDepthClock.TAG, "reload from the editor (which=" + (e == null ? -1 : e.getWhich())
                        + "): checked when shown, or in " + ReloadPolicy.WALLPAPER_WAIT_MS + " ms");
            }
            main.postDelayed(reload, ReloadPolicy.checkDelay(wallpaperPending));
        }
    };
    private final BroadcastReceiver tickReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context c, Intent intent) {
            redrawIfStale(intent.getAction(), false);
            retryWeather(intent.getAction());
        }
    };

    EngineState(f3.a e) {
        engine = new WeakReference<>(e);
        context = e.getAppContext().getApplicationContext();
    }

    void start() {
        IntentFilter f = new IntentFilter(HomeDepthClock.ACTION_RELOAD);
        context.registerReceiver(reloadReceiver, f, HomeDepthClock.RELOAD_PERMISSION, null, Context.RECEIVER_EXPORTED);
        reloadOn = true;
    }

    void stop() {
        main.removeCallbacks(reload);
        reloadPending = false;
        editorPending = false;
        setVisible(false);
        if (reloadOn) {
            unregister(reloadReceiver);
            reloadOn = false;
        }
    }

    void setVisible(boolean v) {
        visible = v;
        if (v && reloadPending) {
            // shown after a RELOAD (the editor closed): check now, posted so a rebuild never runs inside the engine's
            // own visibility dispatch; a deferred editor check gets its polls back, its log line stays said
            main.removeCallbacks(reload);
            main.post(reload);
            deferrals = Math.min(deferrals, 1);
        }
        f3.a e = engine.get();
        boolean want = v && e != null && HomeDepthClock.clockOf(e) != null;
        if (want && !tickerOn) {
            IntentFilter f = new IntentFilter(Intent.ACTION_TIME_TICK);
            f.addAction(Intent.ACTION_TIME_CHANGED); // also sent for a 12/24 h switch
            f.addAction(Intent.ACTION_TIMEZONE_CHANGED);
            f.addAction(Intent.ACTION_LOCALE_CHANGED);
            context.registerReceiver(tickReceiver, f, Context.RECEIVER_NOT_EXPORTED);
            tickerOn = true;
        } else if (!want && tickerOn) {
            unregister(tickReceiver);
            tickerOn = false;
        }
        if (want) {
            redrawIfStale("visible", false);
            retryWeather("visible");
        }
    }

    /** A visible clock's weather is still missing: ask again (rate-limited in AodHost, no wakeups of its own). */
    private void retryWeather(String why) {
        try {
            f3.a e = engine.get();
            DepthClock clock = e == null || !visible ? null : HomeDepthClock.clockOf(e);
            if (clock != null) {
                clock.retryWeather(why);
            }
        } catch (Throwable t) {
            Log.e(HomeDepthClock.TAG, "weather retry", t);
        }
    }

    void redrawIfStale(String why) {
        redrawIfStale(why, false);
    }

    /** anyVisibility: also draw while hidden (keyguard changes, so the next frame shown is already right). */
    void redrawIfStale(String why, boolean anyVisibility) {
        if (anyVisibility && reloadPending && !KeyguardWatch.locked) {
            // keyguard gone (KeyguardWatch): a pending editor check deferred on the lock screen can run now
            main.removeCallbacks(reload);
            main.post(reload);
        }
        try {
            f3.a e = engine.get();
            DepthClock clock = e == null ? null : HomeDepthClock.clockOf(e);
            if (clock == null || !(visible || anyVisibility)) {
                return;
            }
            String now = clock.expected();
            if (now.equals(clock.lastDrawn)) {
                return;
            }
            Log.d(HomeDepthClock.TAG, "redraw (" + why + "): '" + clock.lastDrawn + "' -> '" + now + "'");
            e.b(e.getSurfaceHolder());
        } catch (Throwable t) {
            Log.e(HomeDepthClock.TAG, "redraw", t);
        }
    }

    private void unregister(BroadcastReceiver r) {
        try {
            context.unregisterReceiver(r);
        } catch (IllegalArgumentException ignored) {
        }
    }
}
