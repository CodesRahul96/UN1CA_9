package io.mesalabs.unica.settings.ui;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * "Add driver" (GpuDriverActivity): which files of a driver zip are used and where they go, and the checks of the
 * extracted set (no Android dependencies, host-tested by src/test). The same checks run again at boot
 * (k4-gpu-driver check_set), on the staged copy.
 *
 * Layouts: a driver module (system/vendor/lib64/..., vendor/lib64/..., under any top directory) or a flat set (the
 * libraries in one directory). The staged set uses the vendor layout: lib64/egl/*.so, lib64/hw/vulkan.adreno.so,
 * lib64/*.so, firmware/a660_sqe.fw. Zip entry names are only matched, never used as paths.
 */
final class GpuDriverPackage {
    static final String GLES = "lib64/egl/libGLESv2_adreno.so";
    static final String[] REQUIRED = {
        "lib64/egl/libGLESv2_adreno.so", "lib64/egl/libEGL_adreno.so", "lib64/egl/libGLESv1_CM_adreno.so",
        "lib64/hw/vulkan.adreno.so", "lib64/libgsl.so", "lib64/libllvm-glnext.so",
    };
    static final String SQE = "a660_sqe.fw";
    static final long MAX_BYTES = 300L << 20;

    /** Adreno library names a set may contain (the union of the built-in sets; nothing else is staged). Keep in
     *  sync with ALLOW_EGL / ALLOW_LIB in target/a52sxq/patches/adreno_driver/k4-gpu-driver. */
    static final java.util.Set<String> ALLOW_EGL = new java.util.HashSet<>(Arrays.asList(
        "eglSubDriverAndroid.so", "libEGL_adreno.so", "libGLESv1_CM_adreno.so", "libGLESv2_adreno.so",
        "libq3dtools_adreno.so", "libq3dtools_esx.so", "libVkLayer_ADRENO_qprofiler.so"));
    static final java.util.Set<String> ALLOW_LIB = new java.util.HashSet<>(Arrays.asList(
        "libadreno_app_profiles.so", "libadreno_compiler_cl.so", "libadreno_utils.so", "libCB.so",
        "libdmabufheap.so", "libgame_enhance.so", "libgpudataproducer.so", "libgpu_tonemapper.so", "libgsl.so",
        "libkcl.so", "libkernelmanager.so", "libllvm-glnext.so", "libllvm-qcom.so", "libllvm-qgl.so",
        "libOpenCL.so", "libVkLayer_q3dtools.so"));

    // error codes: string k4_gpu_driver_err_<code>, the detail (a file name) is the format argument
    static final String ERR_NO_DRIVER = "no_driver";
    static final String ERR_32BIT = "32bit";
    static final String ERR_MISSING = "missing";
    static final String ERR_NOT_ARM64 = "not_arm64";
    static final String ERR_NO_VERSION = "no_version";
    static final String ERR_TOO_LARGE = "too_large";
    static final String ERR_UNEXPECTED = "unexpected";

    static final class Plan {
        /** zip entry name -> path in the staged set */
        final Map<String, String> files = new LinkedHashMap<>();
        String error;
        String detail = "";
    }

    static final class Result {
        String error;
        String detail = "";
        String version;
    }

    private GpuDriverPackage() {
    }

