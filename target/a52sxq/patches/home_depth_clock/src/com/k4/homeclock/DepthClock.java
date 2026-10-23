package com.k4.homeclock;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.text.format.DateFormat;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * A clock layer between the background and the cut-out subject: {@link AodClockNode} (Samsung's own AOD lock-screen
 * clock) or {@link ClockNode} (plain text, the fallback). Holds what both share: the gating of the shared home+lock
 * instance, the background zoom reference and what was drawn last (EngineState's once-a-minute staleness check).
 */
abstract class DepthClock extends i3.j {
    /** Background node whose screen on/off zoom the clock follows (shared home+lock instance), or null. */
    final i3.c scaleRef;
    /** The presenter whose layer list holds this clock (weak: the presenter holds the clock), to find its engine. */
    private final java.lang.ref.WeakReference<h3.a> owner;
    /**
     * The shared home+lock instance (one surface for lock screen, AOD and home): draw only while the keyguard is gone,
     * the display is ON, the engine still shows the home screen and is not a preview. Anything unknown: not drawn.
     */
    final boolean gated;
    volatile String lastDrawn = "";

    DepthClock(Context context, String name, i3.c scaleRef, h3.a owner, boolean gated) {
        super(context, name);
        this.scaleRef = scaleRef;
        this.owner = new java.lang.ref.WeakReference<>(owner);
        this.gated = gated;
    }

    /** The minute (and whatever else changes the picture) a draw now would show. */
    String text() {
        boolean is24 = DateFormat.is24HourFormat(a);
        return new SimpleDateFormat(is24 ? "HH:mm" : "h:mm", Locale.getDefault()).format(new Date());
    }

    /**
     * Whether a draw now shows the clock.
     * Home-only presenter (HomeClockPresenter, not gated): its wallpaper is never the lock screen's, and LayeredEngine
     * rebuilds the engine at once when it becomes one (onWhichChanged 1 -> 3: stopSelf); until that has happened, and for
     * any engine that no longer shows the home screen alone, nothing is drawn. An engine not found keeps the clock (the
     * presenter is only ever made for a home-only engine).
     * Gated (shared home+lock instance): only while the keyguard is known to be gone (KeyguardWatch, locked until
     * known), the engine is found, is no preview (wallpaper picker / editor / Wallpaper and style previews have no
     * keyguard to go by and may show the lock screen), still has the home flag and its display state is ON (not NONE,
     * OFF or AOD, which also covers the screen on/off animations). Any failure: not drawn.
     */
    boolean showing() {
        try {
            h3.a p = owner.get();
            f3.a e = p == null ? null : HomeDepthClock.engineOf(p);
            if (!gated) {
                return e == null || (e.getWhich() & 3) == 1;
            }
            if (KeyguardWatch.locked || e == null || e.isPreview() || (e.getWhich() & 1) == 0) {
                return false;
            }
            Object state = e.getDisplayState();
            return state instanceof Enum && "ON".equals(((Enum<?>) state).name());
        } catch (Throwable t) {
            return !gated;
        }
    }

    /** What a draw now would put on screen ("" = nothing). */
    String expected() {
        return showing() ? text() : "";
    }

    /** Minute tick / shown while visible: fetch weather again if this clock shows weather and has none yet. */
    void retryWeather(String why) {
    }

    /** The presenter is gone (or rebuilt): drop what this clock holds outside its own fields. */
    void release() {
    }

    /** Background zoom of the shared instance (1 = none). */
    float zoom() {
        float s = scaleRef != null ? scaleRef.e : 1f;
        return s > 0f ? s : 1f;
    }

    /** Mean relative luminance (0..1) of the wallpaper under l,t,r,b, sampled on a 24x8 grid; -1 if unknown. */
    static float luminance(Bitmap bm, int l, int t, int r, int b) {
        if (bm == null || bm.isRecycled() || bm.getConfig() == Bitmap.Config.HARDWARE) {
            return -1f;
        }
        l = Math.max(0, l);
        t = Math.max(0, t);
        r = Math.min(bm.getWidth() - 1, r);
        b = Math.min(bm.getHeight() - 1, b);
        if (r <= l || b <= t) {
            return -1f;
        }
        float sum = 0;
        int n = 0;
        for (int iy = 0; iy < 8; iy++) {
            int y = t + (b - t) * iy / 7;
            for (int ix = 0; ix < 24; ix++) {
                int p = bm.getPixel(l + (r - l) * ix / 23, y);
                sum += (0.2126f * Color.red(p) + 0.7152f * Color.green(p) + 0.0722f * Color.blue(p)) / 255f;
                n++;
            }
        }
        return sum / n;
    }

    /** Mean colour of the wallpaper under l,t,r,b (opaque), or 0 if unknown. */
    static int meanColor(Bitmap bm, int l, int t, int r, int b) {
        if (bm == null || bm.isRecycled() || bm.getConfig() == Bitmap.Config.HARDWARE) {
            return 0;
        }
        l = Math.max(0, l);
        t = Math.max(0, t);
        r = Math.min(bm.getWidth() - 1, r);
        b = Math.min(bm.getHeight() - 1, b);
        if (r <= l || b <= t) {
            return 0;
        }
        long rs = 0, gs = 0, bs = 0;
        int n = 0;
        for (int iy = 0; iy < 8; iy++) {
            int y = t + (b - t) * iy / 7;
            for (int ix = 0; ix < 24; ix++) {
                int p = bm.getPixel(l + (r - l) * ix / 23, y);
                rs += Color.red(p);
                gs += Color.green(p);
                bs += Color.blue(p);
                n++;
            }
        }
        return Color.rgb((int) (rs / n), (int) (gs / n), (int) (bs / n));
    }
}
