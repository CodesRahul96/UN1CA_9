package android.os;
public final class Looper {
    private static final Looper MAIN = new Looper();
    final java.util.List<Object[]> queue = new java.util.ArrayList<>(); // {Handler, Runnable, Long when, Long seq}
    long seq;
    public static Looper getMainLooper() { return MAIN; }
    public static Looper myLooper() { return MAIN; }
    /** Runs everything due up to now + ms, in time order, advancing the virtual clock. */
    public static void advance(long ms) {
        long end = SystemClock.now + ms;
        while (true) {
            Object[] next = null;
            for (Object[] m : MAIN.queue) {
                if ((Long) m[2] <= end && (next == null || (Long) m[2] < (Long) next[2]
                        || ((Long) m[2]).equals(next[2]) && (Long) m[3] < (Long) next[3])) {
                    next = m;
                }
            }
            if (next == null) break;
            MAIN.queue.remove(next);
            SystemClock.now = Math.max(SystemClock.now, (Long) next[2]);
            ((Runnable) next[1]).run();
        }
        SystemClock.now = end;
    }
    public static void reset() { MAIN.queue.clear(); }
}
