package com.k4.dressroom;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import java.lang.ref.WeakReference;
import java.lang.reflect.Method;
import java.util.WeakHashMap;

/**
 * Frame size in the Home editor's frame layouts: two fingers pinching on the frame (a gesture that starts where the
 * frame's plates are drawn, outside its hole) make the frame's hole bigger or smaller, about the hole's middle.
 * <p>
 * Samsung shows a frame as plate images (FRAME_BASE, FRAME_BOTTOM) at a fixed scale; the frame resource's ratios only
 * place them, and the save describes each frame layer as a crop of its plate image (setWallpaper.xml) computed from those
 * ratios (SaveImageMaker.g). So the size lives in three places, all about the hole's middle:
 * <ul>
 * <li>the plates are drawn scaled ({@link #drawPlate}, MaskImageView.onDraw of the plate views);</li>
 * <li>the hole (CropImageView.mFrameBounds of the picture and subject views) is scaled, with the picture's minimum zoom
 * Samsung derives from it, and the picture grown when it no longer covers a bigger hole ({@link #applyHole});</li>
 * <li>the save's frame layer crops are scaled ({@link #saveRatios});</li>
 * <li>the frame paths Samsung fits the clock to are scaled ({@link #framePath}), and sent again with the subject region
 * when the size changes.</li>
 * </ul>
 * A frame change (another frame, or a new editor) starts from Samsung's size again ({@link #reset}).
 */
public final class FrameSize {
    static final String TAG = HomeClock.TAG;
    /** Largest hole, against Samsung's size (smallest: as long as the base plate still covers the screen). */
    static final float MAX = 1.6f;

    /** Kept size (1 = Samsung's), and the extra factor while the fingers move. */
    private static volatile float sScale = 1f;
    private static volatile float sLive = 1f;
    /** The hole's middle and the frame views' size (view coordinates), for the save. */
    private static volatile float sHx, sHy, sVw, sVh;
    private static float sMin, sMax, sBase, sSpan0;
    private static int sCount;
    private static boolean sGesture;
    /** Samsung's hole per view, and the scaled hole last set on it. */
    private static final WeakHashMap<View, RectF[]> sHoles = new WeakHashMap<>();

    private FrameSize() {}

    static void reset() {
        sScale = 1f;
        sLive = 1f;
        sGesture = false;
        synchronized (sHoles) {
            sHoles.clear();
        }
    }

    /** No longer used: the frame is never rebuilt by FrameSize. */
    static boolean relayoutDone() {
        return false;
    }

    static float scaled() {
        return sScale * sLive;
    }

    // ---- gesture ----

    /** CropImageView touch in a frame layout: true while this gesture sizes the frame (Samsung must not see it). */
    static boolean touch(View v, MotionEvent e) {
        int act = e.getActionMasked();
        try {
            if (act == MotionEvent.ACTION_DOWN) {
                applyHole(v); // Samsung may have set the hole again (colour, alpha)
                boolean plate = onPlate(v, e.getX(), e.getY());
                sGesture = plate && begin(v);
                sCount = 0;
                Log.i(TAG, String.format(java.util.Locale.US, "frame size: touch at %.0f,%.0f on the %s", e.getX(), e.getY(),
                        plate ? (sGesture ? "frame" : "frame (cannot size it)") : "picture"));
            }
            if (!sGesture) {
                return false;
            }
            int skip = act == MotionEvent.ACTION_POINTER_UP || act == MotionEvent.ACTION_UP ? e.getActionIndex() : -1;
            int n = e.getPointerCount() - (skip >= 0 ? 1 : 0);
            float span = EditXf.span(e, skip);
            if (n != sCount || act != MotionEvent.ACTION_MOVE) {
                sCount = n;
                sSpan0 = span;
                sBase = sLive;
            } else if (n >= 2 && sSpan0 > 1f && span > 1f) {
                float live = Math.max(sMin, Math.min(sMax, sBase * span / sSpan0));
                if (live != sLive) {
                    sLive = live;
                    EditXf.redraw(v);
                }
            }
            if (act == MotionEvent.ACTION_UP || act == MotionEvent.ACTION_CANCEL) {
                sGesture = false;
                float live = sLive;
                sScale *= live;
                sLive = 1f;
                if (Math.abs(live - 1f) > 0.002f) {
                    applyHole(v);
                    refit(v);
                    Log.i(TAG, String.format(java.util.Locale.US, "frame size: %.3f of Samsung's", sScale));
                }
                EditXf.redraw(v);
            }
            return true;
        } catch (Throwable t) {
            Log.e(TAG, "frame size: touch", t);
            sGesture = false;
            sLive = 1f;
            return false;
        }
    }

