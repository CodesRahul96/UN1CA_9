package com.k4.homeclock;

import android.content.Context;
import android.content.Intent;
import android.os.Looper;
import android.os.SemSystemProperties;
import android.provider.Settings;
import android.util.Log;

import java.lang.reflect.Field;
import java.util.Map;

/**
 * Host test (src/test/run.sh) of the reload / fingerprint logic and the clock gate, on the real EngineState,
 * ReloadPolicy, HomeDepthClock and DepthClock classes, with fakes (src/test/fakes) for the Android and SpriteWallpaper
 * classes they use. The fake main looper runs on a virtual clock (Looper.advance).
 */
public final class HostTest {
    private static int passed;
    private static int failed;

    public static void main(String[] args) throws Exception {
        policy();
        sharedDefault();
        editorReapplyFresh();
        editorReapplyStaleBuild();
        editorReapplyStaleNeverShown();
        editorNoReapplyUnchanged();
        editorNoReapplyChanged();
        previewDuringPendingReload();
        settingsToggles();
        nothingToDoLogRateLimited();
        sharedEngine();
        gate();
        System.out.println(passed + " passed, " + failed + " failed");
        if (failed > 0) {
            System.exit(1);
        }
    }

    // ---- helpers

    private static void check(String what, boolean ok) {
        if (ok) {
            passed++;
            System.out.println("ok   " + what);
        } else {
            failed++;
            System.out.println("FAIL " + what);
            for (String l : Log.LINES) {
                System.out.println("       " + l);
            }
        }
    }

    @SuppressWarnings("unchecked")
    private static void clearMap(String name) throws Exception {
        Field f = HomeDepthClock.class.getDeclaredField(name);
        f.setAccessible(true);
        ((Map<Object, Object>) f.get(null)).clear();
    }

    private static void reset() throws Exception {
        for (String m : new String[] {"ENGINES", "CLOCKS", "BUILT", "POST_DIM"}) {
            clearMap(m);
        }
        Looper.reset();
        Context.RECEIVERS.clear();
        SemSystemProperties.P.clear();
        Settings.System.S.clear();
        Log.LINES.clear();
        KeyguardWatch.locked = true;
        SemSystemProperties.P.put(HomeDepthClock.PROP, "1");
        saveClock("{\"clockType\":1,\"style\":\"A\"}", "100,200,900,500,1.0,0,");
    }

    private static void saveClock(String item, String rect) {
        Settings.System.S.put(HomeClockItem.KEY, item);
        Settings.System.S.put(HomeClockItem.KEY + "_rect", rect);
        Settings.System.S.put(HomeClockItem.KEY_BUNDLE, "{\"gravity\":3}");
    }

    /** A home-only engine with the clock presenter, created (onCreate) and built (fingerprint recorded). */
    private static f3.a homeEngine() {
        Context c = new Context();
        HomeClockPresenter p = new HomeClockPresenter(c, 1, null);
        f3.a e = new f3.a(p);
        e.ctx = c;
        e.which = 1;
        HomeDepthClock.onCreate(e);
        build(e);
        return e;
    }

    /** What a presenter build records: the fingerprint of the settings as they are now. */
    private static void build(f3.a e) {
        HomeDepthClock.built(e.g, HomeDepthClock.fingerprint(e.ctx));
    }

    private static void reload(boolean fromEditor) {
        Intent i = new Intent(HomeDepthClock.ACTION_RELOAD);
        if (fromEditor) {
            i.putExtra(HomeDepthClock.EXTRA_WALLPAPER_PENDING, true);
        }
        Context.broadcast(i);
    }

    private static boolean logged(String part) {
        for (String l : Log.LINES) {
            if (l.contains(part)) {
                return true;
            }
        }
        return false;
    }

    private static int count(String part) {
        int n = 0;
        for (String l : Log.LINES) {
            if (l.contains(part)) {
                n++;
            }
        }
        return n;
    }

    // ---- ReloadPolicy alone

