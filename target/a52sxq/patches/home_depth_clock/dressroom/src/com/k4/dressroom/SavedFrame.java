package com.k4.dressroom;

import android.app.Activity;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.os.SystemClock;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.ref.WeakReference;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Locale;

/**
 * The frame edit of a saved Home wallpaper, for its re-edit: frame size ({@link FrameSize}), the picture's zoom-out,
 * tilt and offset with their fill ({@link EditXf}), and where the picture sits in the frame.
 * <p>
 * Samsung keeps a layered wallpaper in its own directory (files/profile/&lt;key&gt;/Layer/&lt;id&gt;: background,
 * masked.jpg, frame_base.png, frame_bottom.png, setWallpaper.xml, bg_region; SaveImageMaker.a() names and creates it) and
 * re-opens it with its frame (EditorData frame item) and the original picture, but only at Samsung's frame size and
 * without our transform. So every Home save writes {@link #FILE} next to Samsung's files ({@link #save}, from
 * SaveImageMaker.f), or removes it when there is nothing of ours to keep (plain layout, Samsung's frame size and no
 * transform): the directory always describes its last save. A re-edit names that directory in its intent (the
 * re_edit_screen editor of f6.d: saved_bg_region_path_list, the wallpaper's bg_region file there), and the record is put
 * back ({@link #tick}, from MaskImageView.onDraw) once the editor shows the same frame (Samsung's own hole and plate
 * size, against the editor's preview size) around the same picture (drawable aspect and coarse fingerprint, as for the
 * plain layout's record). Anything else (another frame, another picture, a wallpaper saved by an older build, which has
 * no file, or an unknown record version) leaves the editor as Samsung opens it.
 * <p>
 * Samsung may rebuild the frame views or set the hole and the picture again while the editor starts: until the picture
 * is first touched (or {@link #WINDOW_MS}), the same frame coming back gets the record again, and a hole or picture
 * Samsung changed on the restored views is restored again (at most {@link #MAX_APPLIES} times). A frame layout that goes
 * or turns into another frame in that time ends it, so another frame starts at Samsung's defaults.
 */
final class SavedFrame {
    static final String TAG = HomeClock.TAG;
    static final String FILE = "k4_frame_edit.json";
    /** Record version: 1 = frame size k, transform (s, deg, tx/ty per view size), fill, picture bounds, frame identity. */
    static final int VERSION = 1;
    static final long WINDOW_MS = 20000;
    /** Same frame: Samsung's hole within this share of the preview size. */
    static final float HOLE_TOL = 0.01f;
    static final int MAX_APPLIES = 4;

    private static boolean sRead;
    private static volatile boolean sDone;
    private static JSONObject sRec;
    private static long sUntil;
    private static boolean sPosted;
    private static int sApplies;
    /** The frame picture view the record was last applied to, and its picture bounds right after. */
    private static WeakReference<View> sApplied = new WeakReference<>(null);
    private static RectF sBounds;

    private SavedFrame() {}

    /** A new editor. */
    static void reset() {
        sRead = false;
        sDone = false;
        sRec = null;
        sPosted = false;
        sApplies = 0;
        sApplied = new WeakReference<>(null);
        sBounds = null;
    }

    static void done(String why) {
        sDone = true;
        if (sRec != null) {
            Log.i(TAG, "saved frame edit: " + why);
        }
        sRec = null;
    }

    // ---- save ----