    /** The frame's plates (FRAME_BASE / FRAME_BOTTOM) cover this point of v (view coordinates), as drawn. */
    static boolean onPlate(View v, float x, float y) {
        if (!(v.getParent() instanceof ViewGroup)) {
            return false;
        }
        ViewGroup g = (ViewGroup) v.getParent();
        Bitmap px = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(px);
        for (int i = 0; i < g.getChildCount(); i++) {
            View p = g.getChildAt(i);
            if (p.getVisibility() != View.VISIBLE || !plate(p)) {
                continue;
            }
            px.eraseColor(0);
            int save = c.save();
            c.translate(-(x + v.getLeft() - p.getLeft()), -(y + v.getTop() - p.getTop()));
            p.draw(c);
            c.restoreToCount(save);
            if (Color.alpha(px.getPixel(0, 0)) > 128) {
                return true;
            }
        }
        return false;
    }

    static boolean plate(View p) {
        String t = EditXf.viewType(p);
        return "FRAME_BASE".equals(t) || "FRAME_BOTTOM".equals(t);
    }

    /** Gesture start on the frame: how far this frame can be sized (the base plate must keep covering the screen). */
    static boolean begin(View v) {
        RectF hole = EditXf.frameRect(v);
        View base = EditXf.frameView(v, "FRAME_BASE");
        if (hole == null || base == null || v.getWidth() == 0 || v.getHeight() == 0) {
            Log.w(TAG, "frame size: no frame bounds / base plate");
            return false;
        }
        float hx = hole.centerX(), hy = hole.centerY(), w = v.getWidth(), h = v.getHeight();
        // the base plate as drawn now (view coordinates of v), and the smallest factor that keeps it over the screen
        Drawable d = ((ImageView) base).getDrawable();
        if (d == null) {
            return false;
        }
        RectF p = new RectF(d.getBounds());
        EditXf.imageMatrix((ImageView) base).mapRect(p);
        p.offset(base.getLeft() - v.getLeft(), base.getTop() - v.getTop());
        float now = scaled();
        // p is drawn scaled by `now` about the hole's middle
        float l = hx + (p.left - hx) * now, r = hx + (p.right - hx) * now, t = hy + (p.top - hy) * now, b = hy + (p.bottom - hy) * now;
        float kmin = 0f;
        if (hx > l) {
            kmin = Math.max(kmin, hx / (hx - l));
        }
        if (r > hx) {
            kmin = Math.max(kmin, (w - hx) / (r - hx));
        }
        if (hy > t) {
            kmin = Math.max(kmin, hy / (hy - t));
        }
        if (b > hy) {
            kmin = Math.max(kmin, (h - hy) / (b - hy));
        }
        sHx = hx;
        sHy = hy;
        sVw = w;
        sVh = h;
        sMin = Math.max(kmin, 0.3f / sScale);
        sMax = MAX / sScale;
        sLive = 1f;
        Log.i(TAG, String.format(java.util.Locale.US, "frame size: %.3f now, this gesture %.3f..%.3f", sScale, sMin, sMax));
        return sMin < sMax;
    }

    // ---- editor ----

    /** MaskImageView.onDraw of a frame layout view: plates drawn at the frame size (true = a plate view). */
    static boolean drawPlate(View v, Canvas c) {
        if (!plate(v)) {
            return false;
        }
        float k = scaled();
        if (k != 1f) {
            RectF hole = EditXf.frameRect(v);
            if (hole != null) {
                c.scale(k, k, hole.centerX(), hole.centerY());
            }
        }
        return true;
    }

