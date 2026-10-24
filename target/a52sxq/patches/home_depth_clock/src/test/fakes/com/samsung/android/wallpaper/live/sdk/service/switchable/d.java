package com.samsung.android.wallpaper.live.sdk.service.switchable;
/** Host fake sub engine: which / preview / display state set by the test, stopSelf counted. */
public abstract class d {
    public int which = 1;
    public boolean preview;
    public B2.a display = B2.a.ON;
    public int stops;
    public android.content.Context ctx = new android.content.Context();
    public android.view.SurfaceHolder getSurfaceHolder() { return null; }
    public android.content.Context getAppContext() { return ctx; }
    public int getWhich() { return which; }
    public boolean isVisible() { return false; }
    public boolean isPreview() { return preview; }
    public B2.a getDisplayState() { return display; }
    public void stopSelf() { stops++; }
}