    private static void policy() {
        check("fingerprint: null and \"\" differ", !ReloadPolicy.fingerprint((String) null).equals(ReloadPolicy.fingerprint("")));
        check("fingerprint: field boundaries count", !ReloadPolicy.fingerprint("ab", "c").equals(ReloadPolicy.fingerprint("a", "bc")));
        check("fingerprint: same input, same string", ReloadPolicy.fingerprint("a", null, "b").equals(ReloadPolicy.fingerprint("a", null, "b")));
        check("decide: nothing wanted or shown", ReloadPolicy.decide(false, false, null, null) == ReloadPolicy.Action.NONE);
        check("decide: clock to add", ReloadPolicy.decide(true, false, null, "x") == ReloadPolicy.Action.REBUILD);
        check("decide: clock to remove", ReloadPolicy.decide(false, true, "x", null) == ReloadPolicy.Action.REBUILD);
        check("decide: built from the current settings", ReloadPolicy.decide(true, true, "x", "x") == ReloadPolicy.Action.KEEP);
        check("decide: built from other settings", ReloadPolicy.decide(true, true, "x", "y") == ReloadPolicy.Action.REBUILD);
        check("decide: build settings unknown", ReloadPolicy.decide(true, true, null, "y") == ReloadPolicy.Action.REBUILD);
        check("decide: current settings unreadable", ReloadPolicy.decide(true, true, "x", null) == ReloadPolicy.Action.REBUILD);
        check("delay: editor waits, Settings coalesces",
                ReloadPolicy.checkDelay(true) == 6000 && ReloadPolicy.checkDelay(false) == 300);
    }

    private static void sharedDefault() throws Exception {
        reset();
        check("shared: on when the prop is unset", HomeDepthClock.sharedEnabled());
        SemSystemProperties.P.put(HomeDepthClock.PROP + "_shared", "1");
        check("shared: on with 1", HomeDepthClock.sharedEnabled());
        SemSystemProperties.P.put(HomeDepthClock.PROP + "_shared", "0");
        check("shared: off with 0", !HomeDepthClock.sharedEnabled());
        SemSystemProperties.P.put(HomeDepthClock.PROP + "_shared", "false");
        check("shared: off with false", !HomeDepthClock.sharedEnabled());
    }

    // ---- the editor's save (RELOAD with EXTRA_WALLPAPER_PENDING, then the wallpaper apply)

    /** Settings written, RELOAD, then the reapply replaces the sub engine; the new one reads the new settings. */
    private static void editorReapplyFresh() throws Exception {
        reset();
        f3.a old = homeEngine();
        HomeDepthClock.onVisibility(old, false); // the editor covers the home screen
        saveClock("{\"clockType\":1,\"style\":\"B\"}", "100,300,900,600,1.2,0,");
        reload(true);
        Looper.advance(800); // the reapply: old sub engine detached (destroyed), new one created and built
        HomeDepthClock.onDestroy(old);
        f3.a now = homeEngine();
        HomeDepthClock.onVisibility(now, true); // editor closed
        Looper.advance(10_000);
        check("editor, reapply after the write: no rebuild of the old engine", old.stops == 0);
        check("editor, reapply after the write: no rebuild of the new engine", now.stops == 0);
        HomeDepthClock.onDestroy(now);
    }

    /** The reapply built the new engine before the write landed: it gets the RELOAD and rebuilds once shown. */
    private static void editorReapplyStaleBuild() throws Exception {
        reset();
        f3.a old = homeEngine();
        HomeDepthClock.onVisibility(old, false);
        HomeDepthClock.onDestroy(old);
        f3.a now = homeEngine(); // built from style A
        HomeDepthClock.onVisibility(now, false);
        saveClock("{\"clockType\":1,\"style\":\"B\"}", "100,300,900,600,1.2,0,");
        reload(true);
        Looper.advance(1000);
        check("editor, stale new engine: nothing while the editor is still in front", now.stops == 0);
        HomeDepthClock.onVisibility(now, true);
        Looper.advance(0);
        check("editor, stale new engine: rebuilt when shown", now.stops == 1);
        check("editor, stale new engine: log says the settings changed", logged("settings changed since the build"));
        Looper.advance(10_000);
        check("editor, stale new engine: rebuilt once only", now.stops == 1);
        HomeDepthClock.onDestroy(now);
    }

    private static void editorReapplyStaleNeverShown() throws Exception {
        reset();
        f3.a e = homeEngine();
        HomeDepthClock.onVisibility(e, false);
        saveClock("{\"clockType\":2}", "1,2,3,4,1.0,0,");
        reload(true);
        Looper.advance(5900);
        check("editor, never shown: no check before 6 s", e.stops == 0);
        Looper.advance(200);
        check("editor, never shown: rebuilt after 6 s", e.stops == 1);
        HomeDepthClock.onDestroy(e);
    }

