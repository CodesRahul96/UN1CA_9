package android.os;
/** Host fake: a virtual clock the test advances (Looper.advance). */
public final class SystemClock {
    public static long now = 1_000_000L;
    public static long elapsedRealtime() { return now; }
    public static long uptimeMillis() { return now; }
}
