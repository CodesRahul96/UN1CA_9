package android.provider;
public final class Settings {
    public static final class System {
        public static final java.util.Map<String, String> S = new java.util.HashMap<>();
        public static String getString(android.content.ContentResolver r, String k) { return S.get(k); }
    }
}