    /** Apply with nothing of the clock changed and no new engine: no rebuild. */
    private static void editorNoReapplyUnchanged() throws Exception {
        reset();
        f3.a e = homeEngine();
        HomeDepthClock.onVisibility(e, false);
        saveClock("{\"clockType\":1,\"style\":\"A\"}", "100,200,900,500,1.0,0,"); // same values written again
        reload(true);
        HomeDepthClock.onVisibility(e, true);
        Looper.advance(10_000);
        check("editor, unchanged clock: no rebuild", e.stops == 0);
        check("editor, unchanged clock: logged as up to date", logged("clock already built from the current settings"));
        HomeDepthClock.onDestroy(e);
    }

    /** The tester's case: position/scale changed, the engine is not replaced: rebuilt as soon as home shows. */
    private static void editorNoReapplyChanged() throws Exception {
        reset();
        f3.a e = homeEngine();
        HomeDepthClock.onVisibility(e, false);
        saveClock("{\"clockType\":1,\"style\":\"A\"}", "100,250,900,550,1.4,0,");
        reload(true);
        Looper.advance(300);
        HomeDepthClock.onVisibility(e, true);
        Looper.advance(0);
        check("editor, clock moved, same engine: rebuilt when home shows", e.stops == 1);
        HomeDepthClock.onDestroy(e);
    }

    /** A preview (or any other) home engine created meanwhile no longer cancels the real engine's check. */
    private static void previewDuringPendingReload() throws Exception {
        reset();
        f3.a home = homeEngine();
        HomeDepthClock.onVisibility(home, false);
        saveClock("{\"clockType\":1,\"style\":\"C\"}", "100,200,900,500,1.0,0,");
        reload(true);
        f3.a preview = homeEngine(); // e.g. Wallpaper and style's home preview, built from the new settings
        preview.preview = true;
        HomeDepthClock.onVisibility(preview, true);
        Looper.advance(2000);
        HomeDepthClock.onVisibility(home, true);
        Looper.advance(0);
        check("preview created during the wait: real engine still rebuilt", home.stops == 1);
        check("preview created during the wait: the fresh preview is not rebuilt", preview.stops == 0);
        HomeDepthClock.onDestroy(home);
        HomeDepthClock.onDestroy(preview);
    }

    // ---- Settings (RELOAD without the extra)

    private static void settingsToggles() throws Exception {
        reset();
        f3.a e = homeEngine();
        HomeDepthClock.onVisibility(e, true);
        reload(false);
        Looper.advance(400);
        check("settings, nothing changed: no rebuild", e.stops == 0);
        SemSystemProperties.P.put(HomeDepthClock.PROP + "_color", "accent");
        reload(false);
        reload(false); // coalesced
        Looper.advance(400);
        check("settings, plain clock colour changed: one rebuild", e.stops == 1);
        build(e); // the rebuilt engine
        SemSystemProperties.P.put(HomeDepthClock.PROP, "0");
        reload(false);
        Looper.advance(400);
        check("settings, switch off: clock removed", e.stops == 2);
        HomeDepthClock.onDestroy(e);

        // switch on while the engine has the stock presenter (no clock)
        Context c = new Context();
        f3.a stock = new f3.a(new h3.f(c, 1, null));
        stock.ctx = c;
        HomeDepthClock.onCreate(stock);
        SemSystemProperties.P.put(HomeDepthClock.PROP, "1");
        reload(false);
        Looper.advance(400);
        check("settings, switch on: clock added", stock.stops == 1);
        HomeDepthClock.onDestroy(stock);
    }

    private static void nothingToDoLogRateLimited() throws Exception {
        reset();
        SemSystemProperties.P.put(HomeDepthClock.PROP, "0");
        Context c = new Context();
        f3.a e = new f3.a(new h3.f(c, 1, null));
        e.ctx = c;
        HomeDepthClock.onCreate(e);
        String line = "reload (which=1, enabled=false, shared=true): no clock wanted or shown, nothing to rebuild (switch off)";
        reload(false);
        Looper.advance(400);
        check("no clock wanted: says why", count(line) == 1 && e.stops == 0);
        for (int i = 0; i < 5; i++) {
            reload(false);
            Looper.advance(400);
        }
        check("no clock wanted: not repeated within a minute", count(line) == 1);
        Looper.advance(61_000);
        reload(false);
        Looper.advance(400);
        check("no clock wanted: logged again after a minute", count(line) == 2);
        HomeDepthClock.onDestroy(e);
    }

