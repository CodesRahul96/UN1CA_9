package com.k4.soundtrigger;

import android.app.ActivityThread;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.AudioPlaybackConfiguration;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.PowerManager;
import android.os.ServiceManager;
import android.os.SystemClock;
import android.util.Slog;

import com.android.server.soundtrigger_middleware.HalException;
import com.android.server.soundtrigger_middleware.ISoundTriggerHal;
import com.android.server.soundtrigger_middleware.RecoverableException;
import com.android.server.soundtrigger_middleware.SoundTriggerHalEnforcer;
import com.android.server.soundtrigger_middleware.SoundTriggerHalWatchdog;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.List;
import java.util.WeakHashMap;
import java.util.concurrent.Executor;

/**
 * Called from SoundTriggerHalEnforcer / SoundTriggerHalWatchdog (patches/soundtrigger_load_no_reboot and
 * soundtrigger_no_hal_reboot).
 *
 * On the A52s the sound trigger HAL (HIDL 2.3, QTI st-hal) lives inside the audio HAL process, so a sound trigger
 * HAL reboot (setprop sys.audio.restart.hal 1) restarts the whole audio HAL: a running call loses its voice/VoIP
 * audio both ways, audioserver restarts. Rule: no sound trigger HAL reboot while a call / VoIP / ringing is going
 * on; the reboot the middleware wants is owed and runs once the audio mode is NORMAL again.
 *
 * 1. Load refusals (refused(), soundtrigger_load_no_reboot). When the HAL cannot open an ADSP listen (LSM) session
 *    it fails loadSoundModel/loadPhraseSoundModel with a plain status (-ENODEV from ape_reg_sm, "pcm_is_ready
 *    failed ... pcmC0D10c: Out of memory"; tester log 2026-10-20, "Hey Google" model 7038ddc8 while audio was
 *    playing). AIDL HALs report such a refusal as RESOURCE_CONTENTION and call onResourcesAvailable() once the
 *    resource is free; SoundTriggerHelper then keeps the model requested, tells the client onRecognitionPaused()
 *    and loads it again on onResourcesAvailable(). A HIDL 2.x HAL has no such callback, so:
 *     - -ENODEV/-EBUSY/-ENOMEM/-EAGAIN -> RecoverableException(RESOURCE_CONTENTION) (client sees STATUS_BUSY, stays
 *       requested); any other status -> RecoverableException(INTERNAL_ERROR). Never a HAL reboot: a failed load
 *       leaves nothing to resync (the enforcer only records a model after a successful load).
 *     - while a refusal is pending: onResourcesAvailable() on that HAL stack's global callback when the HAL's
 *       concurrency ends: all playback stopped (+5 s: audio HAL output standby lags the player state) or the
 *       screen turned off (+2 s: the HAL switches to the LPI path). One retry per event, no timers.
 *
 * 2. Every other HAL error (halError(), callbackError(), soundtrigger_no_hal_reboot). Stock reboots the HAL at once.
 *    That reboot is also what resyncs the middleware with the HAL after a failed state change: stopRecognition
 *    leaves the enforcer's model PENDING_STOP and a failed unloadSoundModel keeps the model in its table (both are
 *    reset only on success, as are SoundTriggerModule / Validation / SoundTriggerHelper above it). The HAL death
 *    that follows the reboot makes SoundTriggerModule.binderDied() detach the old stack, attach a fresh one and send
 *    onModuleDied() to every client, which clears and reloads all models. So the reboot is always owed, never
 *    dropped: a HalException becomes RecoverableException(INTERNAL_ERROR) (what Validation reports for it anyway),
 *    a callback contract violation drops the event (as stock does after its reboot), and
 *     - audio mode NORMAL: the reboot runs after a 3 s grace (stock: at once). The HAL's call concurrency handling
 *       (stopRecognition from DeviceStateHandler at call start, HAL abort events) runs inside AudioService.setMode,
 *       ~0.2-0.5 s before the mode change reaches mode listeners; the grace keeps an error from that window from
 *       rebooting the HAL just as the call connects. Before rebooting, the mode is read again from AudioService.
 *     - any other mode, or the mode is not known yet: the reboot runs once the mode is NORMAL again (+5 s,
 *       cancelled if a call starts again). Not needed any more if that HAL stack dies on its own before
 *       (detached()).
 *
 * 3. SoundTriggerHalWatchdog deadline (watchdogExpired(), soundtrigger_no_hal_reboot): a HAL call still running after
 *    3 s. Stock logs "HAL deadline expired. Rebooting." and reboots at once, which unblocks the caller (the call
 *    returns DeadObject). Now:
 *     - mode NORMAL (read again from AudioService) or not known yet (boot: nothing may wait for the mode listener
 *       there): stock, reboot now.
 *     - call / VoIP / ringing: no reboot. The caller stays blocked in the HAL (only the sound trigger stack waits:
 *       DeviceStateHandler's executor, the middleware / SoundTriggerHelper locks and their binder callers; audio
 *       policy's capture-state callback is oneway, AudioService and telephony never wait on it). If the call
 *       returns late (watchdogClosed()), nothing is rebooted: the result went through the enforcer as usual (an
 *       error there owes its own resync reboot). If it is still hung when the mode is NORMAL again (+5 s), or for
 *       45 s past the deadline during the call (a dead HAL; 48 s in all stays below the system_server Watchdog's
 *       60 s, so blocked system_server threads can never get system_server killed), the HAL is rebooted.
 */
