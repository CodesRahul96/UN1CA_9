package androidx.preference;
public class Preference {
    public interface OnPreferenceChangeListener { boolean onPreferenceChange(Preference preference, Object newValue); }
    public final android.content.Context getContext() { throw new RuntimeException("stub"); }
    public void setTitle(CharSequence title) { throw new RuntimeException("stub"); }
    public void setSummary(CharSequence summary) { throw new RuntimeException("stub"); }
    public final void setVisible(boolean visible) { throw new RuntimeException("stub"); }
    public void setEnabled(boolean enabled) { throw new RuntimeException("stub"); }
    public void seslSetSummaryColor(int color) { throw new RuntimeException("stub"); }
    public void setOnPreferenceChangeListener(OnPreferenceChangeListener l) { throw new RuntimeException("stub"); }
}
