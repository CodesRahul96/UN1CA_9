package android.content;
public class IntentFilter {
    public final java.util.List<String> actions = new java.util.ArrayList<>();
    public IntentFilter(String a) { actions.add(a); }
    public final void addAction(String a) { actions.add(a); }
}