public final class K4StRetry {
    private static final String TAG = "K4StRetry";
    private static final String ENFORCER_TAG = "SoundTriggerHalEnforcer";
    private static final String WATCHDOG_TAG = "SoundTriggerHalWatchdog";
    private static final int RESOURCE_CONTENTION = 1;
    private static final int INTERNAL_ERROR = 5;
    private static final long AUDIO_IDLE_DELAY_MS = 5000;
    private static final long SCREEN_OFF_DELAY_MS = 2000;
    private static final long CALL_END_DELAY_MS = 5000;
    private static final long NORMAL_GRACE_MS = 3000;
    private static final long WATCHDOG_MS = 3000; // SoundTriggerHalWatchdog deadline (0xbb8)
    /**
     * A HAL call hung this long past its deadline during a call is a dead HAL: 3 s + 45 s = 48 s blocked in total, below
     * the system_server Watchdog (60 s, also BinderThreadMonitor), so the threads waiting on the sound trigger stack can
     * never get system_server killed (which would end the call and everything else). Trade-off: a sound trigger HAL
     * call that is really hung costs a call its audio after ~48 s instead of 3 s (stock).
     */
    private static final long HUNG_IN_CALL_MAX_MS = 45 * 1000;
    private static final long REGISTER_RETRY_FAST_MS = 1000; // the first minute after the first attach
    private static final int REGISTER_FAST_TRIES = 60;
    private static final long REGISTER_RETRY_MS = 15000;
    /** Owed reboots while AudioService stays unreachable this long: stock (no call is possible without AudioService). */
    private static final long UNKNOWN_FALLBACK_MS = 15 * 60 * 1000;
    /** sMode before the mode listener is registered: treated like a call (defer) for HAL errors. */
    private static final int MODE_UNKNOWN = -100;

    /** A HAL call that ran past the watchdog deadline during a call. */
    private static final class Hung {
        final SoundTriggerHalWatchdog hal;
        final Exception where;
        final long since;
        boolean deferred;

        Hung(SoundTriggerHalWatchdog hal, Exception where, long since) {
            this.hal = hal;
            this.where = where;
            this.since = since;
        }
    }

    private static final Object sLock = new Object();
    /** SoundTriggerHalEnforcer -> the global callback registered on it (one per attached HAL stack). */
    private static final IdentityHashMap<Object, ISoundTriggerHal.GlobalCallback> sCallbacks = new IdentityHashMap<>();
    /** Enforcers with a load refused since the last retry. */
    private static final IdentityHashMap<Object, Boolean> sPending = new IdentityHashMap<>();
    /** Enforcers that owe a resync reboot (HAL error during a call, or in its NORMAL grace). */
    private static final IdentityHashMap<SoundTriggerHalEnforcer, Boolean> sOwed = new IdentityHashMap<>();
    /** SoundTriggerHalWatchdog$Watchdog -> its HAL call, still running past the deadline. */
    private static final IdentityHashMap<Object, Hung> sHung = new IdentityHashMap<>();
    /**
     * Watchdogs closed (HAL call returned) without a sHung entry. The deadline lambda may already be running when the
     * call returns at ~3000 ms (removeCallbacksAndMessages cannot stop it); watchdogExpired then finds the watchdog
     * here and records nothing. Weak keys (identity hashCode/equals): closed watchdogs are garbage right after close().
     */
    private static final WeakHashMap<Object, Boolean> sClosed = new WeakHashMap<>();
    /** Decisions only (mode, retries, reboots): never calls into the middleware, whose locks a hung HAL call holds. */
    private static Handler sHandler;
    /** Middleware callbacks (onResourcesAvailable takes the SoundTriggerModule monitor): may block behind a hung call. */
    private static Handler sCbHandler;
    private static volatile AudioManager sAm;
    private static volatile int sMode = MODE_UNKNOWN;
    private static boolean sModeWatched;
    private static int sModeRegisterTries;
    private static long sUnknownSince;
    private static boolean sAudioActive;
    private static boolean sAudioWatched;
    private static boolean sScreenWatched;
    private static boolean sRetryRegisterPosted;
    private static String sReason;
    /** Keeps short delayed retries / reboots from stalling in suspend (Handler delays are uptime). Handler thread. */
    private static PowerManager.WakeLock sWakeLock;
    private static long sWakeUntil;

