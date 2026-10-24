package android.content;
public class Intent {
    public static final String ACTION_TIME_TICK = "android.intent.action.TIME_TICK";
    public static final String ACTION_TIME_CHANGED = "android.intent.action.TIME_SET";
    public static final String ACTION_TIMEZONE_CHANGED = "android.intent.action.TIMEZONE_CHANGED";
    public static final String ACTION_LOCALE_CHANGED = "android.intent.action.LOCALE_CHANGED";
    private final String action;
    private final java.util.Map<String, Object> extras = new java.util.HashMap<>();
    public Intent(String a) { action = a; }
    public String getAction() { return action; }
    public Intent putExtra(String k, boolean v) { extras.put(k, v); return this; }
    public boolean getBooleanExtra(String k, boolean d) { Object v = extras.get(k); return v instanceof Boolean ? (Boolean) v : d; }
}
