// Source of ../../../../../K4PureBlackPreferenceController.smali (regenerate with ../../../../build.sh, which also puts
// the comment block below at the top of the smali). stubs/ only mirror the SecSettings classes it links against.
package com.k4.settings.display;

import android.content.om.OverlayInfo;
import android.content.om.OverlayManager;
import android.os.Process;
import android.util.Log;

public class K4PureBlackPreferenceController extends com.android.settings.display.HdrBrightnessPreferenceController implements Runnable {
    // All requests, from every controller instance, go through one worker at a time; it applies the newest state and
    // loops until no newer request came in while its binder call ran. Guarded by the class object.
    private static boolean sWant;
    private static int sSeq;
    private static boolean sRunning;

    public K4PureBlackPreferenceController(android.content.Context context, String key) {
        super(context, key);
    }

    private OverlayInfo info() {
        try {
            OverlayManager om = mContext.getSystemService(OverlayManager.class);
            if (om == null) return null;
            return om.getOverlayInfo("com.k4.overlay.pureblack", Process.myUserHandle());
        } catch (RuntimeException e) {
            return null;
        }
    }

    @Override
    public int getAvailabilityStatus() {
        return info() != null ? 0 : 3;
    }

    @Override
    public boolean isChecked() {
        synchronized (K4PureBlackPreferenceController.class) {
            if (sRunning) return sWant;
        }
        OverlayInfo i = info();
        return i != null && i.isEnabled();
    }

    @Override
    public boolean setChecked(boolean checked) {
        boolean start;
        synchronized (K4PureBlackPreferenceController.class) {
            sWant = checked;
            sSeq++;
            start = !sRunning;
            sRunning = true;
        }
        if (start) new Thread(this, "K4PureBlack").start();
        return true;
    }

    @Override
    public void run() {
        for (;;) {
            boolean want;
            int seq;
            synchronized (K4PureBlackPreferenceController.class) {
                want = sWant;
                seq = sSeq;
            }
            try {
                OverlayManager om = mContext.getSystemService(OverlayManager.class);
                om.setEnabled("com.k4.overlay.pureblack", want, Process.myUserHandle());
            } catch (RuntimeException e) {
                Log.w("K4PureBlack", "Could not switch the pure black overlay", e);
            }
            synchronized (K4PureBlackPreferenceController.class) {
                if (sSeq == seq) {
                    sRunning = false;
                    return;
                }
            }
        }
    }
}