    /** SaveImageMaker.f start (Home save): the record next to Samsung's layer files, or none. */
    static void save(Object maker) {
        File f;
        try {
            Object dir = maker.getClass().getMethod("a").invoke(maker); // SaveImageMaker.a(): the layer directory
            if (!(dir instanceof String) || ((String) dir).isEmpty()) {
                Log.w(TAG, "saved frame edit: no layer directory");
                return;
            }
            f = new File((String) dir, FILE);
        } catch (Throwable t) {
            Log.w(TAG, "saved frame edit: no layer directory", t);
            return;
        }
        try {
            JSONObject o = EditXf.sFrameLayout ? record() : null;
            if (o == null) {
                if (f.delete()) {
                    Log.i(TAG, "saved frame edit: nothing to keep for this save, " + f + " removed");
                }
                return;
            }
            File tmp = new File(f.getPath() + ".tmp");
            try (FileOutputStream out = new FileOutputStream(tmp)) {
                out.write(o.toString().getBytes(StandardCharsets.UTF_8));
                out.getFD().sync();
            }
            if (!tmp.renameTo(f)) {
                tmp.delete();
                throw new java.io.IOException("rename to " + f);
            }
            Log.i(TAG, "saved frame edit -> " + f + ": " + o);
        } catch (Throwable t) {
            Log.e(TAG, "saved frame edit: not saved", t);
            f.delete(); // never an older record for this save
        }
    }

    /** The frame layout's state, or null when it is Samsung's own (frame size 1, no transform). */
    static JSONObject record() throws Exception {
        float k = FrameSize.kept();
        if (k == 1f && EditXf.identity()) {
            return null;
        }
        View bg = EditXf.frameBackground();
        if (bg == null || bg.getWidth() == 0 || bg.getHeight() == 0) {
            Log.w(TAG, "saved frame edit: no frame picture view");
            return null;
        }
        float vw = bg.getWidth(), vh = bg.getHeight();
        RectF hole = FrameSize.samsungHole(bg);
        RectF b = EditXf.bounds(bg);
        float asp = EditXf.aspect(bg);
        int[] fp = EditXf.fingerprint(bg);
        if (hole == null || hole.isEmpty() || b == null || b.isEmpty() || asp == 0f || fp == null) {
            Log.w(TAG, "saved frame edit: frame view not set up (hole " + hole + ", picture " + b + ")");
            return null;
        }
        JSONObject o = new JSONObject();
        o.put("v", VERSION);
        o.put("kind", "frame");
        o.put("vw", (double) vw);
        o.put("vh", (double) vh);
        o.put("hole", rect(hole, vw, vh));
        int[] plate = plate(bg);
        if (plate != null) {
            o.put("plate", new JSONArray().put(plate[0]).put(plate[1]));
        }
        o.put("bounds", rect(b, vw, vh));
        o.put("aspect", (double) asp);
        JSONArray a = new JSONArray();
        for (int x : fp) {
            a.put(x);
        }
        o.put("fp", a);
        o.put("k", (double) k);
        boolean xf = !EditXf.identity();
        o.put("s", xf ? (double) EditXf.s : 1.0);
        o.put("deg", xf ? (double) EditXf.shownDeg() : 0.0);
        o.put("tx", xf ? (double) (EditXf.tx / vw) : 0.0);
        o.put("ty", xf ? (double) (EditXf.ty / vh) : 0.0);
        o.put("fill", EditXf.sFill);
        Integer col = EditXf.sLastFillColor;
        if (xf && EditXf.sFill == EditXf.FILL_COLOR && col != null) {
            o.put("color", col);
        }
        String st = HomeClock.styleName();
        if (st != null) {
            o.put("style", st);
        }
        return o;
    }

    static JSONArray rect(RectF r, float vw, float vh) throws Exception {
        return new JSONArray().put((double) (r.left / vw)).put((double) (r.top / vh)).put((double) (r.right / vw)).put((double) (r.bottom / vh));
    }

    /** The frame's base plate (FRAME_BASE drawable) size, part of what tells one frame from another. */
    static int[] plate(View bg) {
        View p = EditXf.frameView(bg, "FRAME_BASE");
        Drawable d = p instanceof ImageView ? ((ImageView) p).getDrawable() : null;
        return d == null || d.getIntrinsicWidth() <= 0 || d.getIntrinsicHeight() <= 0 ? null : new int[] {d.getIntrinsicWidth(), d.getIntrinsicHeight()};
    }

    // ---- re-edit ----

