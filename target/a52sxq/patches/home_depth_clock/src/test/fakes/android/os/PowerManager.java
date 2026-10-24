package android.os;
/** Host fake: interactive set by the test (false from the power key on, as the real one). */
public final class PowerManager {
    public static boolean interactive = true;
    public boolean isInteractive() { return interactive; }
}
