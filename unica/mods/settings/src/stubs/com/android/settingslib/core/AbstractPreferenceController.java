package com.android.settingslib.core;
public abstract class AbstractPreferenceController {
    protected final android.content.Context mContext;
    public AbstractPreferenceController(android.content.Context context) { mContext = context; }
    public void displayPreference(androidx.preference.PreferenceScreen screen) { throw new RuntimeException("stub"); }
    public void updateState(androidx.preference.Preference preference) { throw new RuntimeException("stub"); }
    public abstract String getPreferenceKey();
}
