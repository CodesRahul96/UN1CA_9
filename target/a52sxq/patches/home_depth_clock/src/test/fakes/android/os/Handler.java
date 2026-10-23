package android.os;
public class Handler {
    private final Looper looper;
    public Handler(Looper l) { looper = l; }
    public final boolean post(Runnable r) { return postDelayed(r, 0); }
    public final boolean postDelayed(Runnable r, long ms) {
        looper.queue.add(new Object[] {this, r, SystemClock.now + ms, looper.seq++});
        return true;
    }
    public final void removeCallbacks(Runnable r) { looper.queue.removeIf(m -> m[0] == this && m[1] == r); }
    public final boolean hasCallbacks(Runnable r) { return looper.queue.stream().anyMatch(m -> m[0] == this && m[1] == r); }
}
