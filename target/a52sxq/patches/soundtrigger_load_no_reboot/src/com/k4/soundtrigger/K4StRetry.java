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
import android.os.ServiceManager;
import android.util.Slog;

import com.android.server.soundtrigger_middleware.HalException;
import com.android.server.soundtrigger_middleware.ISoundTriggerHal;
import com.android.server.soundtrigger_middleware.RecoverableException;
import com.android.server.soundtrigger_middleware.SoundTriggerHalEnforcer;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.concurrent.Executor;

/**
 * Called from SoundTriggerHalEnforcer (patches/soundtrigger_load_no_reboot and soundtrigger_no_hal_reboot).
 *
 * On the A52s the sound trigger HAL (HIDL 2.3, QTI st-hal) lives inside the audio HAL process, so
 * SoundTriggerHalEnforcer.reboot() (setprop sys.audio.restart.hal 1) restarts the whole audio HAL: a running call
 * loses its voice/VoIP audio both ways, audioserver restarts.
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
 * 2. Every other HAL error (halError(), callbackError(), soundtrigger_no_hal_reboot). Stock reboots the HAL. That
 *    reboot is also what resyncs the middleware with the HAL after a failed state change: stopRecognition leaves
 *    the enforcer's model PENDING_STOP and a failed unloadSoundModel keeps the model in its table (both are reset
 *    only on success, as are SoundTriggerModule / Validation / SoundTriggerHelper above it). The HAL death that
 *    follows the reboot makes SoundTriggerModule.binderDied() detach the old stack, attach a fresh one and send
 *    onModuleDied() to every client, which clears and reloads all models. So:
 *     - audio mode NORMAL (no call, no VoIP, not ringing): stock, reboot now.
 *     - any other audio mode, or the mode is not known yet: no reboot; a HalException becomes
 *       RecoverableException(INTERNAL_ERROR), a callback contract violation drops the event (as stock does after
 *       its reboot). The resync reboot is owed and runs once the mode is NORMAL again (+5 s, cancelled if a call
 *       starts again). Not needed any more if that HAL stack dies on its own before (detached()).
 *    SoundTriggerHalWatchdog timeouts (a hung HAL call) still reboot at once, as in stock: deferring them would
 *    keep the middleware's binder callers blocked for the whole call.
 */
public final class K4StRetry {
    private static final String TAG = "K4StRetry";
    private static final String ENFORCER_TAG = "SoundTriggerHalEnforcer";
    private static final int RESOURCE_CONTENTION = 1;
    private static final int INTERNAL_ERROR = 5;
    private static final long AUDIO_IDLE_DELAY_MS = 5000;
    private static final long SCREEN_OFF_DELAY_MS = 2000;
    private static final long CALL_END_DELAY_MS = 5000;
    private static final long REGISTER_RETRY_MS = 15000;
    /** sMode before the mode listener is registered: treated like a call (defer). */
    private static final int MODE_UNKNOWN = -100;