    private static final Runnable FIRE = new Runnable() {
        @Override
        public void run() {
            fire();
        }
    };
    private static final Runnable REGISTER_MODE = new Runnable() {
        @Override
        public void run() {
            registerModeListener();
        }
    };
    private static final Runnable REGISTER_RETRY = new Runnable() {
        @Override
        public void run() {
            registerRetryListeners();
        }
    };
    private static final Runnable RESYNC = new Runnable() {
        @Override
        public void run() {
            resync();
        }
    };
    private static final Runnable HOLD_GRACE = new Runnable() {
        @Override
        public void run() {
            hold(NORMAL_GRACE_MS + 1000);
        }
    };
    private static final Runnable CHECK_HUNG = new Runnable() {
        @Override
        public void run() {
            checkHung();
        }
    };
    private static final Executor EXECUTOR = new Executor() {
        @Override
        public void execute(Runnable r) {
            sHandler.post(r);
        }
    };

    private K4StRetry() {}

    /** Under sLock. */
    private static void ensureHandlerLocked() {
        if (sHandler == null) {
            HandlerThread t = new HandlerThread(TAG);
            t.start();
            sHandler = new Handler(t.getLooper());
            HandlerThread cb = new HandlerThread(TAG + "Cb");
            cb.start();
            sCbHandler = new Handler(cb.getLooper());
            sHandler.post(REGISTER_MODE);
        }
    }

    /** First thing in SoundTriggerHalEnforcer.registerCallback (SoundTriggerModule.attachToHal). */
    public static void setCallback(Object enforcer, ISoundTriggerHal.GlobalCallback cb) {
        synchronized (sLock) {
            sCallbacks.put(enforcer, cb);
            ensureHandlerLocked();
        }
    }

    /** First thing in SoundTriggerHalEnforcer.detach (SoundTriggerModule.binderDied: this HAL stack is gone). */
    public static void detached(Object enforcer) {
        boolean owed;
        int hung = 0;
        synchronized (sLock) {
            sCallbacks.remove(enforcer);
            sPending.remove(enforcer);
            owed = sOwed.remove(enforcer) != null;
            if (enforcer instanceof SoundTriggerHalEnforcer) {
                SoundTriggerHalWatchdog hal = ((SoundTriggerHalEnforcer) enforcer).mUnderlying;
                for (Iterator<Hung> it = sHung.values().iterator(); it.hasNext(); ) {
                    if (it.next().hal == hal) {
                        it.remove();
                        hung++;
                    }
                }
            }
        }
        if (owed || hung > 0) Slog.i(TAG, "HAL died: the deferred sound trigger HAL reboot is no longer needed");
    }

    /** SoundTriggerHalEnforcer.load*SoundModel catch: returns the exception to throw instead of rebooting the HAL. */
    public static RuntimeException refused(Object enforcer, HalException e) {
        String msg = e.toString();
        int code = e.errorCode;
        if (code != -19 && code != -16 && code != -12 && code != -11) {
            Slog.w(TAG, "HAL refused the model, not rebooting the HAL: " + msg);
            return new RecoverableException(INTERNAL_ERROR, msg);
        }
        Slog.w(TAG, "HAL refused the model (busy), not rebooting the HAL; loading it again when audio stops"
                + " or the screen turns off: " + msg);
        synchronized (sLock) {
            sPending.put(enforcer, Boolean.TRUE);
            ensureHandlerLocked();
            if (!sRetryRegisterPosted) {
                sRetryRegisterPosted = true;
                sHandler.post(REGISTER_RETRY);
            }
        }
        return new RecoverableException(RESOURCE_CONTENTION, msg);
    }