    /**
     * The hole (mFrameBounds of the views that have one) at the kept size, Samsung's minimum zoom for it, and the picture
     * (and its subject view) grown to cover it again where it no longer does.
     */
    static void applyHole(View v) {
        if (!(v.getParent() instanceof ViewGroup)) {
            return;
        }
        ViewGroup g = (ViewGroup) v.getParent();
        float k = sScale;
        try {
            RectF cover = null;
            for (int i = 0; i < g.getChildCount(); i++) {
                View f = g.getChildAt(i);
                if (!EditXf.CROP.equals(f.getClass().getName()) || !EditXf.frameTarget(f)) {
                    continue;
                }
                RectF cur = (RectF) EditXf.call(f, "getMFrameBounds");
                if (cur == null || cur.isEmpty()) {
                    continue;
                }
                RectF[] st;
                synchronized (sHoles) {
                    st = sHoles.get(f);
                    if (st == null || !cur.equals(st[1])) {
                        st = new RectF[] {new RectF(cur), new RectF(cur)}; // Samsung's hole (set again by Samsung)
                        sHoles.put(f, st);
                    }
                }
                RectF hole = new RectF(st[0]);
                float cx = hole.centerX(), cy = hole.centerY();
                hole.set(cx + (hole.left - cx) * k, cy + (hole.top - cy) * k, cx + (hole.right - cx) * k, cy + (hole.bottom - cy) * k);
                if (!hole.equals(cur)) {
                    f.getClass().getMethod("setMFrameBounds", RectF.class).invoke(f, new RectF(hole));
                    st[1] = new RectF(hole);
                }
                // Samsung's minimum zoom for the hole (DesignPreviewController.getMinScale)
                RectF o = (RectF) EditXf.call(f, "getDrawableOriginScaledBounds");
                if (o != null && o.width() > 0 && o.height() > 0) {
                    f.getClass().getMethod("setMinScale", float.class).invoke(f, Math.max(hole.width() / o.width(), hole.height() / o.height()));
                }
                if (cover == null) {
                    cover = hole;
                }
            }
            if (cover == null) {
                return;
            }
            // the picture's bounds must cover the hole: grow about the hole's middle, then shift over it
            View bg = EditXf.frameView(v, "FRAME_BACKGROUND");
            RectF b = bg != null ? (RectF) EditXf.call(bg, "getDrawableBounds") : null;
            if (b == null || b.isEmpty() || (b.left <= cover.left + 0.5f && b.top <= cover.top + 0.5f && b.right >= cover.right - 0.5f && b.bottom >= cover.bottom - 0.5f)) {
                return;
            }
            float s = Math.max(1f, Math.max(cover.width() / b.width(), cover.height() / b.height()));
            float cx = cover.centerX(), cy = cover.centerY();
            RectF nb = new RectF(cx + (b.left - cx) * s, cy + (b.top - cy) * s, cx + (b.right - cx) * s, cy + (b.bottom - cy) * s);
            nb.offset(nb.left > cover.left ? cover.left - nb.left : nb.right < cover.right ? cover.right - nb.right : 0f,
                    nb.top > cover.top ? cover.top - nb.top : nb.bottom < cover.bottom ? cover.bottom - nb.bottom : 0f);
            for (int i = 0; i < g.getChildCount(); i++) {
                View f = g.getChildAt(i);
                if (EditXf.CROP.equals(f.getClass().getName()) && EditXf.frameTarget(f)) {
                    f.getClass().getMethod("setDrawableBoundsExternal", RectF.class).invoke(f, new RectF(nb));
                }
            }
            Log.i(TAG, "frame size: picture " + b + " -> " + nb + " to cover the hole " + cover);
        } catch (Throwable t) {
            Log.e(TAG, "frame size: hole", t);
        }
    }

