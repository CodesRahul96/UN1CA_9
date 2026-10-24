package android.util;
public final class Log {
    public static final java.util.List<String> LINES = new java.util.ArrayList<>();
    public static boolean echo = Boolean.getBoolean("echo");
    private static int add(String l, String tag, String msg, Throwable t) {
        String s = l + "/" + tag + ": " + msg + (t != null ? " " + t : "");
        LINES.add(s);
        if (echo) System.out.println("    " + s);
        return 0;
    }
    public static int d(String t, String m) { return add("D", t, m, null); }
    public static int i(String t, String m) { return add("I", t, m, null); }
    public static int w(String t, String m) { return add("W", t, m, null); }
    public static int w(String t, String m, Throwable e) { return add("W", t, m, e); }
    public static int e(String t, String m) { return add("E", t, m, null); }
    public static int e(String t, String m, Throwable e) { return add("E", t, m, e); }
}
