package com.android.settings.core;
public abstract class BasePreferenceController extends com.android.settingslib.core.AbstractPreferenceController {
    public BasePreferenceController(android.content.Context context, String key) { super(context); }
    public abstract int getAvailabilityStatus();
    public String getPreferenceKey() { throw new RuntimeException("stub"); }
}
