package android.os;
public class SemSystemProperties {
    public static final java.util.Map<String, String> P = new java.util.HashMap<>();
    public static String get(String k) { return P.getOrDefault(k, ""); }
}
