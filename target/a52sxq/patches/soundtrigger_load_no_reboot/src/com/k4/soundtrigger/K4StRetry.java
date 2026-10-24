package com.k4.soundtrigger;

import android.app.ActivityThread;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.media.AudioAttributes;
import android.media.AudioPlaybackConfiguration;
import android.media.AudioRecordingConfiguration;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.PowerManager;
import android.os.ServiceManager;
import android.os.SystemClock;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyCallback;
import android.telephony.TelephonyManager;
import android.util.Slog;

import com.android.server.soundtrigger_middleware.HalException;
import com.android.server.soundtrigger_middleware.ISoundTriggerHal;
import com.android.server.soundtrigger_middleware.RecoverableException;
import com.android.server.soundtrigger_middleware.SoundTriggerHalEnforcer;
import com.android.server.soundtrigger_middleware.SoundTriggerHalWatchdog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
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
 * on; the reboot the middleware wants is owed and runs once there is no call again.
 *
 * "A call" (inCall()) is any of: the audio mode is not NORMAL (mode listener, and AudioService.getMode() re-read:
 * the volatile mCachedAudioMode, a field read on this ROM); the telephony call state of any active subscription is
 * not IDLE (covers a silent / vibrate incoming call, for which Telecom sets no RINGTONE mode); an active playback
 * with USAGE_VOICE_COMMUNICATION / _SIGNALLING / NOTIFICATION_RINGTONE (VoIP apps that never set IN_COMMUNICATION,
 * a VoIP app ringing in mode NORMAL) or an active recording from VOICE_COMMUNICATION / VOICE_CALL / _UPLINK /
 * _DOWNLINK. The non-mode signals are cached from async callbacks (TelephonyCallback per subscription,
 * AudioManager playback / recording callbacks) that run on their own thread (K4StRetryState), which also does every
 * registration (with retry), every service lookup and the wakelock: the decision thread never makes a blocking
 * binder call or takes a foreign lock, and the state thread never takes sLock or a middleware lock, so delivery of
 * those callbacks cannot wait for a HAL thread. A signal that is not known (registration failed, a subscription
 * whose first state has not arrived) counts as a call, bounded like everything else (45 s for a hung HAL call,
 * 15 min for owed reboots). No telephony service at all (boot before the phone process, no SIM stack) is no call.
 *
 * 1. Load refusals (refused(), soundtrigger_load_no_reboot). When the HAL cannot open an ADSP listen (LSM) session
 *    it fails loadSoundModel/loadPhraseSoundModel with a plain status (-ENODEV from ape_reg_sm, "pcm_is_ready
 *    failed ... pcmC0D10c: Out of memory"; tester log 2026-10-20, "Hey Google" model 7038ddc8 while audio was
 *    playing). AIDL HALs report such a refusal as RESOURCE_CONTENTION and call onResourcesAvailable() once the
 *    resource is free; SoundTriggerHelper then keeps the model requested, tells the client onRecognitionPaused()
 *    and loads it again on onResourcesAvailable(). A HIDL 2.x HAL has no such callback, so:
 *     - -ENODEV/-EBUSY/-ENOMEM/-EAGAIN -> RecoverableException(RESOURCE_CONTENTION) (client sees STATUS_BUSY, stays
 *       requested); any other status -> RecoverableException(INTERNAL_ERROR). A HAL status refusal never
 *       reboots: it leaves nothing to resync (the enforcer only records a model after a successful load). A load
 *       that fails otherwise (not a HalException: conversion error, non-DeadObject RemoteException) goes through
 *       halError() like any HAL error (2.), and a load that hangs past 3 s through watchdogExpired() (3.).
 *     - while a refusal is pending: onResourcesAvailable() on that HAL stack's global callback when the HAL's
 *       concurrency ends: all playback stopped (+5 s: audio HAL output standby lags the player state) or the
 *       screen turned off (+2 s: the HAL switches to the LPI path). One retry per event, no timers. The callback
 *       runs on a separate thread (K4StRetryCb): SoundTriggerModule.onResourcesAvailable takes the module monitor,
 *       which a hung Session HAL call holds, and the decision thread (K4StRetry) must never wait for a HAL call.
 *
 * 2. Every other HAL error (halError(), callbackError(), soundtrigger_no_hal_reboot). Stock reboots the HAL at once.
 *    That reboot is also what resyncs the middleware with the HAL after a failed state change: stopRecognition
 *    leaves the enforcer's model PENDING_STOP and a failed unloadSoundModel keeps the model in its table (both are
 *    reset only on success, as are SoundTriggerModule / Validation / SoundTriggerHelper above it). The HAL death
 *    that follows the reboot makes SoundTriggerModule.binderDied() detach the old stack, attach a fresh one and send
 *    onModuleDied() to every client, which clears and reloads all models. So the reboot is always owed, never
 *    dropped: a HalException becomes RecoverableException(INTERNAL_ERROR) (what Validation reports for it anyway),
 *    a callback contract violation drops the event (as stock does after its reboot), and
 *     - the mode listener says NORMAL (or has not reported yet): the reboot is decided 3 s later (stock: at once).
 *       The HAL's call concurrency handling (stopRecognition from DeviceStateHandler at call start, HAL abort
 *       events) runs inside AudioService.setMode, ~0.2-0.5 s before the mode change reaches mode listeners; the
 *       grace keeps an error from that window from rebooting the HAL just as the call connects. At decision time
 *       the mode is read again from AudioService (currentMode()); a call then -> owed as below.
 *     - a call (see above): the reboot runs once there is no call any more (+30 s, cancelled if a call starts again), however long that mode lasts (a VoIP app keeps IN_COMMUNICATION only while it plays
 *       or records: AudioService drops an inactive mode owner after 6 s). Not needed any more if that HAL stack
 *       dies on its own before (detached()).
 *     - AudioService not published yet (boot): polled every 5 s; stock after 15 min of that.
 *    The +30 s after a call keeps a quick redial / call-back from meeting a restarting audio HAL.
 *    The 3 s grace, the screen-off retry and the after-call resync hold a short partial wakelock (Handler delays
 *    are uptime and would otherwise wait for the next wakeup).
 *
 * 3. SoundTriggerHalWatchdog deadline (watchdogExpired(), soundtrigger_no_hal_reboot): a HAL call still running after
 *    3 s. Stock logs "HAL deadline expired. Rebooting." and reboots at once, which unblocks the caller (the call
 *    returns DeadObject). Now:
 *     - mode NORMAL (read again from AudioService) or AudioService not published yet (boot, no call possible, and
 *       boot itself may be the blocked caller): stock, reboot now (on the UptimeTimer thread when unpublished).
 *     - call / VoIP / ringing: no reboot. The caller stays blocked in the HAL (only the sound trigger stack waits:
 *       DeviceStateHandler's executor, the middleware / SoundTriggerHelper locks and their binder callers; audio
 *       policy's capture-state callback is oneway, AudioService and telephony never wait on it). If the call
 *       returns late (watchdogClosed()), nothing is rebooted: the result went through the enforcer as usual (an
 *       error there owes its own resync reboot). A call that returns right at the deadline, while the deadline is
 *       already running, is seen by both sides under sLock (sClosed): no stale hung entry. If it is still hung
 *       when there is no call any more (+30 s), or for 45 s past the deadline during the call (a dead HAL; 48 s in
 *       all stays below the system_server Watchdog's 60 s, so blocked system_server threads can never get
 *       system_server killed), the HAL is rebooted.
 */
public final class K4StRetry {
    private static final String TAG = "K4StRetry";
    private static final String ENFORCER_TAG = "SoundTriggerHalEnforcer";
    private static final String WATCHDOG_TAG = "SoundTriggerHalWatchdog";
    private static final int RESOURCE_CONTENTION = 1;
    private static final int INTERNAL_ERROR = 5;
    private static final long AUDIO_IDLE_DELAY_MS = 5000;
    private static final long SCREEN_OFF_DELAY_MS = 2000;
    /**
     * After the last call signal ended, owed reboots wait this long (cancelled when a call starts again). A redial or
     * call-back within half a minute (dropped call, voicemail, "call me back") is common and must not meet a
     * restarting audio HAL; the cost is that Hey Google / Bixby wake-up, already desynced since the HAL error during
     * the call, stays so ~25 s longer (DeviceStateHandler re-enables recognition 1 s after the call anyway).
     */
    private static final long CALL_END_DELAY_MS = 30000;
    /** Polls while only the live mode or an unknown signal says call (no event will report its end). */
    private static final long POLL_MS = 5000;
    /**
     * While reboots are owed: AudioService's own mode (not the listener's) and the call signals are re-checked this
     * often; NORMAL with no signal on two checks in a row runs them, so a listener stuck on a call mode (a failed
     * setPhoneState at hang-up leaves the dispatch at IN_CALL while getMode() says NORMAL) cannot keep them forever.
     */
    private static final long OWED_CHECK_MS = 60000;
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
    /** Per-subscription call state before its first callback: counts as a call. */
    private static final int CALL_STATE_UNKNOWN = -1;

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
    /**
     * Registrations, service lookups, the wakelock and the call-signal callbacks (telephony, playback, recording):
     * may block in binder calls, never takes sLock or a middleware lock.
     */
    private static Handler sStateHandler;
    /** Cached call signals, written on the state thread only. */
    private static volatile boolean sVoicePlayback;
    private static volatile boolean sVoiceRecording;
    private static volatile boolean sTelBusy;
    /** Signals that are not known (failed registration, a subscription without its first state). */
    private static volatile boolean sSignalsUnknown;
    private static volatile long sSignalsUnknownSince;
    /** State thread only. */
    private static boolean sPlaybackWatched;
    private static boolean sRecordingWatched;
    private static boolean sTelWatched;
    private static boolean sTelFailed;
    private static boolean sAudioSignalsFailed;
    private static int sStateRegisterTries;
    private static SubscriptionManager sSubs;
    private static TelephonyManager sTel;
    private static final HashMap<Integer, SubCall> sSubCalls = new HashMap<>();
    private static volatile AudioManager sAm;
    private static volatile int sMode = MODE_UNKNOWN;
    private static volatile boolean sModeWatched;
    private static long sUnknownSince;
    private static volatile boolean sAudioActive;
    private static boolean sScreenWatched;
    private static String sReason;
    /** Keeps short delayed retries / reboots from stalling in suspend (Handler delays are uptime). State thread. */
    private static PowerManager.WakeLock sWakeLock;
    private static long sWakeUntil;

    /** Telephony call state of one subscription (state thread). */
    private static final class SubCall extends TelephonyCallback implements TelephonyCallback.CallStateListener {
        final int subId;
        final TelephonyManager tm;
        int state = CALL_STATE_UNKNOWN;

        SubCall(int subId, TelephonyManager tm) {
            this.subId = subId;
            this.tm = tm;
        }

        @Override
        public void onCallStateChanged(int s) {
            state = s;
            updateTelephony();
        }
    }

    private static final Runnable FIRE = new Runnable() {
        @Override
        public void run() {
            fire();
        }
    };
    private static final Runnable REGISTER_STATE = new Runnable() {
        @Override
        public void run() {
            registerState();
        }
    };
    private static final Runnable SIGNALS = new Runnable() {
        @Override
        public void run() {
            onCallSignals();
        }
    };
    private static final Runnable RESYNC = new Runnable() {
        @Override
        public void run() {
            resync();
        }
    };
    private static final Runnable OWED_CHECK = new Runnable() {
        @Override
        public void run() {
            owedCheck();
        }
    };
    private static boolean sOwedSeenFree;
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
    private static final Executor STATE_EXECUTOR = new Executor() {
        @Override
        public void execute(Runnable r) {
            sStateHandler.post(r);
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
            HandlerThread st = new HandlerThread(TAG + "State");
            st.start();
            sStateHandler = new Handler(st.getLooper());
            sStateHandler.post(REGISTER_STATE);
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
        boolean signals = callBySignals();
        synchronized (sLock) {
            ensureHandlerLocked();
            mode = sMode;
            sOwed.put(enforcer, Boolean.TRUE);
            if (!sHandler.hasCallbacks(OWED_CHECK)) sHandler.postDelayed(OWED_CHECK, OWED_CHECK_MS);
            if (!listenerSaysCall() && !signalWillReport() && !sHandler.hasCallbacks(RESYNC)) {
                sHandler.postDelayed(RESYNC, NORMAL_GRACE_MS);
                hold(NORMAL_GRACE_MS + 1000); // only posts to the state thread
            }
        }
        if (mode == AudioManager.MODE_NORMAL && !signals) {
            Slog.e(ENFORCER_TAG, "Exception caught from HAL, rebooting HAL in " + NORMAL_GRACE_MS + " ms unless a"
                    + " call starts: " + what);
        } else {
            Slog.w(TAG, "HAL error during a call or before the call state is known (" + callState(mode) + "), not"
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
        // AudioService not resolved yet by the state thread (boot): stock
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
     * setMode() before the listeners are told: an in-process call, lock-free, never blocks; the state thread made the
     * first call, so AudioManager's service lookup is cached). MODE_UNKNOWN only until the state thread has resolved
     * AudioService (boot). Any thread.
     */
    private static int currentMode() {
        int m = sMode;
        if (m != AudioManager.MODE_NORMAL && m != MODE_UNKNOWN) return m;
        AudioManager am = sAm;
        if (am == null) return m;
        try {
            return am.getMode();
        } catch (Throwable t) {
            return m;
        }
    }

    /** A call by the cached non-mode signals (telephony, voice audio); unknown counts, for at most 15 min. Any thread. */
    private static boolean callBySignals() {
        if (sTelBusy || sVoicePlayback || sVoiceRecording) return true;
        return sSignalsUnknown && SystemClock.uptimeMillis() - sSignalsUnknownSince < UNKNOWN_FALLBACK_MS;
    }

    /** A known non-mode signal says call: its end is reported (SIGNALS), so no poll is needed. */
    private static boolean signalWillReport() {
        return sTelBusy || sVoicePlayback || sVoiceRecording;
    }

    /** No call at all: mode (live) NORMAL and no signal. Decision thread / timer thread. */
    private static boolean noCall(int mode) {
        return mode == AudioManager.MODE_NORMAL && !callBySignals();
    }

    private static String callState(int mode) {
        return "mode " + mode + (sTelBusy ? ", telephony call" : "") + (sVoicePlayback ? ", voice/ring playback" : "")
                + (sVoiceRecording ? ", voice recording" : "") + (sSignalsUnknown ? ", call signals not known" : "");
    }

    /** Handler thread: decide for watchdog deadlines (no middleware lock is held here). */
    private static void checkHung() {
        int mode = currentMode();
        List<Hung> reboot = new ArrayList<>();
        List<Hung> deferred = new ArrayList<>();
        boolean free = mode == MODE_UNKNOWN || noCall(mode);
        synchronized (sLock) {
            if (free) {
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
            Slog.e(TAG, "sound trigger HAL call still running after " + WATCHDOG_MS + " ms during a call ("
                    + callState(mode) + "): NOT rebooting the audio HAL (shared with call audio); rebooting it " + (CALL_END_DELAY_MS / 1000)
                    + " s after the call if the call into the HAL is still hung, or at once if it is still hung "
                    + ((HUNG_IN_CALL_MAX_MS + WATCHDOG_MS) / 1000) + " s after it started (dead HAL)", h.where);
        }
        if (!deferred.isEmpty()) {
            if (!sHandler.hasCallbacks(CHECK_HUNG_MAX)) sHandler.postDelayed(CHECK_HUNG_MAX, HUNG_IN_CALL_MAX_MS);
            if (!sHandler.hasCallbacks(OWED_CHECK)) sHandler.postDelayed(OWED_CHECK, OWED_CHECK_MS);
            // only the live mode (or an unknown signal) says call: resync() polls until it agrees
            if (!listenerSaysCall() && !signalWillReport() && !sHandler.hasCallbacks(RESYNC)) {
                sHandler.postDelayed(RESYNC, POLL_MS);
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

    /**
     * State thread: resolve AudioService, register the mode listener, the playback / recording / screen-off callbacks
     * and the telephony call-state callbacks. Every part is retried until it works (1 s for the first minute, then
     * 15 s). sAm is published only after the mode listener is registered and getMode() was called once (so its
     * service lookup is cached and the decision thread's getMode() never looks anything up).
     */
    private static void registerState() {
        boolean retry = false;
        Throwable why = null;
        try {
            Context ctx = ActivityThread.currentActivityThread().getSystemContext();
            if (!sModeWatched) {
                // AudioManager keeps a listener it failed to register with AudioService: only try once it is
                // published, and with a new listener per attempt (re-adding one throws)
                if (ServiceManager.checkService(Context.AUDIO_SERVICE) == null) throw new IllegalStateException("no audio service");
                AudioManager am = ctx.getSystemService(AudioManager.class);
                am.addOnModeChangedListener(EXECUTOR, new AudioManager.OnModeChangedListener() {
                    @Override
                    public void onModeChanged(int mode) {
                        onMode(mode);
                    }
                });
                final int mode = am.getMode();
                sAm = am;
                sModeWatched = true;
                Slog.i(TAG, "watching the audio mode for deferred sound trigger HAL reboots (mode " + mode + ")");
                sHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        onMode(mode);
                    }
                });
            }
            AudioManager am = sAm;
            try {
                if (!sPlaybackWatched) {
                    am.registerAudioPlaybackCallback(new AudioManager.AudioPlaybackCallback() {
                        @Override
                        public void onPlaybackConfigChanged(List<AudioPlaybackConfiguration> configs) {
                            onPlayback(configs);
                        }
                    }, sStateHandler);
                    sPlaybackWatched = true;
                    onPlayback(am.getActivePlaybackConfigurations());
                }
                if (!sRecordingWatched) {
                    am.registerAudioRecordingCallback(new AudioManager.AudioRecordingCallback() {
                        @Override
                        public void onRecordingConfigChanged(List<AudioRecordingConfiguration> configs) {
                            onRecording(configs);
                        }
                    }, sStateHandler);
                    sRecordingWatched = true;
                    onRecording(am.getActiveRecordingConfigurations());
                }
                sAudioSignalsFailed = false;
            } catch (Throwable t) {
                sAudioSignalsFailed = true;
                retry = true;
                why = t;
            }
            if (!sScreenWatched) {
                try {
                    ctx.registerReceiver(new BroadcastReceiver() {
                        @Override
                        public void onReceive(Context c, Intent i) {
                            sHandler.post(SCREEN_OFF);
                        }
                    }, new IntentFilter(Intent.ACTION_SCREEN_OFF), null, sStateHandler, Context.RECEIVER_NOT_EXPORTED);
                    sScreenWatched = true;
                } catch (Throwable t) {
                    retry = true;
                    why = t;
                }
            }
            if (!sTelWatched) {
                try {
                    if (!registerTelephony(ctx)) { // not there yet: no CS call possible meanwhile
                        retry = true;
                        if (why == null) why = new IllegalStateException("no telephony service yet");
                    }
                } catch (Throwable t) {
                    sTelFailed = true;
                    retry = true;
                    why = t;
                }
            }
        } catch (Throwable t) {
            // AudioService not published yet (early boot)
            retry = true;
            why = t;
        }
        updateUnknown();
        if (!retry) {
            if (sStateRegisterTries > 0) Slog.i(TAG, "call state watched (after " + sStateRegisterTries + " retries)");
            sStateRegisterTries = 0;
            return;
        }
        int n = ++sStateRegisterTries;
        if (n == 1 || n == REGISTER_FAST_TRIES || (n > REGISTER_FAST_TRIES && n % 20 == 0)) {
            Slog.w(TAG, "cannot watch the audio mode / call state yet (attempt " + n + "), retrying every "
                    + (n < REGISTER_FAST_TRIES ? "1 s" : "15 s") + ": " + why);
        }
        sStateHandler.postDelayed(REGISTER_STATE, n < REGISTER_FAST_TRIES ? REGISTER_RETRY_FAST_MS : REGISTER_RETRY_MS);
    }

    /**
     * State thread. No telephony service (boot before the phone process, or none at all): no CS call is possible,
     * retried until it appears. Then one TelephonyCallback per active subscription (as SoundTrigger's own
     * PhoneCallStateHandler does), kept in step with subscription changes. Returns false while the telephony
     * services are not published (retry later); throws if registering fails (counted as a call until it works).
     */
    private static boolean registerTelephony(Context ctx) {
        if (ServiceManager.checkService("isub") == null || ServiceManager.checkService("phone") == null) {
            sTelFailed = false;
            return false;
        }
        SubscriptionManager subs = ctx.getSystemService(SubscriptionManager.class);
        TelephonyManager tel = ctx.getSystemService(TelephonyManager.class);
        if (subs == null || tel == null) {
            sTelFailed = false;
            sTelWatched = true; // no telephony on this build
            return true;
        }
        sSubs = subs;
        sTel = tel;
        subs.addOnSubscriptionsChangedListener(STATE_EXECUTOR, new SubscriptionManager.OnSubscriptionsChangedListener() {
            @Override
            public void onSubscriptionsChanged() {
                syncSubscriptions();
            }
        });
        sTelWatched = true;
        syncSubscriptions();
        return true;
    }

    /** State thread: one SubCall per active subscription. */
    private static void syncSubscriptions() {
        try {
            List<SubscriptionInfo> list = sSubs.getActiveSubscriptionInfoList();
            HashSet<Integer> ids = new HashSet<>();
            if (list != null) {
                for (SubscriptionInfo si : list) {
                    if (si != null) ids.add(si.getSubscriptionId());
                }
            }
            for (Iterator<SubCall> it = sSubCalls.values().iterator(); it.hasNext(); ) {
                SubCall c = it.next();
                if (!ids.contains(c.subId)) {
                    it.remove();
                    try {
                        c.tm.unregisterTelephonyCallback(c);
                    } catch (Throwable t) {
                        // gone anyway
                    }
                }
            }
            for (Integer id : ids) {
                if (sSubCalls.containsKey(id)) continue;
                TelephonyManager tm = sTel.createForSubscriptionId(id);
                SubCall c = new SubCall(id, tm);
                // registered first: a registration that throws leaves the sub out, so the retry registers it again.
                // Unknown until its first state arrives (posted to this thread by the registration, so after the put)
                tm.registerTelephonyCallback(STATE_EXECUTOR, c);
                sSubCalls.put(id, c);
            }
            sTelFailed = false;
        } catch (Throwable t) {
            sTelFailed = true;
            Slog.w(TAG, "cannot follow the telephony call state, counting it as a call until it works: " + t);
            sStateHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    syncSubscriptions();
                }
            }, REGISTER_RETRY_MS);
        }
        updateTelephony();
    }

    /** State thread. */
    private static void updateTelephony() {
        boolean busy = false;
        for (SubCall c : sSubCalls.values()) {
            if (c.state != TelephonyManager.CALL_STATE_IDLE && c.state != CALL_STATE_UNKNOWN) busy = true;
        }
        setSignal(0, busy);
    }

    /** State thread: voice / ringtone playback (a call or VoIP that may not set a call mode), and the retry trigger. */
    private static void onPlayback(List<AudioPlaybackConfiguration> configs) {
        boolean active = false;
        boolean voice = false;
        if (configs != null) {
            for (AudioPlaybackConfiguration c : configs) {
                if (c == null || !c.isActive()) continue;
                active = true;
                int u;
                try {
                    u = c.getAudioAttributes().getUsage();
                } catch (Throwable t) {
                    u = -1;
                }
                if (u == AudioAttributes.USAGE_VOICE_COMMUNICATION
                        || u == AudioAttributes.USAGE_VOICE_COMMUNICATION_SIGNALLING
                        || u == AudioAttributes.USAGE_NOTIFICATION_RINGTONE) {
                    voice = true;
                }
            }
        }
        setSignal(1, voice);
        if (active != sAudioActive) {
            sAudioActive = active;
            sHandler.post(active ? AUDIO_STARTED : AUDIO_STOPPED);
        }
    }

    /** State thread. */
    private static void onRecording(List<AudioRecordingConfiguration> configs) {
        boolean voice = false;
        if (configs != null) {
            for (AudioRecordingConfiguration c : configs) {
                if (c == null) continue;
                int src = c.getClientAudioSource();
                if (src == MediaRecorder.AudioSource.VOICE_COMMUNICATION || src == MediaRecorder.AudioSource.VOICE_CALL
                        || src == MediaRecorder.AudioSource.VOICE_UPLINK
                        || src == MediaRecorder.AudioSource.VOICE_DOWNLINK) {
                    voice = true;
                }
            }
        }
        setSignal(2, voice);
    }

    /** State thread: publish one signal; tell the decision thread when "a call by signals" changed. */
    private static void setSignal(int which, boolean on) {
        boolean before = callBySignals();
        if (which == 0) sTelBusy = on;
        else if (which == 1) sVoicePlayback = on;
        else sVoiceRecording = on;
        updateUnknown();
        if (callBySignals() != before) sHandler.post(SIGNALS);
    }

    /** State thread. */
    private static void updateUnknown() {
        boolean before = callBySignals();
        boolean unknown = sTelFailed || sAudioSignalsFailed || (sAm != null && (!sPlaybackWatched || !sRecordingWatched));
        for (SubCall c : sSubCalls.values()) {
            if (c.state == CALL_STATE_UNKNOWN) unknown = true;
        }
        if (unknown && !sSignalsUnknown) sSignalsUnknownSince = SystemClock.uptimeMillis();
        sSignalsUnknown = unknown;
        if (callBySignals() != before) sHandler.post(SIGNALS);
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
        if (mode != AudioManager.MODE_NORMAL || signalWillReport()) {
            sHandler.removeCallbacks(RESYNC);
        } else if (owed) {
            sHandler.removeCallbacks(RESYNC);
            sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
            hold(CALL_END_DELAY_MS + 1000);
        }
    }

    /** Handler thread: a telephony / voice-audio signal started or ended. */
    private static void onCallSignals() {
        boolean owed;
        synchronized (sLock) {
            owed = !sOwed.isEmpty() || !sHung.isEmpty();
        }
        if (listenerSaysCall() || callBySignals()) {
            sHandler.removeCallbacks(RESYNC);
            if (owed && !signalWillReport() && !listenerSaysCall()) {
                sHandler.postDelayed(RESYNC, POLL_MS); // only an unknown signal: poll
            }
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
                sHandler.postDelayed(RESYNC, POLL_MS);
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
        boolean free = noCall(mode);
        synchronized (sLock) {
            if (!free) {
                // still a call. The listener / a known signal reports its end and posts this again; otherwise (only the
                // live mode lagging the listener, or an unknown signal) poll
                if (!listenerSaysCall() && !signalWillReport()) sHandler.postDelayed(RESYNC, POLL_MS);
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

    /** Handler thread, every OWED_CHECK_MS while anything is owed: see OWED_CHECK_MS. */
    private static void owedCheck() {
        boolean any;
        synchronized (sLock) {
            any = !sOwed.isEmpty() || !sHung.isEmpty();
        }
        if (!any) {
            sOwedSeenFree = false;
            return;
        }
        sHandler.postDelayed(OWED_CHECK, OWED_CHECK_MS);
        int live = MODE_UNKNOWN;
        AudioManager am = sAm;
        if (am != null) {
            try {
                live = am.getMode(); // AudioService's own mode, whatever the listener says
            } catch (Throwable t) {
                live = MODE_UNKNOWN;
            }
        }
        if (live != AudioManager.MODE_NORMAL || callBySignals()) {
            sOwedSeenFree = false;
            return;
        }
        if (!sOwedSeenFree) {
            sOwedSeenFree = true;
            return;
        }
        if (!listenerSaysCall() && sHandler.hasCallbacks(RESYNC)) return; // the listener agrees, a resync is due
        sOwedSeenFree = false;
        List<SoundTriggerHalEnforcer> owed;
        List<Hung> hung;
        synchronized (sLock) {
            owed = new ArrayList<>(sOwed.keySet());
            hung = new ArrayList<>(sHung.values());
            sOwed.clear();
            sHung.clear();
        }
        if (owed.isEmpty() && hung.isEmpty()) return;
        Slog.w(TAG, "owed for a while: the audio mode listener says mode " + sMode + ", AudioService has said NORMAL"
                + " with no call signal for " + (OWED_CHECK_MS / 1000) + " s: rebooting the sound trigger HAL now (" + owed.size()
                + " HAL error(s), " + hung.size() + " hung HAL call(s))");
        rebootAll(owed, hung);
    }

    /**
     * Handler thread: one reboot per HAL stack (each reboot is a setprop that restarts the audio HAL). A reboot resyncs
     * everything on that stack, so whatever else it still owes (an owed error with a hung call, or the other way
     * round) is settled with it instead of costing a second audio HAL restart later.
     */
    private static void rebootAll(List<SoundTriggerHalEnforcer> owed, List<Hung> hung) {
        IdentityHashMap<SoundTriggerHalWatchdog, Boolean> stacks = new IdentityHashMap<>();
        for (SoundTriggerHalEnforcer enforcer : owed) {
            if (enforcer.mUnderlying != null) stacks.put(enforcer.mUnderlying, Boolean.TRUE);
        }
        for (Hung h : hung) stacks.put(h.hal, Boolean.TRUE);
        synchronized (sLock) {
            for (Iterator<SoundTriggerHalEnforcer> it = sOwed.keySet().iterator(); it.hasNext(); ) {
                if (stacks.containsKey(it.next().mUnderlying)) it.remove();
            }
            for (Iterator<Hung> it = sHung.values().iterator(); it.hasNext(); ) {
                if (stacks.containsKey(it.next().hal)) it.remove();
            }
        }
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

    private static final Runnable AUDIO_STARTED = new Runnable() {
        @Override
        public void run() {
            if ("audio stopped".equals(sReason)) sHandler.removeCallbacks(FIRE);
        }
    };
    private static final Runnable AUDIO_STOPPED = new Runnable() {
        @Override
        public void run() {
            schedule(AUDIO_IDLE_DELAY_MS, "audio stopped");
        }
    };
    private static final Runnable SCREEN_OFF = new Runnable() {
        @Override
        public void run() {
            schedule(SCREEN_OFF_DELAY_MS, "screen off");
        }
    };

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
     * A partial wakelock for ms (timeout, never released by hand), so a retry / reboot posted a few seconds ahead runs
     * on time and not at the next wakeup (screen-off retry, 3 s grace, after-call resync). Any thread: PowerManager
     * (its own lock, a binder call the first time) is only called on the state thread.
     */
    private static void hold(final long ms) {
        final long until = SystemClock.uptimeMillis() + ms;
        sStateHandler.post(new Runnable() {
            @Override
            public void run() {
                acquire(until);
            }
        });
    }

    /** State thread. */
    private static void acquire(long until) {
        long ms = until - SystemClock.uptimeMillis();
        if (until <= sWakeUntil || ms <= 0) return;
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
