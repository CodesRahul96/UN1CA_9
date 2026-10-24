package com.k4.dressroom;

import java.util.Arrays;
import java.util.List;

/**
 * StretchHold with the values of the 9.3.75 / 9.3.76 device tests: the saved home clock (bundle fontHeights
 * [2.0674725, 2.0955071], gravity END 8388613, scale 1.099631, margins 0.076246 / 0.481707) re-edited, and Samsung's
 * stretch fit from the re-edit bg region ([1.0, 1.1574252]) arriving about 2 s after the editor opened.
 */
public final class StretchHoldTest {
    static final int END = 8388613;
    static final List<Float> SAVED = Arrays.asList(2.0674725f, 2.0955071f);
    static final List<Float> FIT = Arrays.asList(1.0f, 1.1574252f);
    private static int failures, checks;

    private static void check(String what, boolean ok) {
        checks++;
        if (!ok) {
            failures++;
        }
        System.out.println((ok ? "  ok    " : "  FAIL  ") + what);
    }

    private static StretchHold held() {
        StretchHold h = new StretchHold();
        h.hold(SAVED, END, 1.099631f, 0.076246f, 0.481707f);
        return h;
    }

    public static void main(String[] a) {
        StretchHold h = held();
        check("saved heights are held", h.held() && SAVED.equals(h.heights()));
        check("fit at open (re-edit bg region) -> saved heights", SAVED.equals(h.apply(FIT, END, 1.099631f, 0.076246f, 0.481707f)) && h.held());
        check("colour change: same place, the next fit -> saved heights again", SAVED.equals(h.apply(FIT, END, 1.099631f, 0.076246f, 0.481707f)));
        check("same fit as saved -> saved (Samsung skips the update)", SAVED.equals(h.apply(SAVED, END, 1.099631f, 0.076246f, 0.481707f)));
        check("relayout rounding (1 px) keeps the hold", SAVED.equals(h.apply(FIT, END, 1.0996f, 0.0765f, 0.4820f)) && h.held());
        check("null fit (no calculator) -> saved", SAVED.equals(h.apply(null, END, 1.099631f, 0.076246f, 0.481707f)));

        h = held();
        check("resized -> Samsung's fit, hold ends", FIT.equals(h.apply(FIT, END, 1.25f, 0.076246f, 0.481707f)) && !h.held() && h.released.startsWith("resized"));
        check("after the release Samsung's fit stays", FIT.equals(h.apply(FIT, END, 1.099631f, 0.076246f, 0.481707f)));

        h = held();
        check("moved down -> Samsung's fit", FIT.equals(h.apply(FIT, END, 1.099631f, 0.076246f, 0.40f)) && !h.held() && h.released.startsWith("moved"));
        h = held();
        check("moved sideways -> Samsung's fit", FIT.equals(h.apply(FIT, END, 1.099631f, 0.2f, 0.481707f)) && !h.held());
        h = held();
        check("moved to another side (gravity) -> Samsung's fit", FIT.equals(h.apply(FIT, 1, 1.099631f, 0.076246f, 0.481707f)) && !h.held());
        h = held();
        check("other digit count -> Samsung's fit", Arrays.asList(1f, 1f, 1f).equals(h.apply(Arrays.asList(1f, 1f, 1f), END, 1.099631f, 0.076246f, 0.481707f)) && !h.held());

        h = held();
        h.release();
        check("released (font change / stretch reset / picture moved) -> Samsung's fit", FIT.equals(h.apply(FIT, END, 1.099631f, 0.076246f, 0.481707f)));

        h = new StretchHold();
        h.hold(null, END, 1f, null, null);
        check("no saved heights -> nothing held", !h.held() && FIT.equals(h.apply(FIT, END, 1f, 0f, 0f)));
        h.hold(Arrays.asList(), END, 1f, null, null);
        check("empty saved heights -> nothing held", !h.held());
        h.hold(Arrays.asList(2.0, 2.1), END, 1f, null, null); // Doubles (a plain Gson list) -> Floats
        check("double heights held as floats", Arrays.asList(2.0f, 2.1f).equals(h.heights()));
        check("unknown margins (null in the bundle) are not compared", Arrays.asList(2.0f, 2.1f).equals(h.apply(FIT, END, 1f, 0.9f, 0.1f)) && h.held());
        h.hold(Arrays.asList(2f, Float.NaN), END, 1f, null, null);
        check("NaN heights -> nothing held", !h.held());

        h = held();
        List<?> out = h.apply(FIT, END, 1.099631f, 0.076246f, 0.481707f);
        check("result is a copy (Samsung's list stays separate)", out != h.heights() && out.equals(h.heights()));

        System.out.println(failures == 0 ? "StretchHoldTest: all " + checks + " checks passed" : "StretchHoldTest: " + failures + " of " + checks + " FAILED");
        System.exit(failures == 0 ? 0 : 1);
    }
}