    static Plan plan(List<String> names) {
        Plan p = new Plan();
        String prefix = null;
        boolean only32 = false;
        for (String n : names) {
            if (endsWithPath(n, GLES)) {
                String pre = n.substring(0, n.length() - GLES.length());
                if (prefix == null || pre.length() < prefix.length()) prefix = pre;
            } else if (endsWithPath(n, "lib/egl/libGLESv2_adreno.so")) {
                only32 = true;
            }
        }
        if (prefix != null) {
            for (String n : names) {
                if (!n.startsWith(prefix)) continue;
                String rel = n.substring(prefix.length());
                if (rel.equals("lib64/hw/vulkan.adreno.so") || rel.equals("firmware/" + SQE)) {
                    p.files.put(n, rel);
                } else if (isDirectChild(rel, "lib64/egl/")) {
                    String base = rel.substring("lib64/egl/".length());
                    if (ALLOW_EGL.contains(base) || ALLOW_LIB.contains(base)) p.files.put(n, rel);
                    else return unexpected(p, base);
                } else if (isDirectChild(rel, "lib64/")) {
                    String base = rel.substring("lib64/".length());
                    if (ALLOW_LIB.contains(base) || ALLOW_EGL.contains(base)) p.files.put(n, rel);
                    else return unexpected(p, base);
                } else if (isDirectChild(rel, "lib64/hw/")) {
                    return unexpected(p, rel.substring("lib64/hw/".length()));
                }
            }
        } else if (only32) {
            p.error = ERR_32BIT;
            return p;
        } else {
            String dir = null;
            for (String n : names) {
                if (n.equals("libGLESv2_adreno.so") || n.endsWith("/libGLESv2_adreno.so")) {
                    String d = n.substring(0, n.length() - "libGLESv2_adreno.so".length());
                    if (dir == null || d.length() < dir.length()) dir = d;
                }
            }
            if (dir == null) {
                p.error = ERR_NO_DRIVER;
                return p;
            }
            for (String n : names) {
                if (!n.startsWith(dir)) continue;
                String base = n.substring(dir.length());
                if (base.contains("/") || !base.endsWith(".so")) continue;
                if (base.equals("vulkan.adreno.so") || ALLOW_EGL.contains(base) || ALLOW_LIB.contains(base)) {
                    p.files.put(n, flatTarget(base));
                } else {
                    return unexpected(p, base);
                }
            }
        }
        if (!p.files.containsValue("firmware/" + SQE)) {
            // a module may keep its microcode beside the libraries' tree (e.g. system/vendor/firmware vs vendor/lib64)
            String best = null;
            for (String n : names) {
                if (!n.equals(SQE) && !n.endsWith("/" + SQE)) continue;
                if (best == null || n.contains("vendor/firmware/") && !best.contains("vendor/firmware/")) best = n;
            }
            if (best != null) p.files.put(best, "firmware/" + SQE);
        }
        return p;
    }

    private static Plan unexpected(Plan p, String base) {
        p.files.clear();
        p.error = ERR_UNEXPECTED;
        p.detail = base;
        return p;
    }

    /** Flat sets: the Adreno GL/EGL libraries go to egl/, the Vulkan driver to hw/, the rest of the allowlist to lib64/. */
    static String flatTarget(String name) {
        if (name.equals("vulkan.adreno.so")) return "lib64/hw/" + name;
        if (ALLOW_EGL.contains(name)) return "lib64/egl/" + name;
        return "lib64/" + name;
    }

    /** Checks an extracted set (vendor layout under dir). */
    static Result check(File dir) {
        Result r = new Result();
        StringBuilder miss = new StringBuilder();
        for (String f : REQUIRED) {
            if (!new File(dir, f).isFile()) {
                if (miss.length() > 0) miss.append(", ");
                miss.append(f.substring(f.lastIndexOf('/') + 1));
            }
        }
        if (miss.length() > 0) {
            r.error = ERR_MISSING;
            r.detail = miss.toString();
            return r;
        }
        long total = 0;
        for (File f : sets(dir)) {
            total += f.length();
            if (f.getName().endsWith(".so") && !isElf64Arm(f)) {
                r.error = ERR_NOT_ARM64;
                r.detail = f.getName();
                return r;
            }
        }
        if (total > MAX_BYTES) {
            r.error = ERR_TOO_LARGE;
            r.detail = String.valueOf(total >> 20);
            return r;
        }
        r.version = version(new File(dir, GLES));
        if (r.version == null) {
            r.error = ERR_NO_VERSION;
            r.detail = "libGLESv2_adreno.so";
        }
        return r;
    }

