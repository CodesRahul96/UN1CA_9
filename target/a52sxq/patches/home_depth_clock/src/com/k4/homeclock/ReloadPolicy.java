package com.k4.homeclock;

/**
 * What a RELOAD does to one engine, kept free of Android types so the host test (src/test) runs it as is.
 *
 * Every presenter build that makes a clock records the fingerprint of the settings it read (HomeDepthClock.built:
 * k4_home_clock_item, _rect, _bundle and the persist.sys.k4.home_depth_clock* props), taken before it reads them, so
 * a write that lands during the build makes the record stale rather than wrongly fresh. A reload then rebuilds only
 * when the engine's clock is missing, unwanted, or built from other settings than the current ones: no double rebuild
 * when the new wallpaper's engine already read the new clock, no stale clock when it read the old one.
 */
final class ReloadPolicy {
    enum Action {
        /** No clock wanted, none shown. */
        NONE,
        /** The clock on screen was built from the current settings. */
        KEEP,
        /** Clock to add or remove, or built from other (or unknown) settings. */
        REBUILD
    }

    private static final char SEP = '\u001f';
    private static final String NULL = "\u0000";

    private ReloadPolicy() {}

    /** One string for the given settings; null and "" stay apart. */
    static String fingerprint(String... parts) {
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) {
                b.append(SEP);
            }
            b.append(parts[i] == null ? NULL : parts[i]);
        }
        return b.toString();
    }

    /**
     * want: the engine should show a clock now; have: it shows one (or is the clock presenter); built: fingerprint the
     * clock was built from (null: unknown); now: fingerprint of the current settings (null: unreadable).
     */
    static Action decide(boolean want, boolean have, String built, String now) {
        if (!want && !have) {
            return Action.NONE;
        }
        if (want != have) {
            return Action.REBUILD;
        }
        return built != null && now != null && built.equals(now) ? Action.KEEP : Action.REBUILD;
    }

    /**
     * When a received RELOAD is checked, in ms. One from the Wallpaper & style editor (wallpaperPending) comes while the
     * editor still covers the home screen and is followed by the wallpaper apply, which usually replaces the engine (its
     * check then never runs) or leaves it in place: checked when the engine is shown again (EngineState.setVisible), or
     * after this wait if it never is. Others (Settings) coalesce quick toggles.
     */
    static long checkDelay(boolean wallpaperPending) {
        return wallpaperPending ? WALLPAPER_WAIT_MS : 300;
    }

    static final long WALLPAPER_WAIT_MS = 6000;
}