    /**
     * SoundTriggerHalEnforcer.handleException, replaces its "log, reboot(), throw e" branch (everything that is not
     * a RecoverableException or a dead HAL). Returns the exception to throw.
     */
    public static RuntimeException halError(SoundTriggerHalEnforcer enforcer, RuntimeException e) {
        owe(enforcer, e.toString());
        if (e instanceof HalException) return new RecoverableException(INTERNAL_ERROR, e.toString());
        return e;
    }

    /** SoundTriggerHalEnforcer$ModelCallbackEnforcer contract checks, replaces this$0.reboot(); the event is dropped. */
    public static void callbackError(SoundTriggerHalEnforcer enforcer) {
        owe(enforcer, "HAL callback broke the sound trigger contract");
    }

    /** The resync reboot is owed: after the NORMAL grace, or once the call has ended. Never on the caller's thread. */
    private static void owe(SoundTriggerHalEnforcer enforcer, String what) {
        int mode;
        synchronized (sLock) {
            ensureHandlerLocked();
            mode = sMode;
            sOwed.put(enforcer, Boolean.TRUE);
            if (!listenerSaysCall() && !sHandler.hasCallbacks(RESYNC)) {
                sHandler.postDelayed(RESYNC, NORMAL_GRACE_MS);
                sHandler.post(HOLD_GRACE); // not here: the caller holds middleware locks
            }
        }
        if (mode == AudioManager.MODE_NORMAL) {
            Slog.e(ENFORCER_TAG, "Exception caught from HAL, rebooting HAL in " + NORMAL_GRACE_MS + " ms unless a"
                    + " call starts: " + what);
        } else {
            Slog.w(TAG, "HAL error during a call or before the audio mode is watched (mode " + mode + "), not"
                    + " rebooting the HAL (shared with call audio); resync reboot once there is no call: " + what);
        }
    }

    /**
     * SoundTriggerHalWatchdog$Watchdog deadline (UptimeTimer thread), replaces its "log, reboot()": the HAL call that
     * created this watchdog is still running after 3 s.
     */
    public static void watchdogExpired(Object watchdog, SoundTriggerHalWatchdog hal, Exception where) {
        boolean now;
        synchronized (sLock) {
            ensureHandlerLocked();
            // the HAL call returned while this deadline was already running: nothing is hung (and close() and this
            // check both run under sLock, so one of them always sees the other)
            if (sClosed.remove(watchdog) != null) return;
        }
        // the listener may not be registered yet (first attach): read AudioService directly (a field read on this ROM)
        now = currentMode() == MODE_UNKNOWN;
        synchronized (sLock) {
            if (sClosed.remove(watchdog) != null) return;
            if (!now) {
                sHung.put(watchdog, new Hung(hal, where, SystemClock.uptimeMillis()));
                sHandler.post(CHECK_HUNG);
            }
        }
        if (now) {
            // AudioService not published yet (boot, no call possible): stock; the reboot unblocks the caller, which
            // may be boot itself
            Slog.e(WATCHDOG_TAG, "HAL deadline expired. Rebooting.", where);
            hal.reboot();
        }
    }

    /**
     * SoundTriggerHalWatchdog$Watchdog.close(), after its timer is cancelled: the HAL call returned (or threw). Every
     * HAL call (a few per minute): always under sLock, see sClosed.
     */
    public static void watchdogClosed(Object watchdog) {
        Hung h;
        synchronized (sLock) {
            h = sHung.remove(watchdog);
            if (h == null) sClosed.put(watchdog, Boolean.TRUE);
        }
        if (h != null) {
            Slog.w(TAG, "the hung sound trigger HAL call returned after "
                    + (SystemClock.uptimeMillis() - h.since + WATCHDOG_MS) + " ms: no HAL reboot");
        }
    }

    /**
     * The mode now. A call mode from the listener is trusted (it only lags in the safe direction at hang-up); NORMAL or
     * not known yet is read again from AudioService (getMode() returns the volatile mCachedAudioMode, written in
     * setMode() before the listeners are told: lock-free, never blocks). MODE_UNKNOWN only while AudioService is not
     * published. Any thread except under middleware locks (the first call may look up the service).
     */
    private static int currentMode() {
        int m = sMode;
        if (m != AudioManager.MODE_NORMAL && m != MODE_UNKNOWN) return m;
        AudioManager am = audioManager();
        if (am == null) return m;
        try {
            return am.getMode();
        } catch (Throwable t) {
            return m;
        }
    }

