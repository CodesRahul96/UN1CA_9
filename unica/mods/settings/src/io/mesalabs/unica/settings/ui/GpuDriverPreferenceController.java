package io.mesalabs.unica.settings.ui;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.os.SemSystemProperties;

import androidx.appcompat.app.AlertDialog;
import androidx.preference.DropDownPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceScreen;

import com.android.settings.core.BasePreferenceController;
import com.android.settingslib.widget.BannerMessagePreference;

import io.mesalabs.unica.utils.Utils;

/**
 * Settings > K4_UN1CA > UI > GPU driver (unica_ui_settings.xml: k4_gpu_driver_active, k4_gpu_driver, k4_gpu_driver_restart).
 *
 * Only shown when the target ships a selector (ro.k4.gpu_drivers = "<default> <alternative>...", e.g.
 * target/a52sxq/patches/adreno_driver, whose /system/etc/init/k4_gpu_driver.rc does the switch at early-boot).
 * persist.sys.k4.gpu_driver = selected driver, persist.sys.k4.gpu_trial = pending/testing/ok/failed (boot failsafe),
 * persist.sys.k4.gpu_failed = driver whose boot never completed, sys.k4.gpu_active = what this boot mounted.
 * A change only takes effect after a restart (the GPU microcode is loaded once per boot), so the page shows the active
 * driver, the selected one, and a banner with a restart button whenever they differ.
 */
public class GpuDriverPreferenceController extends BasePreferenceController
        implements Preference.OnPreferenceChangeListener {
    private static final String KEY_ACTIVE = "k4_gpu_driver_active";
    private static final String KEY_BANNER = "k4_gpu_driver_restart";
    private static final String PROP_DRIVERS = "ro.k4.gpu_drivers";
    private static final String PROP_SELECTED = "persist.sys.k4.gpu_driver";
    private static final String PROP_TRIAL = "persist.sys.k4.gpu_trial";
    private static final String PROP_FAILED = "persist.sys.k4.gpu_failed";
    private static final String PROP_ACTIVE = "sys.k4.gpu_active";
    private static final int COLOR_PENDING = Color.rgb(0xF5, 0x7C, 0x00);

    private DropDownPreference mPref;
    private Preference mActive;
    private BannerMessagePreference mBanner;
    private AlertDialog mRebootDialog;

    public GpuDriverPreferenceController(Context context, String key) {
        super(context, key);
    }

    @Override
    public int getAvailabilityStatus() {
        return drivers().length > 1 ? 0 /* AVAILABLE */ : 3 /* UNSUPPORTED_ON_DEVICE */;
    }

    @Override
    public void displayPreference(PreferenceScreen screen) {
        super.displayPreference(screen);
        mPref = (DropDownPreference) screen.findPreference(getPreferenceKey());
        mActive = screen.findPreference(KEY_ACTIVE);
        mBanner = (BannerMessagePreference) screen.findPreference(KEY_BANNER);
        if (mPref != null) mPref.setOnPreferenceChangeListener(this);
        if (mBanner != null) {
            mBanner.setNegativeButtonVisible(false);
            mBanner.setPositiveButtonOnClickListener(v -> onBannerButton());
        }
        boolean available = getAvailabilityStatus() == 0;
        if (mActive != null) mActive.setVisible(available);
        if (mBanner != null) mBanner.setVisible(false);
        refresh();
    }

    @Override
    public void updateState(Preference preference) {
        super.updateState(preference);
        refresh();
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        String value = String.valueOf(newValue);
        if (!isKnown(value)) return false;
        SemSystemProperties.set(PROP_SELECTED, value);
        SemSystemProperties.set(PROP_TRIAL, value.equals(active()) ? "ok" : "pending");
        SemSystemProperties.set(PROP_FAILED, "");
        refresh();
        return true;
    }

    private void onBannerButton() {
        if (!failed().isEmpty() && selected().equals(active())) {
            // "Driver could not start" notice: acknowledged
            SemSystemProperties.set(PROP_FAILED, "");
            SemSystemProperties.set(PROP_TRIAL, "ok");
            refresh();
            return;
        }
        if (mRebootDialog == null) mRebootDialog = Utils.createRebootDialog(mContext);
        mRebootDialog.show();
    }

    private void refresh() {
        if (mPref == null || getAvailabilityStatus() != 0) return;
        String selected = selected();
        String active = active();
        String failed = failed();
        boolean pending = !selected.equals(active);

        mPref.setValue(selected);
        if (pending) {
            mPref.setSummary(string("k4_gpu_driver_selected_pending", label(selected)));
            mPref.seslSetSummaryColor(COLOR_PENDING);
        } else {
            mPref.setSummary(string("k4_gpu_driver_selected_active", label(selected)));
        }
        if (mActive != null) mActive.setSummary(label(active));

        if (mBanner == null) return;
        if (pending) {
            mBanner.setTitle(string("k4_gpu_driver_restart_title"));
            mBanner.setSummary(string("k4_gpu_driver_restart_summary", label(selected), label(active)));
            mBanner.setAttentionLevel(BannerMessagePreference.AttentionLevel.HIGH);
            mBanner.setPositiveButtonText(string("k4_gpu_driver_restart_button"));
            mBanner.setPositiveButtonVisible(true);
            mBanner.setVisible(true);
        } else if (!failed.isEmpty()) {
            mBanner.setTitle(string("k4_gpu_driver_failed_title"));
            mBanner.setSummary(string("k4_gpu_driver_failed_summary", label(failed), label(active)));
            mBanner.setAttentionLevel(BannerMessagePreference.AttentionLevel.MEDIUM);
            mBanner.setPositiveButtonText(string("k4_gpu_driver_failed_button"));
            mBanner.setPositiveButtonVisible(true);
            mBanner.setVisible(true);
        } else {
            mBanner.setVisible(false);
        }
    }

    private static String[] drivers() {
        String s = SemSystemProperties.get(PROP_DRIVERS, "").trim();
        return s.isEmpty() ? new String[0] : s.split("\\s+");
    }

    private static String defaultDriver() {
        String[] d = drivers();
        return d.length > 0 ? d[0] : "";
    }

    private static boolean isKnown(String v) {
        for (String d : drivers()) if (d.equals(v)) return true;
        return false;
    }

    private static String selected() {
        String s = SemSystemProperties.get(PROP_SELECTED, "");
        return isKnown(s) ? s : defaultDriver();
    }

    private static String active() {
        String s = SemSystemProperties.get(PROP_ACTIVE, "");
        return isKnown(s) ? s : defaultDriver();
    }

    private static String failed() {
        String s = SemSystemProperties.get(PROP_FAILED, "");
        return isKnown(s) ? s : "";
    }

    /** Entry label for a driver version, from the k4_gpu_driver_entries/values arrays; falls back to "V@0<ver>". */
    private String label(String v) {
        try {
            Resources res = mContext.getResources();
            String[] values = res.getStringArray(Utils.getResourceId("array", "k4_gpu_driver_values"));
            String[] entries = res.getStringArray(Utils.getResourceId("array", "k4_gpu_driver_entries"));
            for (int i = 0; i < values.length && i < entries.length; i++) {
                if (values[i].equals(v)) return entries[i];
            }
        } catch (Resources.NotFoundException ignored) {
        }
        return "V@0" + v;
    }

    private String string(String name, Object... args) {
        return mContext.getString(Utils.getResourceId("string", name), args);
    }
}
