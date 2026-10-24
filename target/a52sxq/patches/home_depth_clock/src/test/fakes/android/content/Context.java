package android.content;
/** Host fake: only what EngineState / HomeDepthClock call; one process-wide receiver list. */
public class Context {
    public static final int RECEIVER_EXPORTED = 2;
    public static final int RECEIVER_NOT_EXPORTED = 4;
    public static final java.util.Map<BroadcastReceiver, IntentFilter> RECEIVERS = new java.util.LinkedHashMap<>();
    private final ContentResolver resolver = new ContentResolver();
    public Context() {}
    public Context getApplicationContext() { return this; }
    public ContentResolver getContentResolver() { return resolver; }
    private final android.os.PowerManager power = new android.os.PowerManager();
    @SuppressWarnings("unchecked")
    public <T> T getSystemService(Class<T> c) { return c == android.os.PowerManager.class ? (T) power : null; }
    public Intent registerReceiver(BroadcastReceiver r, IntentFilter f, String perm, android.os.Handler h, int flags) { RECEIVERS.put(r, f); return null; }
    public Intent registerReceiver(BroadcastReceiver r, IntentFilter f, int flags) { RECEIVERS.put(r, f); return null; }
    public void unregisterReceiver(BroadcastReceiver r) { if (RECEIVERS.remove(r) == null) throw new IllegalArgumentException("not registered"); }
    /** Delivers to the receivers registered now (as an enqueued broadcast does). */
    public static void broadcast(Intent i) {
        for (java.util.Map.Entry<BroadcastReceiver, IntentFilter> e : new java.util.ArrayList<>(RECEIVERS.entrySet())) {
            if (e.getValue().actions.contains(i.getAction())) e.getKey().onReceive(null, i);
        }
    }
}