    private static final Object sLock = new Object();
    /** SoundTriggerHalEnforcer -> the global callback registered on it (one per attached HAL stack). */
    private static final IdentityHashMap<Object, ISoundTriggerHal.GlobalCallback> sCallbacks = new IdentityHashMap<>();
    /** Enforcers with a load refused since the last retry. */
    private static final IdentityHashMap<Object, Boolean> sPending = new IdentityHashMap<>();
    /** Enforcers that owe a resync reboot (HAL error during a call). */
    private static final IdentityHashMap<SoundTriggerHalEnforcer, Boolean> sOwed = new IdentityHashMap<>();
    private static Handler sHandler;
    private static volatile int sMode = MODE_UNKNOWN;
    private static boolean sModeWatched;
    private static boolean sModeRegisterFailed;
    private static boolean sAudioActive;
    private static boolean sAudioWatched;
    private static boolean sScreenWatched;
    private static boolean sRetryRegisterPosted;
    private static String sReason;

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
        synchronized (sLock) {
            sCallbacks.remove(enforcer);
            sPending.remove(enforcer);
            owed = sOwed.remove(enforcer) != null;
        }
        if (owed) Slog.i(TAG, "HAL died: the deferred sound trigger HAL reboot is no longer needed");
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
        if (rebootOrDefer(enforcer, e.toString())) return e;
        if (e instanceof HalException) return new RecoverableException(INTERNAL_ERROR, e.toString());
        return e;
    }

    /** SoundTriggerHalEnforcer$ModelCallbackEnforcer contract checks, replaces this$0.reboot(); the event is dropped. */
    public static void callbackError(SoundTriggerHalEnforcer enforcer) {
        rebootOrDefer(enforcer, "HAL callback broke the sound trigger contract");
    }

    /** Returns true if the HAL was rebooted now (stock), false if the reboot is owed until the call ends. */
    private static boolean rebootOrDefer(SoundTriggerHalEnforcer enforcer, String what) {
        int mode;
        synchronized (sLock) {
            ensureHandlerLocked();
            mode = sMode;
            if (mode == AudioManager.MODE_NORMAL) {
                sOwed.remove(enforcer);
            } else {
                sOwed.put(enforcer, Boolean.TRUE);
            }
        }
        if (mode == AudioManager.MODE_NORMAL) {
            Slog.e(ENFORCER_TAG, "Exception caught from HAL, rebooting HAL");
            enforcer.reboot();
            return true;
        }
        Slog.w(TAG, "HAL error during a call or before the audio mode is known (mode " + mode + "), not rebooting"
                + " the HAL (shared with call audio); resync reboot once the call ends: " + what);
        return false;
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
            int mode = am.getMode();
            Slog.i(TAG, "watching the audio mode for deferred sound trigger HAL reboots (mode " + mode + ")");
            onMode(mode);
        } catch (Throwable t) {
            // AudioService not published yet (early boot): reboots stay deferred until the mode is known
            if (!sModeRegisterFailed) {
                sModeRegisterFailed = true;
                Slog.w(TAG, "cannot watch the audio mode yet, retrying every 15 s: " + t);
            }
            sHandler.postDelayed(REGISTER_MODE, REGISTER_RETRY_MS);
        }
    }

    /** Handler thread. */
    private static void onMode(int mode) {
        boolean owed;
        synchronized (sLock) {
            sMode = mode;
            owed = !sOwed.isEmpty();
        }
        if (mode != AudioManager.MODE_NORMAL) {
            sHandler.removeCallbacks(RESYNC);
        } else if (owed) {
            sHandler.removeCallbacks(RESYNC);
            sHandler.postDelayed(RESYNC, CALL_END_DELAY_MS);
        }
    }

    /** Handler thread: the call is over, run the reboot the HAL errors during it would have done. */
    private static void resync() {
        List<SoundTriggerHalEnforcer> owed;
        synchronized (sLock) {
            if (sMode != AudioManager.MODE_NORMAL) return;
            owed = new ArrayList<>(sOwed.keySet());
            sOwed.clear();
        }
        for (SoundTriggerHalEnforcer enforcer : owed) {
            Slog.w(TAG, "call ended: rebooting the sound trigger HAL now to resync it with the middleware"
                    + " (HAL error during the call)");
            try {
                enforcer.reboot();
            } catch (Throwable t) {
                Slog.e(TAG, "deferred HAL reboot failed", t);
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
    }

    /** Handler thread. */
    private static void fire() {
        List<ISoundTriggerHal.GlobalCallback> cbs = new ArrayList<>();
        synchronized (sLock) {
            for (Object enforcer : sPending.keySet()) {
                ISoundTriggerHal.GlobalCallback cb = sCallbacks.get(enforcer);
                if (cb != null) cbs.add(cb);
            }
            sPending.clear();
        }
        for (ISoundTriggerHal.GlobalCallback cb : cbs) {
            Slog.i(TAG, sReason + ": resources available, loading refused sound models again");
            try {
                cb.onResourcesAvailable();
            } catch (Throwable t) {
                Slog.e(TAG, "onResourcesAvailable failed", t);
            }
        }
    }
}
