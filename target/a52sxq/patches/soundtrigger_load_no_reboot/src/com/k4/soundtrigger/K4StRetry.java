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
import android.util.Slog;

import com.android.server.soundtrigger_middleware.HalException;
import com.android.server.soundtrigger_middleware.ISoundTriggerHal;
import com.android.server.soundtrigger_middleware.RecoverableException;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;

/**
 * Called from SoundTriggerHalEnforcer (patches/soundtrigger_load_no_reboot).
 *
 * The A52s sound trigger HAL is HIDL 2.3 (QTI st-hal in the audio HAL process). When it cannot open an ADSP
 * listen (LSM) session it fails loadSoundModel/loadPhraseSoundModel with a plain status (-ENODEV from ape_reg_sm,
 * "pcm_is_ready failed ... pcmC0D10c: Out of memory"; tester log 2026-10-20, "Hey Google" model 7038ddc8 while
 * audio was playing). AIDL HALs report such a refusal as RESOURCE_CONTENTION and call onResourcesAvailable() once
 * the resource is free; SoundTriggerHelper then keeps the model requested, tells the client
 * onRecognitionPaused() and loads it again on onResourcesAvailable(). A HIDL 2.x HAL has no such callback, so
 * this class provides both halves:
 *  - refused(): -ENODEV/-EBUSY/-ENOMEM/-EAGAIN -> RecoverableException(RESOURCE_CONTENTION) (client sees
 *    STATUS_BUSY, stays requested); any other status -> RecoverableException(INTERNAL_ERROR) as in 9.3.63.
 *    Never a HAL reboot (that restarts all audio on this vendor).
 *  - while a refusal is pending: onResourcesAvailable() on that HAL stack's global callback when the HAL's
 *    concurrency ends: all playback stopped (+5 s: audio HAL output standby lags the player state) or the
 *    screen turned off (+2 s: the HAL switches to the LPI path). One retry per event, no timers, so a HAL that
 *    keeps refusing costs one load attempt per event.
 */
public final class K4StRetry {
    private static final String TAG = "K4StRetry";
    private static final int RESOURCE_CONTENTION = 1;
    private static final int INTERNAL_ERROR = 5;
    private static final long AUDIO_IDLE_DELAY_MS = 5000;
    private static final long SCREEN_OFF_DELAY_MS = 2000;

    private static final Object sLock = new Object();
    /** SoundTriggerHalEnforcer -> the global callback registered on it (one per HAL stack). */
    private static final IdentityHashMap<Object, ISoundTriggerHal.GlobalCallback> sCallbacks = new IdentityHashMap<>();
    /** Enforcers with a load refused since the last retry. */
    private static final IdentityHashMap<Object, Boolean> sPending = new IdentityHashMap<>();
    private static Handler sHandler;
    private static boolean sAudioActive;
    private static boolean sAudioWatched;
    private static boolean sScreenWatched;
    private static String sReason;

    private static final Runnable FIRE = new Runnable() {
        @Override
        public void run() {
            fire();
        }
    };
    private static final Runnable REGISTER = new Runnable() {
        @Override
        public void run() {
            registerListeners();
        }
    };

    private K4StRetry() {}

    /** First thing in SoundTriggerHalEnforcer.registerCallback. */
    public static void setCallback(Object enforcer, ISoundTriggerHal.GlobalCallback cb) {
        synchronized (sLock) {
            sCallbacks.put(enforcer, cb);
        }
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
            if (sHandler == null) {
                HandlerThread t = new HandlerThread(TAG);
                t.start();
                sHandler = new Handler(t.getLooper());
                sHandler.post(REGISTER);
            }
        }
        return new RecoverableException(RESOURCE_CONTENTION, msg);
    }

    /** Handler thread. */
    private static void registerListeners() {
        try {
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
            sHandler.postDelayed(REGISTER, 30000);
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