    static List<File> sets(File dir) {
        List<File> out = new ArrayList<>();
        for (String d : new String[] {"lib64/egl", "lib64", "lib64/hw", "firmware"}) {
            File[] fs = new File(dir, d).listFiles();
            if (fs == null) continue;
            for (File f : fs) if (f.isFile()) out.add(f);
        }
        return out;
    }

    /** 64-bit little-endian ELF for aarch64 (class 2, data 1, e_machine 183), like k4-gpu-driver is_elf64_arm. */
    static boolean isElf64Arm(File f) {
        byte[] h = new byte[20];
        try (InputStream in = new FileInputStream(f)) {
            int n = 0;
            while (n < h.length) {
                int k = in.read(h, n, h.length - n);
                if (k < 0) return false;
                n += k;
            }
        } catch (IOException e) {
            return false;
        }
        return h[0] == 0x7f && h[1] == 'E' && h[2] == 'L' && h[3] == 'F' && h[4] == 2 && h[5] == 1
                && (h[18] & 0xff) == 183 && h[19] == 0;
    }

    /** The first "V@<3-4 digits>.<digits>[.<digits>]" in the file (the Adreno build string), or null. */
    static String version(File f) {
        try (InputStream in = new FileInputStream(f)) {
            byte[] buf = new byte[1 << 16];
            byte[] tail = new byte[0];
            int n;
            while ((n = in.read(buf)) > 0) {
                byte[] b = new byte[tail.length + n];
                System.arraycopy(tail, 0, b, 0, tail.length);
                System.arraycopy(buf, 0, b, tail.length, n);
                String v = findVersion(b);
                if (v != null) return v;
                int keep = Math.min(b.length, 32);
                tail = new byte[keep];
                System.arraycopy(b, b.length - keep, tail, 0, keep);
            }
        } catch (IOException ignored) {
        }
        return null;
    }

    static String findVersion(byte[] b) {
        for (int i = 0; i + 1 < b.length; i++) {
            if (b[i] != 'V' || b[i + 1] != '@') continue;
            int p = i + 2;
            int d = digits(b, p);
            if (d < 3 || d > 4) continue;
            p += d;
            if (p >= b.length || b[p] != '.') continue;
            int d2 = digits(b, p + 1);
            if (d2 == 0) continue;
            p += 1 + d2;
            if (p < b.length && b[p] == '.') {
                int d3 = digits(b, p + 1);
                if (d3 > 0) p += 1 + d3;
            }
            if (p >= b.length) continue;  // touches the end of the block: the next one (with this tail) has all of it
            return new String(b, i, p - i, java.nio.charset.StandardCharsets.US_ASCII);
        }
        return null;
    }

    private static int digits(byte[] b, int from) {
        int n = 0;
        while (from + n < b.length && b[from + n] >= '0' && b[from + n] <= '9') n++;
        return n;
    }

    /** "id=" of a module.prop at the zip root, as a name for the entry; null if none. */
    static String moduleId(byte[] moduleProp) {
        String s = new String(moduleProp, java.nio.charset.StandardCharsets.UTF_8);
        for (String line : s.split("\n")) {
            line = line.trim();
            if (line.startsWith("id=")) return sanitize(line.substring(3));
        }
        return null;
    }

    /** A short name for labels and file names: [A-Za-z0-9._-], at most 24 characters. */
    static String sanitize(String s) {
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length() && b.length() < 24; i++) {
            char c = s.charAt(i);
            b.append(c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || c == '.' || c == '_' || c == '-' ? c : '_');
        }
        return b.length() == 0 ? "zip" : b.toString();
    }

    /** "V@0849.0" -> "u_0849_0_<suffix>" */
    static String slotFor(String version, String suffix) {
        return "u_" + version.substring(2).replace('.', '_') + "_" + suffix;
    }

    private static boolean endsWithPath(String n, String path) {
        return n.equals(path) || n.endsWith("/" + path);
    }

    private static boolean isDirectChild(String rel, String dir) {
        return rel.startsWith(dir) && rel.length() > dir.length() && rel.indexOf('/', dir.length()) < 0
                && rel.endsWith(".so");
    }
}