    // ---- shared home+lock engine (h3.b with the gated clock)

    private static final class TestClock extends DepthClock {
        TestClock(Context c, h3.a owner, boolean gated) {
            super(c, "test", null, owner, gated);
        }

        @Override
        String text() {
            return "12:00";
        }

        @Override
        public void a(android.graphics.Canvas canvas) {
            lastDrawn = expected();
        }
    }

    private static f3.a sharedEngine(Context c) {
        h3.b p = new h3.b(c, 7, 0, null);
        f3.a e = new f3.a(p);
        e.ctx = c;
        e.which = 7;
        HomeDepthClock.onCreate(e);
        String fp = HomeDepthClock.fingerprint(c);
        HomeDepthClock.setClock(p, new TestClock(c, p, true));
        HomeDepthClock.built(p, fp);
        return e;
    }

    private static void sharedEngine() throws Exception {
        reset();
        Context c = new Context();
        f3.a e = sharedEngine(c);
        reload(false);
        Looper.advance(400);
        check("shared, nothing changed: no rebuild", e.stops == 0);
        saveClock("{\"clockType\":3}", "1,2,3,4,1.0,0,");
        reload(true);
        HomeDepthClock.onVisibility(e, true);
        Looper.advance(0);
        check("shared, clock style changed: rebuilt when shown", e.stops == 1);
        HomeDepthClock.onDestroy(e);

        reset();
        e = sharedEngine(c);
        SemSystemProperties.P.put(HomeDepthClock.PROP + "_shared", "0");
        reload(false);
        Looper.advance(400);
        check("shared, turned off with _shared=0: clock removed", e.stops == 1);
        HomeDepthClock.onDestroy(e);

        // a shared engine with the stock flatten presenter (no AOD-fullscreen display flag) never gets a clock
        reset();
        f3.a flat = new f3.a(new h3.f(c, 3, null));
        flat.ctx = c;
        flat.which = 3;
        HomeDepthClock.onCreate(flat);
        reload(false);
        Looper.advance(400);
        check("shared with a presenter that takes no clock: not rebuilt", flat.stops == 0);
        HomeDepthClock.onDestroy(flat);
    }

    // ---- DepthClock.showing

    private static void gate() throws Exception {
        reset();
        Context c = new Context();
        h3.b p = new h3.b(c, 7, 0, null);
        f3.a e = new f3.a(p);
        e.ctx = c;
        e.which = 7;
        HomeDepthClock.onCreate(e);
        TestClock gated = new TestClock(c, p, true);
        check("gate: keyguard state unknown -> hidden", !gated.showing());
        KeyguardWatch.locked = false;
        check("gate: keyguard gone, display ON -> shown", gated.showing());
        for (B2.a s : new B2.a[] {B2.a.NONE, B2.a.OFF, B2.a.AOD_WITH_WALLPAPER, B2.a.AOD_WITHOUT_WALLPAPER}) {
            e.display = s;
            check("gate: display " + s + " -> hidden", !gated.showing());
        }
        e.display = B2.a.ON;
        KeyguardWatch.locked = true;
        check("gate: keyguard shown -> hidden", !gated.showing());
        KeyguardWatch.locked = false;
        e.preview = true;
        check("gate: preview engine -> hidden", !gated.showing());
        e.preview = false;
        e.which = 6; // lock-only now (a new home wallpaper was set)
        check("gate: engine without the home flag -> hidden", !gated.showing());
        e.which = 7;
        TestClock orphan = new TestClock(c, new h3.b(c, 7, 0, null), true);
        check("gate: engine not found -> hidden", !orphan.showing());
        check("gate: expected() is empty while hidden", "".equals(orphan.expected()));
        HomeDepthClock.onDestroy(e);

        HomeClockPresenter hp = new HomeClockPresenter(c, 1, null);
        f3.a home = new f3.a(hp);
        home.ctx = c;
        home.which = 1;
        HomeDepthClock.onCreate(home);
        TestClock plain = new TestClock(c, hp, false);
        KeyguardWatch.locked = true;
        check("home-only: shown while the engine is home-only (keyguard not consulted)", plain.showing());
        home.which = 3;
        check("home-only: hidden once the engine also shows the lock screen", !plain.showing());
        home.which = 2;
        check("home-only: hidden on a lock-only engine", !plain.showing());
        HomeDepthClock.onDestroy(home);
        check("home-only: engine not found -> shown (presenter made for home-only engines only)", plain.showing());
    }
}