    /** The record of the wallpaper this re-edit opened (the layer directory of its bg_region), or false. */
    static boolean load(View v) throws Exception {
        Activity a = EditXf.activity(v);
        if (a == null || a.getIntent() == null || !a.getIntent().getBooleanExtra("re_edit_screen", false)) {
            return false;
        }
        ArrayList<String> paths;
        try {
            paths = a.getIntent().getStringArrayListExtra("saved_bg_region_path_list");
        } catch (Throwable t) {
            paths = null;
        }
        if (paths == null || paths.isEmpty()) {
            Log.i(TAG, "saved frame edit: this re-edit names no layer directory");
            return false;
        }
        for (String p : paths) {
            File dir = p == null || p.isEmpty() ? null : new File(p).getParentFile();
            File f = dir != null ? new File(dir, FILE) : null;
            if (f == null || !f.isFile()) {
                continue;
            }
            JSONObject o = new JSONObject(new String(java.nio.file.Files.readAllBytes(f.toPath()), StandardCharsets.UTF_8));
            int ver = o.optInt("v", 0);
            if (ver < 1 || ver > VERSION || !"frame".equals(o.optString("kind"))) {
                Log.i(TAG, "saved frame edit: " + f + " is version " + ver + " / " + o.optString("kind") + ", ignored");
                continue;
            }
            sRec = o;
            sUntil = SystemClock.uptimeMillis() + WINDOW_MS;
            Log.i(TAG, String.format(Locale.US, "saved frame edit for this re-edit (%s): frame size %.3f, scale %.3f, %.1f deg; waiting for the frame",
                    f, o.optDouble("k", 1), o.optDouble("s", 1), o.optDouble("deg", 0)));
            return true;
        }
        Log.i(TAG, "saved frame edit: none in " + paths);
        return false;
    }

    /** CropImageView.onTouchEvent down: the user takes over. */
    static void touched() {
        if (!sDone && sRead) {
            done(sApplies > 0 ? "the picture was touched, restore window over" : "not restored: the picture was touched first");
        }
    }

    /** MaskImageView.onDraw of a CropImageView in the Home editor (UI thread). */
    static void tick(View v) {
        if (sDone) {
            return;
        }
        try {
            if (!sRead) {
                sRead = true;
                if (!load(v)) {
                    sDone = true;
                    return;
                }
            }
            if (SystemClock.uptimeMillis() > sUntil) {
                done(sApplies > 0 ? "restore window over" : "not restored: the saved frame never showed");
                return;
            }
            if (!EditXf.sFrameLayout) {
                if (sApplies > 0) {
                    done("the frame was taken off");
                }
                return; // a re-edit may show the plain layout before the frame
            }
            if (sPosted || !"FRAME_BACKGROUND".equals(EditXf.viewType(v)) || !v.isShown() || v.getWidth() == 0 || v.getHeight() == 0) {
                return;
            }
            if (sApplied.get() == v) {
                drift(v);
                return;
            }
            JSONObject o = sRec;
            RectF b = EditXf.bounds(v);
            float asp = EditXf.aspect(v);
            RectF hole = FrameSize.samsungHole(v);
            if (((ImageView) v).getDrawable() == null || b == null || b.isEmpty() || asp == 0f || hole == null || hole.isEmpty()) {
                return; // not set up yet
            }
            if (Math.abs(asp - o.getDouble("aspect")) > 0.005 * asp) {
                return; // not the picture (yet)
            }
            String why = otherFrame(v, hole, o);
            if (why == null) {
                why = EditXf.otherPicture(o.optJSONArray("fp"), v);
            }
            if (why != null) {
                done((sApplies > 0 ? "frame changed (" : "not restored (") + why + ")");
                return;
            }
            if (sApplies >= MAX_APPLIES) {
                done("Samsung keeps rebuilding the frame, left as it is");
                return;
            }
            apply(v); // first time, or the same frame's views rebuilt by Samsung (FrameSize / EditXf were reset)
        } catch (Throwable t) {
            Log.e(TAG, "saved frame edit: restore", t);
            done("restore failed");
        }
    }

