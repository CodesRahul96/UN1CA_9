package com.k4.dressroom;

import java.util.ArrayList;
import java.util.List;

/**
 * The saved home clock's stretch heights (WallpaperClockBundle.fontHeights), held while the restored clock is unchanged.
 *
 * Samsung fits a stretch clock's digit heights to the subject whenever its stretch pipeline reports a result
 * (ApplyStretchResultUseCase, vo.t: fontHeight = IClockPositionCalculator.calculateStretchHeightList(...)). A Home
 * editor that re-edits the home wallpaper gets that result from the wallpaper's saved bg region (ReEditBgRegionState),
 * which is the subject where Samsung's own crop put it, not where the zoomed-out / tilted picture shows it; a Home editor
 * opened on a new picture fits to that picture's subject. Either way the editor replaced the heights the home clock was
 * saved with about 2 s after it opened (e.g. [2.07, 2.10] -> [1.0, 1.16]) and Done stored the shorter clock even when
 * only the colour was changed. While held, the saved heights are what the fit result is replaced with, so they
 * round-trip; the hold ends for good when the clock is moved or resized (its place or scale differs from the saved
 * bundle), when Samsung resets the clock's stretch data (clock type / font change, editor closing), or when the user
 * moves the picture, and Samsung's own fit applies from then on, exactly as stock.
 *
 * Pure logic (no Android classes), so it runs in the host test (src/test/run.sh).
 */
final class StretchHold {
    /** Margin ratios are fractions of the movable area (~2100 px tall, ~1000 px wide): 0.003 is a few pixels. */
    static final float RATIO_EPS = 0.003f;
    static final float SCALE_EPS = 0.002f;

    private List<Float> mHeights;
    private int mGravity;
    private float mScale;
    private Float mHRatio, mBRatio;
    /** Why the last {@link #apply} ended the hold (for the log), or null. */
    String released;

    /** Holds {@code saved} (numbers, as the bundle carries them) for a clock at this place; nothing for no heights. */
    void hold(List<?> saved, int gravity, float scale, Float hRatio, Float bRatio) {
        mHeights = floats(saved);
        mGravity = gravity;
        mScale = scale;
        mHRatio = hRatio;
        mBRatio = bRatio;
        released = null;
    }

    void release() {
        mHeights = null;
    }

    boolean held() {
        return mHeights != null;
    }

    /** The held heights (a copy), or null. */
    List<Float> heights() {
        return mHeights == null ? null : new ArrayList<>(mHeights);
    }

    /**
     * Samsung's fit result for the clock now at (gravity, scale, hRatio, bRatio): the held heights while the clock is
     * where and as large as saved, else {@code fit} (and the hold ends, {@link #released} says why).
     */
    List<?> apply(List<?> fit, int gravity, float scale, float hRatio, float bRatio) {
        released = null;
        if (mHeights == null) {
            return fit;
        }
        String why = null;
        if (gravity != mGravity) {
            why = "moved (gravity " + mGravity + " -> " + gravity + ")";
        } else if (Math.abs(scale - mScale) > SCALE_EPS) {
            why = "resized (scale " + mScale + " -> " + scale + ")";
        } else if (mHRatio != null && Math.abs(hRatio - mHRatio) > RATIO_EPS) {
            why = "moved (horizontal margin " + mHRatio + " -> " + hRatio + ")";
        } else if (mBRatio != null && Math.abs(bRatio - mBRatio) > RATIO_EPS) {
            why = "moved (bottom margin " + mBRatio + " -> " + bRatio + ")";
        } else if (fit != null && fit.size() != mHeights.size()) {
            why = "other digits (" + mHeights.size() + " -> " + fit.size() + " heights)";
        }
        if (why != null) {
            mHeights = null;
            released = why;
            return fit;
        }
        return new ArrayList<>(mHeights);
    }

    /** Float copies of a list of numbers; null for null, empty or anything that is not all numbers. */
    static List<Float> floats(List<?> l) {
        if (l == null || l.isEmpty()) {
            return null;
        }
        List<Float> out = new ArrayList<>(l.size());
        for (Object o : l) {
            if (!(o instanceof Number)) {
                return null;
            }
            float f = ((Number) o).floatValue();
            if (Float.isNaN(f) || f <= 0f) {
                return null;
            }
            out.add(f);
        }
        return out;
    }
}