    private static AudioManager audioManager() {
        AudioManager am = sAm;
        if (am != null) return am;
        try {
            if (ServiceManager.checkService(Context.AUDIO_SERVICE) == null) return null;
            am = ActivityThread.currentActivityThread().getSystemContext().getSystemService(AudioManager.class);
            sAm = am;
            return am;
        } catch (Throwable t) {
            return null;
        }
    }

    /** Handler thread: decide for watchdog deadlines (no middleware lock is held here). */
    private static void checkHung() {
        int mode = currentMode();
        List<Hung> reboot = new ArrayList<>();
        List<Hung> deferred = new ArrayList<>();
        synchronized (sLock) {
            if (mode == AudioManager.MODE_NORMAL || mode == MODE_UNKNOWN) {
                reboot.addAll(sHung.values());
                sHung.clear();
            } else {
                for (Hung h : sHung.values()) {
                    if (!h.deferred) {
                        h.deferred = true;
                        deferred.add(h);
                    }
                }
            }
        }
        for (Hung h : deferred) {
            Slog.e(TAG, "sound trigger HAL call still running after " + WATCHDOG_MS + " ms during a call (mode "
                    + mode + "): NOT rebooting the audio HAL (shared with call audio); rebooting it after the call"
                    + " if the call into the HAL is still hung", h.where);
        }
        if (!deferred.isEmpty()) {
            if (!sHandler.hasCallbacks(CHECK_HUNG_MAX)) sHandler.postDelayed(CHECK_HUNG_MAX, HUNG_IN_CALL_MAX_MS);
            // live mode says call, the listener still says NORMAL / nothing: resync() polls until they agree
            if (!listenerSaysCall() && !sHandler.hasCallbacks(RESYNC)) {
                sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
            }
        }
        if (!reboot.isEmpty()) {
            for (Hung h : reboot) Slog.e(WATCHDOG_TAG, "HAL deadline expired. Rebooting.", h.where);
            rebootAll(new ArrayList<SoundTriggerHalEnforcer>(), reboot);
        }
    }

    private static final Runnable CHECK_HUNG_MAX = new Runnable() {
        @Override
        public void run() {
            checkHungMax();
        }
    };

    /** Handler thread: a HAL call hung for HUNG_IN_CALL_MAX_MS during a call is a dead HAL. */
    private static void checkHungMax() {
        long now = SystemClock.uptimeMillis();
        long next = Long.MAX_VALUE;
        List<Hung> dead = new ArrayList<>();
        synchronized (sLock) {
            for (Iterator<Hung> it = sHung.values().iterator(); it.hasNext(); ) {
                Hung h = it.next();
                long age = now - h.since;
                if (age >= HUNG_IN_CALL_MAX_MS) {
                    dead.add(h);
                    it.remove();
                } else {
                    next = Math.min(next, HUNG_IN_CALL_MAX_MS - age);
                }
            }
        }
        if (next != Long.MAX_VALUE) sHandler.postDelayed(CHECK_HUNG_MAX, next);
        if (dead.isEmpty()) return;
        Slog.e(TAG, "sound trigger HAL call hung for " + ((HUNG_IN_CALL_MAX_MS + WATCHDOG_MS) / 1000) + " s during a"
                + " call: treating the HAL as dead, rebooting it now before blocked system_server threads trip the"
                + " system_server watchdog (this restarts the audio HAL)");
        rebootAll(new ArrayList<SoundTriggerHalEnforcer>(), dead);
    }