    // ---- clock fit (EditorStretchAreaMediatorImpl.updateCroppedFramePath, p8.h0.o) ----

    private static WeakReference<Object> sPathMediator = new WeakReference<>(null);
    private static Path sBasePath, sBottomPath;

    /**
     * p8.h0.o(basePath, bottomPath) start, for each path (which: 0 base, 1 bottom): the frame plate's path in preview
     * coordinates, scaled to the kept size about the hole's middle; Samsung's own paths are kept to send again.
     */
    public static Path framePath(Object mediator, Path p, int which) {
        sPathMediator = new WeakReference<>(mediator);
        if (which == 0) {
            sBasePath = p;
        } else {
            sBottomPath = p;
        }
        float k = sScale;
        if (p == null || k == 1f || !HomeClock.active) {
            return p;
        }
        Path q = new Path(p);
        Matrix m = new Matrix();
        m.setScale(k, k, sHx, sHy);
        q.transform(m);
        return q;
    }

    /**
     * After a size change: Samsung's frame paths sent again (through {@link #framePath}). That blocks the clock fit as a
     * frame change until the crop is updated (updateCropRect, p8.h0.n, for the crop view the mediator follows), then
     * the subject region goes again ({@link EditXf#refit}).
     */
    static void refit(View v) {
        Object m = sPathMediator.get();
        if (m == null) {
            return;
        }
        try {
            m.getClass().getMethod("o", Path.class, Path.class).invoke(m, sBasePath, sBottomPath);
            Method crop = null;
            for (Method x : m.getClass().getMethods()) {
                if (x.getName().equals("n") && x.getParameterCount() == 1 && x.getParameterTypes()[0].getName().equals(EditXf.CROP)) {
                    crop = x;
                }
            }
            if (crop != null && v.getParent() instanceof ViewGroup) {
                ViewGroup g = (ViewGroup) v.getParent();
                for (int i = 0; i < g.getChildCount(); i++) {
                    View c = g.getChildAt(i);
                    if (EditXf.CROP.equals(c.getClass().getName())) {
                        crop.invoke(m, c); // returns at once for the views the mediator does not follow
                    }
                }
            }
            EditXf.refit();
        } catch (Throwable t) {
            Log.e(TAG, "frame size: clock fit", t);
        }
    }

    // ---- save ----

    /**
     * SaveImageMaker.g(plate, (port, land) margins) start: the frame layer's crops of its plate image for the kept size
     * (scaled copies of Samsung's margins about the hole's middle, at plate fractions).
     */
    public static Object saveRatios(Object pair) {
        float k = sScale;
        if (k == 1f || pair == null || !HomeClock.active || sVw <= 0f || sVh <= 0f) {
            return pair;
        }
        try {
            RectF port = (RectF) HomeClock.field(pair, "a"), land = (RectF) HomeClock.field(pair, "b");
            if (port == null || land == null) {
                return pair;
            }
            // the hole's middle on the plate: where it falls in Samsung's portrait crop
            float fx = port.left + sHx / sVw * (1f - port.left - port.right);
            float fy = port.top + sHy / sVh * (1f - port.top - port.bottom);
            RectF p = new RectF(port), l = new RectF(land);
            scale(p, fx, fy, k);
            scale(l, fx, fy, k);
            Log.i(TAG, "frame size: saved frame crops " + port + " -> " + p + ", land " + land + " -> " + l);
            return pair.getClass().getConstructor(Object.class, Object.class).newInstance(p, l);
        } catch (Throwable t) {
            Log.e(TAG, "frame size: save", t);
            return pair;
        }
    }

    /** Crop margins (left, top, right, bottom as fractions of the plate) scaled about (fx, fy): hole k times as big. */
    static void scale(RectF m, float fx, float fy, float k) {
        float l = m.left, t = m.top, r = 1f - m.right, b = 1f - m.bottom;
        l = fx - (fx - l) / k;
        r = fx + (r - fx) / k;
        t = fy - (fy - t) / k;
        b = fy + (b - fy) / k;
        m.set(l, t, 1f - r, 1f - b);
    }
}