    /** Why this frame is not the saved one, or null: preview shape, Samsung's hole, base plate size. */
    static String otherFrame(View v, RectF hole, JSONObject o) throws Exception {
        float vw = v.getWidth(), vh = v.getHeight();
        double sw = o.getDouble("vw"), sh = o.getDouble("vh");
        if (Math.abs(vw / vh - sw / sh) > 0.01 * sw / sh) {
            return String.format(Locale.US, "preview %.0fx%.0f, saved in %.0fx%.0f", vw, vh, sw, sh);
        }
        JSONArray h = o.getJSONArray("hole");
        float[] now = {hole.left / vw, hole.top / vh, hole.right / vw, hole.bottom / vh};
        for (int i = 0; i < 4; i++) {
            if (Math.abs(now[i] - h.getDouble(i)) > HOLE_TOL) {
                return "another frame: hole " + hole + " in " + vw + "x" + vh + ", saved " + h;
            }
        }
        JSONArray p = o.optJSONArray("plate");
        int[] plate = plate(v);
        if (p != null && plate != null && (Math.abs(plate[0] - p.getInt(0)) > 1 || Math.abs(plate[1] - p.getInt(1)) > 1)) {
            return "another frame: plate " + plate[0] + "x" + plate[1] + ", saved " + p;
        }
        return null;
    }

    /** Samsung moved the restored picture or set the frame's hole again (still before any touch): restored again. */
    static void drift(View bg) {
        RectF b = EditXf.bounds(bg);
        RectF was = sBounds;
        boolean moved = b != null && was != null && (Math.abs(b.left - was.left) > 1.5f || Math.abs(b.top - was.top) > 1.5f
                || Math.abs(b.right - was.right) > 1.5f || Math.abs(b.bottom - was.bottom) > 1.5f);
        boolean hole = FrameSize.holeStale(bg);
        if (!moved && !hole) {
            return;
        }
        if (sApplies >= MAX_APPLIES) {
            done("Samsung keeps changing the frame, left as it is");
            return;
        }
        Log.i(TAG, "saved frame edit: Samsung " + (moved ? "moved the picture to " + b : "set the frame's hole again") + ", restoring again");
        apply(bg);
    }

    static void apply(final View bg) {
        sPosted = true;
        bg.post(new Runnable() {
            @Override
            public void run() {
                sPosted = false;
                if (sDone || sRec == null || !bg.isAttachedToWindow() || !EditXf.sFrameLayout) {
                    return;
                }
                try {
                    restore(bg, sRec);
                } catch (Throwable t) {
                    Log.e(TAG, "saved frame edit: restore", t);
                    done("restore failed");
                }
            }
        });
    }

    /** The saved frame edit on these frame views (UI thread). */
    static void restore(View bg, JSONObject o) throws Exception {
        float vw = bg.getWidth(), vh = bg.getHeight();
        // the preview may be another size: positions scale with its width (same shape, checked)
        float f = vw / (float) o.getDouble("vw");
        JSONArray a = o.getJSONArray("bounds");
        double sw = o.getDouble("vw"), sh = o.getDouble("vh");
        RectF nb = new RectF((float) (a.getDouble(0) * sw * f), (float) (a.getDouble(1) * sh * f),
                (float) (a.getDouble(2) * sw * f), (float) (a.getDouble(3) * sh * f));
        // the frame size first (the hole k times Samsung's and its minimum zoom), then where the picture sat in that
        // frame (Samsung's pan / zoom, on the picture and its subject alike), then covering the hole checked again
        FrameSize.restore(bg, (float) o.optDouble("k", 1));
        FrameSize.pictureBounds(bg, nb);
        FrameSize.applyHole(bg);
        // zoom-out / tilt / offset and the fill
        EditXf.restoreFrame(bg, o, vw, vh);
        sBounds = EditXf.bounds(bg);
        sApplied = new WeakReference<>(bg);
        sApplies++;
        Log.i(TAG, String.format(Locale.US, "re-edit: saved frame edit restored (%d): frame size %.3f, scale %.3f, %.1f deg, offset %.0f,%.0f, picture %s",
                sApplies, FrameSize.kept(), EditXf.s, EditXf.shownDeg(), EditXf.tx, EditXf.ty, sBounds));
        EditXf.redraw(bg);
        FrameSize.refit(bg);
        EditXf.showSwitchLater(bg);
    }
}