    /** Handler thread. */
    private static void registerModeListener() {
        if (sModeWatched) return;
        try {
            // AudioManager keeps a listener it failed to register with AudioService: only try once it is published,
            // and with a new listener per attempt (re-adding one throws)
            if (ServiceManager.checkService(Context.AUDIO_SERVICE) == null) throw new IllegalStateException("no audio service");
            Context ctx = ActivityThread.currentActivityThread().getSystemContext();
            AudioManager am = ctx.getSystemService(AudioManager.class);
            am.addOnModeChangedListener(EXECUTOR, new AudioManager.OnModeChangedListener() {
                @Override
                public void onModeChanged(int mode) {
                    onMode(mode);
                }
            });
            sModeWatched = true;
            sAm = am;
            sModeRegisterTries = 0;
            int mode = am.getMode();
            Slog.i(TAG, "watching the audio mode for deferred sound trigger HAL reboots (mode " + mode + ")");
            onMode(mode);
        } catch (Throwable t) {
            // AudioService not published yet (early boot); decisions meanwhile read AudioService directly when they can
            int n = ++sModeRegisterTries;
            if (n == 1 || n == REGISTER_FAST_TRIES || (n > REGISTER_FAST_TRIES && n % 20 == 0)) {
                Slog.w(TAG, "cannot watch the audio mode yet (attempt " + n + "), retrying every "
                        + (n < REGISTER_FAST_TRIES ? "1 s" : "15 s") + ": " + t);
            }
            sHandler.postDelayed(REGISTER_MODE, n < REGISTER_FAST_TRIES ? REGISTER_RETRY_FAST_MS : REGISTER_RETRY_MS);
        }
    }

    /** The listener reported a call mode, so its NORMAL event will post RESYNC. */
    private static boolean listenerSaysCall() {
        int m = sMode;
        return m != AudioManager.MODE_NORMAL && m != MODE_UNKNOWN;
    }

    /** Handler thread. */
    private static void onMode(int mode) {
        boolean owed;
        synchronized (sLock) {
            sMode = mode;
            owed = !sOwed.isEmpty() || !sHung.isEmpty();
        }
        if (mode != AudioManager.MODE_NORMAL) {
            sHandler.removeCallbacks(RESYNC);
        } else if (owed) {
            sHandler.removeCallbacks(RESYNC);
            sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
            hold(CALL_END_DELAY_MS + 1000);
        }
    }

    /** Handler thread: no call (any more), run the reboot the HAL errors / hung calls are owed. */
    private static void resync() {
        int mode = currentMode();
        if (mode == MODE_UNKNOWN) {
            // AudioService not published yet: no call is possible, but wait for it unless that takes very long
            long now = SystemClock.uptimeMillis();
            if (sUnknownSince == 0) sUnknownSince = now;
            if (now - sUnknownSince < UNKNOWN_FALLBACK_MS) {
                sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
                return;
            }
            Slog.w(TAG, "audio mode still unknown after " + (UNKNOWN_FALLBACK_MS / 60000) + " min: owed sound"
                    + " trigger HAL reboots run now (stock)");
            mode = AudioManager.MODE_NORMAL;
        } else {
            sUnknownSince = 0;
        }
        List<SoundTriggerHalEnforcer> owed;
        List<Hung> hung;
        synchronized (sLock) {
            if (mode != AudioManager.MODE_NORMAL) {
                // in a call the listener has not reported (yet: it lags setMode, or is not registered): its NORMAL
                // event posts this again; poll meanwhile in case it never reports a change
                if (!listenerSaysCall()) sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
                return;
            }
            owed = new ArrayList<>(sOwed.keySet());
            hung = new ArrayList<>(sHung.values());
            sOwed.clear();
            sHung.clear();
        }
        if (owed.isEmpty() && hung.isEmpty()) return;
        Slog.w(TAG, "no call: rebooting the sound trigger HAL now to resync it with the middleware ("
                + owed.size() + " HAL error(s), " + hung.size() + " hung HAL call(s))");
        rebootAll(owed, hung);
    }

    /** Handler thread: one reboot per HAL stack (each reboot is a setprop that restarts the audio HAL). */
    private static void rebootAll(List<SoundTriggerHalEnforcer> owed, List<Hung> hung) {
        IdentityHashMap<SoundTriggerHalWatchdog, Boolean> done = new IdentityHashMap<>();
        for (SoundTriggerHalEnforcer enforcer : owed) {
            SoundTriggerHalWatchdog hal = enforcer.mUnderlying;
            if (hal == null || done.put(hal, Boolean.TRUE) != null) continue;
            try {
                enforcer.reboot();
            } catch (Throwable t) {
                Slog.e(TAG, "deferred HAL reboot failed", t);
            }
        }
        for (Hung h : hung) {
            if (done.put(h.hal, Boolean.TRUE) != null) continue;
            try {
                h.hal.reboot();
            } catch (Throwable t) {
                Slog.e(TAG, "HAL reboot failed", t);
            }
        }
    }

