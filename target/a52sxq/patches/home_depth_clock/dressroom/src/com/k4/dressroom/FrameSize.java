package com.k4.dressroom;

import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
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
 * <p>
 * Grabbing: a gesture starting on a plate or anywhere outside the hole sizes the frame at once; a pinch whose second
 * finger lands while either finger is on the frame or within {@link #BAND_DP} inside the hole's edge takes over too (a
 * one-finger drag there still moves the picture). The hole stops growing before the last side with a band of frame of at
 * least {@link #EDGE} of the screen's shorter side (at least {@link #EDGE_DP}) loses it, so there is always frame left to pinch.
 * Smaller than Samsung's plates allow (the base plate no longer covering the screen): the plates are drawn and saved
 * with their edge pixels extended ({@link #drawPlate}, {@link #saveResult}), down to {@link #MIN} of Samsung's size.
 * <p>
 * Pop-out: Samsung's FRAME_BOTTOM plate (in front of the subject) is the frame below one straight line through the hole,
 * so the subject shows over the frame above that line across the whole width. With a smaller hole that line cuts the
 * subject straight across beside the hole; below Samsung's size the front plate is therefore the full FRAME_BASE plate
 * faded in across that line ({@link #FADE} of the screen height either side), so the subject fades into the frame there
 * while the hole's own outline stays sharp ({@link #frontPlate}; editor in {@link #drawPlate}, save in {@link #saveFront}).
 */
public final class FrameSize {
    static final String TAG = HomeClock.TAG;
    /** Largest and smallest hole, against Samsung's size. */
    static final float MAX = 1.6f;
    static final float MIN = 0.35f;
    /** Frame that stays visible around the biggest hole: share of the screen's shorter side, and at least this many dp. */
    static final float EDGE = 0.08f;
    static final float EDGE_DP = 40f;
    /** Band inside the hole's edge where a pinch still grabs the frame. */
    static final float BAND_DP = 36f;
    /** Half the width of the pop-out fade across the front plate's line, as a share of the screen height. */
    static final float FADE = 0.035f;

    /** Kept size (1 = Samsung's), and the extra factor while the fingers move. */
    private static volatile float sScale = 1f;
    private static volatile float sLive = 1f;
    /** The hole's middle and the frame views' size (view coordinates), for the save. */
    private static volatile float sHx, sHy, sVw, sVh;
    private static float sMin, sMax, sBase, sSpan0;
    private static int sCount;
    private static boolean sGesture;
    /** The first finger is in the band inside the hole's edge: a second finger makes the gesture size the frame. */
    private static boolean sMaybe;
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
                int zone = zone(v, e.getX(), e.getY());
                sGesture = zone == 2 && begin(v);
                sMaybe = zone == 1;
                sCount = 0;
                Log.i(TAG, String.format(java.util.Locale.US, "frame size: touch at %.0f,%.0f on the %s", e.getX(), e.getY(),
                        zone == 2 ? (sGesture ? "frame" : "frame (cannot size it)") : zone == 1 ? "hole's edge" : "picture"));
            } else if (!sGesture && act == MotionEvent.ACTION_POINTER_DOWN && e.getPointerCount() == 2) {
                int i = e.getActionIndex();
                if ((sMaybe || zone(v, e.getX(i), e.getY(i)) >= 1) && begin(v)) {
                    sGesture = true; // Samsung's picture handling sees the gesture cancelled from here on
                    sCount = 0;
                    Log.i(TAG, "frame size: pinch at the frame's edge sizes the frame");
                }
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

    /** Where a touch at (x, y) of v lands: 2 on the frame (a plate, or outside the hole), 1 just inside the hole's edge, 0 picture. */
    static int zone(View v, float x, float y) {
        RectF hole = EditXf.frameRect(v);
        if (onPlate(v, x, y) || (hole != null && !hole.contains(x, y))) {
            return 2;
        }
        if (hole == null) {
            return 0;
        }
        float band = BAND_DP * v.getResources().getDisplayMetrics().density;
        RectF inner = new RectF(hole);
        inner.inset(Math.min(band, hole.width() / 4f), Math.min(band, hole.height() / 4f));
        return inner.contains(x, y) ? 0 : 1;
    }

    static boolean plate(View p) {
        String t = EditXf.viewType(p);
        return "FRAME_BASE".equals(t) || "FRAME_BOTTOM".equals(t);
    }

    /**
     * Gesture start on the frame: how far this frame can be sized. Bigger: up to {@link #MAX} of Samsung's, keeping
     * {@link #EDGE} of frame visible around the hole; smaller: down to {@link #MIN} (the plates' edges are extended).
     */
    static boolean begin(View v) {
        RectF hole = EditXf.frameRect(v);
        if (hole == null || v.getWidth() == 0 || v.getHeight() == 0 || EditXf.frameView(v, "FRAME_BASE") == null) {
            Log.w(TAG, "frame size: no frame bounds / base plate");
            return false;
        }
        float hx = hole.centerX(), hy = hole.centerY(), w = v.getWidth(), h = v.getHeight();
        float m = Math.max(EDGE * Math.min(w, h), EDGE_DP * v.getResources().getDisplayMetrics().density);
        // the hole is drawn at scaled(): the factor (against now) at which each side's band of frame shrinks to the margin.
        // It may grow while at least one side still has that band to pinch (a hole that already reaches the screen edge on
        // one side, like Samsung's heart, still grows into the space above and below it).
        float band = 0f;
        if (hole.left < hx) band = Math.max(band, (hx - m) / (hx - hole.left));
        if (hole.right > hx) band = Math.max(band, (w - m - hx) / (hole.right - hx));
        if (hole.top < hy) band = Math.max(band, (hy - m) / (hy - hole.top));
        if (hole.bottom > hy) band = Math.max(band, (h - m - hy) / (hole.bottom - hy));
        float kmax = Math.min(MAX / sScale, band);
        sHx = hx;
        sHy = hy;
        sVw = w;
        sVh = h;
        sMin = MIN / sScale;
        sMax = Math.max(1f, kmax); // already bigger than the margin allows (older size): it can still be made smaller
        sLive = 1f;
        Log.i(TAG, String.format(java.util.Locale.US, "frame size: %.3f now, this gesture %.3f..%.3f", sScale, sMin, sMax));
        return sMin < sMax;
    }

    // ---- editor ----

    /**
     * MaskImageView.onDraw of a frame layout view: plates drawn at the frame size. 0 = not a plate view, 1 = a plate
     * view, canvas scaled for Samsung's own draw, 2 = drawn here (smaller than the plate covers: edges extended).
     */
    static int drawPlate(View v, Canvas c) {
        if (!plate(v)) {
            return 0;
        }
        float k = scaled();
        if (k == 1f) {
            return 1;
        }
        RectF hole = EditXf.frameRect(v);
        if (hole == null) {
            return 1;
        }
        Drawable d = ((ImageView) v).getDrawable();
        if ("FRAME_BASE".equals(EditXf.viewType(v))) {
            sBaseView = new WeakReference<>(v);
        }
        if (k < 1f && d != null && "FRAME_BOTTOM".equals(EditXf.viewType(v))) {
            View base = EditXf.frameView(v, "FRAME_BASE");
            Drawable bd = base instanceof ImageView ? ((ImageView) base).getDrawable() : null;
            if (bd != null && d.getBounds().width() > 0 && d.getBounds().height() > 0) {
                try {
                    Matrix m = EditXf.imageMatrix((ImageView) v);
                    m.postScale(k, k, hole.centerX(), hole.centerY());
                    // the fade is FADE of the view height on screen: in plate pixels through the plate's own scale
                    float ramp = FADE * v.getHeight() / Math.max(1e-3f, m.mapRadius(1f));
                    Bitmap front = frontPlate(bd, d, d.getBounds().width(), d.getBounds().height(), ramp, true);
                    if (front != null) {
                        drawBitmapClamped(v, c, front, d.getBounds(), m);
                        return 2;
                    }
                } catch (Throwable t) {
                    Log.e(TAG, "frame size: front plate", t);
                }
            }
        }
        if (d != null && d.getBounds().width() > 0 && d.getBounds().height() > 0) {
            Matrix m = EditXf.imageMatrix((ImageView) v);
            m.postScale(k, k, hole.centerX(), hole.centerY());
            RectF p = new RectF(d.getBounds());
            m.mapRect(p);
            if (p.left > 0.5f || p.top > 0.5f || p.right < v.getWidth() - 0.5f || p.bottom < v.getHeight() - 0.5f) {
                try {
                    drawClamped(v, c, d, m);
                    return 2;
                } catch (Throwable t) {
                    Log.e(TAG, "frame size: plate", t);
                }
            }
        }
        c.scale(k, k, hole.centerX(), hole.centerY());
        return 1;
    }

    /** The plate (with Samsung's colour filter / alpha, as its drawable draws) over the whole view, edge pixels extended. */
    private static final WeakHashMap<View, Bitmap> sPlateBmp = new WeakHashMap<>();

    static void drawClamped(View v, Canvas c, Drawable d, Matrix toView) {
        Rect b = d.getBounds();
        Bitmap bmp = sPlateBmp.get(v);
        if (bmp == null || bmp.getWidth() != b.width() || bmp.getHeight() != b.height()) {
            bmp = Bitmap.createBitmap(b.width(), b.height(), Bitmap.Config.ARGB_8888);
            sPlateBmp.put(v, bmp);
        }
        bmp.eraseColor(0);
        Canvas bc = new Canvas(bmp);
        bc.translate(-b.left, -b.top);
        d.draw(bc);
        drawBitmapClamped(v, c, bmp, b, toView);
    }

    /** bmp (the plate drawn at its drawable bounds b) over the whole view through toView, edge pixels extended. */
    static void drawBitmapClamped(View v, Canvas c, Bitmap bmp, Rect b, Matrix toView) {
        BitmapShader sh = new BitmapShader(bmp, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
        Matrix lm = new Matrix();
        lm.setTranslate(b.left, b.top);
        lm.postConcat(toView);
        sh.setLocalMatrix(lm);
        Paint paint = new Paint(Paint.FILTER_BITMAP_FLAG | Paint.ANTI_ALIAS_FLAG);
        paint.setShader(sh);
        c.drawRect(0, 0, v.getWidth(), v.getHeight(), paint);
    }

    /** The editor's FRAME_BASE view (the save of the front plate needs its drawable). */
    private static WeakReference<View> sBaseView = new WeakReference<>(null);
    /** Editor cache of the faded front plate: rebuilt when a drawable, the colour or the fade changes. */
    private static Bitmap sFront;
    private static Object[] sFrontKey;

    /**
     * The front plate below Samsung's size: the base plate (drawn w x h, with its colour filter) faded in across the
     * front plate's straight line (alpha 0 at line - ramp, full at line + ramp), so the subject fades into the frame there.
     * null when the front plate has no clear straight line (then Samsung's plate is used).
     */
    static Bitmap frontPlate(Drawable base, Drawable bottom, int w, int h, float ramp, boolean cache) {
        Object[] key = {base, bottom, base.getColorFilter(), bottom.getColorFilter(), w, h, Math.round(ramp)};
        if (cache && sFront != null && sFrontKey != null && java.util.Arrays.equals(key, sFrontKey)) {
            return sFront;
        }
        float line = lineOf(bottom, w, h);
        if (line < 0f) {
            return null;
        }
        Bitmap out = cache && sFront != null && sFront.getWidth() == w && sFront.getHeight() == h ? sFront
                : Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        out.eraseColor(0);
        Canvas oc = new Canvas(out);
        Drawable bc = copy(base);
        bc.setBounds(0, 0, w, h);
        bc.draw(oc);
        Paint fade = new Paint();
        fade.setShader(new LinearGradient(0f, line - ramp, 0f, line + ramp, 0x00000000, 0xFF000000, Shader.TileMode.CLAMP));
        fade.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_IN));
        oc.drawRect(0, 0, w, h, fade);
        if (cache) {
            sFront = out;
            sFrontKey = key;
        }
        return out;
    }

    /** A copy to draw at other bounds without touching the editor's drawable (same colour filter). */
    static Drawable copy(Drawable d) {
        Drawable.ConstantState cs = d.getConstantState();
        Drawable c = cs != null ? cs.newDrawable().mutate() : d;
        if (c != d) {
            c.setColorFilter(d.getColorFilter());
            c.setAlpha(d.getAlpha());
        }
        return c;
    }

    /** Samsung's straight line in the front plate (w x h): the first opaque row most columns share, or -1 if none. */
    private static final WeakHashMap<Object, float[]> sLines = new WeakHashMap<>();

    static float lineOf(Drawable bottom, int w, int h) {
        Object id = bottom.getConstantState() != null ? bottom.getConstantState() : bottom;
        float[] c = sLines.get(id);
        if (c != null && c[1] == w && c[2] == h) {
            return c[0];
        }
        int sw = Math.max(1, w / 4), sh = Math.max(1, h / 4);
        Bitmap px = Bitmap.createBitmap(sw, sh, Bitmap.Config.ARGB_8888);
        Canvas pc = new Canvas(px);
        pc.scale(sw / (float) w, sh / (float) h);
        Drawable bc = copy(bottom);
        bc.setBounds(0, 0, w, h);
        bc.draw(pc);
        int[] count = new int[sh + 1];
        int[] row = new int[sw];
        int cols = 0;
        int[] first = new int[sw];
        java.util.Arrays.fill(first, -1);
        for (int y = 0; y < sh; y++) {
            px.getPixels(row, 0, sw, 0, y, sw, 1);
            for (int x = 0; x < sw; x++) {
                if (first[x] < 0 && (row[x] >>> 24) > 128) {
                    first[x] = y;
                }
            }
        }
        for (int f : first) {
            if (f >= 0) {
                count[f]++;
                cols++;
            }
        }
        int best = -1;
        for (int y = 0; y < sh; y++) {
            if (best < 0 || count[y] > count[best]) {
                best = y;
            }
        }
        px.recycle();
        float line = best >= 0 && cols > 0 && count[best] * 10 >= sw * 3 ? (best + 0.5f) * h / (float) sh : -1f;
        sLines.put(id, new float[] {line, w, h});
        return line;
    }

    /**
     * Save of the front plate (FRAME_BOTTOM task, right before SaveImageMaker.g, with that plate's copy and its (port,
     * land) margins): below Samsung's size the faded base plate instead, so the home screen shows the editor's pop-out.
     */
    public static Drawable saveFront(Drawable bottom, Object pair) {
        float k = sScale;
        if (bottom == null || !HomeClock.active || k >= 1f) {
            return bottom;
        }
        try {
            View bv = sBaseView.get();
            Drawable live = bv instanceof ImageView ? ((ImageView) bv).getDrawable() : null;
            Drawable base = live != null && live.getConstantState() != null ? live.getConstantState().newDrawable() : null;
            int w = bottom.getIntrinsicWidth(), h = bottom.getIntrinsicHeight();
            if (base == null || w <= 0 || h <= 0) {
                Log.w(TAG, "frame size: no base plate for the saved front plate, Samsung's kept");
                return bottom;
            }
            base.setColorFilter(bottom.getColorFilter());
            // plate pixels per screen pixel for the saved portrait crop (Samsung's margins, hole k times as big)
            RectF port = (RectF) HomeClock.field(pair, "a");
            android.util.DisplayMetrics dm = android.content.res.Resources.getSystem().getDisplayMetrics();
            float sw = Math.min(dm.widthPixels, dm.heightPixels), sh = Math.max(dm.widthPixels, dm.heightPixels);
            float perScreen = port != null ? (1f - port.left - port.right) * w / k / sw : 1f;
            Bitmap front = frontPlate(base, bottom, w, h, FADE * sh * perScreen, false);
            if (front == null) {
                return bottom;
            }
            front.setDensity(Bitmap.DENSITY_NONE);
            Log.i(TAG, String.format(java.util.Locale.US, "frame size: saved front plate faded (%dx%d, fade %.0f px)", w, h, FADE * sh * perScreen));
            return new BitmapDrawable(null, front);
        } catch (Throwable t) {
            Log.e(TAG, "frame size: saved front plate", t);
            return bottom;
        }
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

    /**
     * SaveImageMaker.g end ((plate bitmap, (port, land) layers)): when the frame is smaller than the plate covers, the
     * layers' showing rects reach past the plate bitmap; the bitmap is padded with its edge pixels extended and the
     * rects moved onto it, so the home screen draws the frame edge to edge like the editor.
     */
    public static Object saveResult(Object pair) {
        if (pair == null || !HomeClock.active || sScale >= 1f) {
            return pair;
        }
        try {
            Bitmap bmp = (Bitmap) HomeClock.field(pair, "a");
            Object layers = HomeClock.field(pair, "b");
            if (bmp == null || layers == null) {
                return pair;
            }
            RectF[] rs = {(RectF) HomeClock.field(HomeClock.field(layers, "a"), "b"), (RectF) HomeClock.field(HomeClock.field(layers, "b"), "b")};
            float w = bmp.getWidth(), h = bmp.getHeight(), l = 0f, t = 0f, r = 0f, b = 0f;
            for (RectF x : rs) {
                if (x == null) {
                    return pair;
                }
                l = Math.max(l, -x.left);
                t = Math.max(t, -x.top);
                r = Math.max(r, x.right - w);
                b = Math.max(b, x.bottom - h);
            }
            if (l < 0.5f && t < 0.5f && r < 0.5f && b < 0.5f) {
                return pair;
            }
            // The layers only ever show their rect at screen size (layer field c), and a small frame makes the rects about
            // 1/k as big as the plate: keep only the resolution the screen needs (never more than the plate's own).
            float sc = 0f;
            Object[] ls = {HomeClock.field(layers, "a"), HomeClock.field(layers, "b")};
            for (int i = 0; i < rs.length; i++) {
                RectF scr = (RectF) HomeClock.field(ls[i], "c");
                if (scr != null && rs[i].width() > 0 && rs[i].height() > 0) {
                    sc = Math.max(sc, Math.max(scr.width() / rs[i].width(), scr.height() / rs[i].height()));
                }
            }
            if (sc <= 0f || sc > 1f) {
                sc = 1f;
            }
            int pl = (int) Math.ceil(l), pt = (int) Math.ceil(t);
            int nw = (int) Math.ceil((pl + w + Math.ceil(r)) * sc), nh = (int) Math.ceil((pt + h + Math.ceil(b)) * sc);
            if ((long) nw * nh > 40L * 1024 * 1024) {
                Log.w(TAG, "frame size: padded plate would be " + nw + "x" + nh + ", saved without");
                return pair;
            }
            Bitmap out = Bitmap.createBitmap(nw, nh, Bitmap.Config.ARGB_8888);
            BitmapShader sh = new BitmapShader(bmp, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
            Matrix lm = new Matrix();
            lm.setTranslate(pl, pt);
            lm.postScale(sc, sc);
            sh.setLocalMatrix(lm);
            Paint paint = new Paint(Paint.FILTER_BITMAP_FLAG);
            paint.setShader(sh);
            new Canvas(out).drawRect(0, 0, nw, nh, paint);
            for (RectF x : rs) {
                x.offset(pl, pt);
                x.set(x.left * sc, x.top * sc, x.right * sc, x.bottom * sc);
            }
            Log.i(TAG, "frame size: saved plate " + bmp.getWidth() + "x" + bmp.getHeight() + " padded to " + nw + "x" + nh
                    + " (edges extended, scale " + sc + "), port " + rs[0] + ", land " + rs[1]);
            return pair.getClass().getConstructor(Object.class, Object.class).newInstance(out, layers);
        } catch (Throwable t) {
            Log.e(TAG, "frame size: save padding", t);
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
