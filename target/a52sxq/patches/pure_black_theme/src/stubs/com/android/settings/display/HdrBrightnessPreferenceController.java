package com.android.settings.display;

public class HdrBrightnessPreferenceController extends com.android.settingslib.core.AbstractPreferenceController {
    public HdrBrightnessPreferenceController(android.content.Context context, String key) {
    }

    public int getAvailabilityStatus() { return 0; }

    public boolean isChecked() { return false; }

    public boolean setChecked(boolean checked) { return false; }
}