    /** Handler thread. */
    private static void registerRetryListeners() {
        try {
            if (ServiceManager.checkService(Context.AUDIO_SERVICE) == null) throw new IllegalStateException("no audio service");
            Context ctx = ActivityThread.currentActivityThread().getSystemContext();
            if (!sAudioWatched) {
                AudioManager am = ctx.getSystemService(AudioManager.class);
                sAudioActive = anyActive(am.getActivePlaybackConfigurations());
                am.registerAudioPlaybackCallback(new AudioManager.AudioPlaybackCallback() {
                    @Override
                    public void onPlaybackConfigChanged(List<AudioPlaybackConfiguration> configs) {
                        boolean active = anyActive(configs);
                        if (active == sAudioActive) return;
                        sAudioActive = active;
                        if (active) {
                            if ("audio stopped".equals(sReason)) sHandler.removeCallbacks(FIRE);
                        } else {
                            schedule(AUDIO_IDLE_DELAY_MS, "audio stopped");
                        }
                    }
                }, sHandler);
                sAudioWatched = true;
            }
            if (!sScreenWatched) {
                ctx.registerReceiver(new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context c, Intent i) {
                        schedule(SCREEN_OFF_DELAY_MS, "screen off");
                    }
                }, new IntentFilter(Intent.ACTION_SCREEN_OFF), null, sHandler, Context.RECEIVER_NOT_EXPORTED);
                sScreenWatched = true;
            }
            Slog.i(TAG, "watching playback and screen-off for refused sound models (audio active " + sAudioActive + ")");
        } catch (Throwable t) {
            // AudioService / ActivityManager not reachable yet (refusal during boot): try again later
            Slog.e(TAG, "cannot watch playback / screen state, retrying in 30 s", t);
            sHandler.postDelayed(REGISTER_RETRY, 30000);
        }
    }

    private static boolean anyActive(List<AudioPlaybackConfiguration> configs) {
        if (configs == null) return false;
        for (AudioPlaybackConfiguration c : configs) {
            if (c != null && c.isActive()) return true;
        }
        return false;
    }

    /** Handler thread. */
    private static void schedule(long delayMs, String reason) {
        synchronized (sLock) {
            if (sPending.isEmpty()) return;
        }
        sHandler.removeCallbacks(FIRE);
        sReason = reason;
        sHandler.postDelayed(FIRE, delayMs);
        hold(delayMs + 1000);
    }

    /**
     * Handler thread: a partial wakelock for ms (timeout, never released by hand), so a retry / reboot posted a few
     * seconds ahead runs on time and not at the next wakeup (screen-off retry, 3 s grace, after-call resync).
     */
    private static void hold(long ms) {
        long until = SystemClock.uptimeMillis() + ms;
        if (until <= sWakeUntil) return;
        try {
            if (sWakeLock == null) {
                PowerManager pm = ActivityThread.currentActivityThread().getSystemContext()
                        .getSystemService(PowerManager.class);
                PowerManager.WakeLock wl = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, TAG);
                wl.setReferenceCounted(false);
                sWakeLock = wl;
            }
            sWakeLock.acquire(ms);
            sWakeUntil = until;
        } catch (Throwable t) {
            // PowerManager not up yet (boot): the delay then simply runs at the next wakeup
        }
    }

    /** Handler thread: the callbacks run on the callback thread (SoundTriggerModule.onResourcesAvailable takes the
     *  module monitor, which a hung Session HAL call holds; the decision thread must never wait for it). */
    private static void fire() {
        final List<ISoundTriggerHal.GlobalCallback> cbs = new ArrayList<>();
        synchronized (sLock) {
            for (Object enforcer : sPending.keySet()) {
                ISoundTriggerHal.GlobalCallback cb = sCallbacks.get(enforcer);
                if (cb != null) cbs.add(cb);
            }
            sPending.clear();
        }
        if (cbs.isEmpty()) return;
        final String reason = sReason;
        sCbHandler.post(new Runnable() {
            @Override
            public void run() {
                for (ISoundTriggerHal.GlobalCallback cb : cbs) {
                    Slog.i(TAG, reason + ": resources available, loading refused sound models again");
                    try {
                        cb.onResourcesAvailable();
                    } catch (Throwable t) {
                        Slog.e(TAG, "onResourcesAvailable failed", t);
                    }
                }
            }
        });
    }
}
