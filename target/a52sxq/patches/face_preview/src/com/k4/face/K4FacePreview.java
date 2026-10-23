// a52sxq face_preview patch: draws the HIDL face HAL's NV21 preview frames (FaceManager.EnrollmentCallback
// .onImageProcessed, delivered on the main thread) into the enrollment screen's face_preview TextureView.
// Source of ../../../../smali/com/k4/face/*.smali (regenerate with ../../../../build.sh).
//
// render() runs on the main thread and only takes a snapshot of the frame: the byte[] the callback got, or a copy of
// the service's memory file (closed right away). The JPEG round trip, the decode and the draw run on one worker thread;
// if the worker is still busy, only the newest waiting frame is kept. release() (FaceEnrollActivity.onPause, which
// stops the enrollment and finishes the activity) drops the waiting frame, releases the Surface on the worker and ends
// the thread; a later frame starts a new worker.
package com.k4.face;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.SurfaceTexture;
import android.graphics.YuvImage;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.view.Surface;
import android.view.TextureView;
import android.view.View;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.util.concurrent.atomic.AtomicReference;

public final class K4FacePreview {
    private static final String TAG = "K4FacePreview";
    private static final int NV21 = 17;

    private static int sFrames;          // main thread
    private static Worker sWorker;       // main thread

    private K4FacePreview() {
    }

    private static boolean verbose(int n) {
        return n < 3 || n % 30 == 0;
    }

    public static void render(View view, Object callback, byte[] data, int w, int h, int orientation, int format, Bundle extras) {
        try {
            int n = sFrames;
            if (verbose(n)) {
                Log.i(TAG, "onImageProcessed #" + n + " view=" + view + " data=" + (data == null ? "null" : Integer.valueOf(data.length))
                        + " " + w + "x" + h + " ori=" + orientation + " fmt=" + format + " extras=" + extras);
            }
            sFrames = n + 1;
            if (!(view instanceof TextureView) || w <= 0 || h <= 0) { Log.e(TAG, "bad view/size"); return; }
            int need = w * h * 3 / 2;
            if ((data == null || data.length < need) && extras != null) {
                ParcelFileDescriptor pfd = extras.getParcelable("memoryfile_descriptor");
                if (pfd != null) {
                    Worker wk = sWorker;
                    byte[] buf = wk != null ? wk.spare(need) : null;
                    if (buf == null) buf = new byte[need];
                    long got = 0;
                    try (FileInputStream in = new FileInputStream(pfd.getFileDescriptor())) {
                        ByteBuffer bb = ByteBuffer.wrap(buf);
                        while (bb.hasRemaining()) {
                            int r = in.getChannel().read(bb, got);
                            if (r <= 0) break;
                            got += r;
                        }
                        if (sFrames <= 3) Log.i(TAG, "read " + got + " of " + need + " bytes from memory file (stat size " + pfd.getStatSize() + ")");
                    } finally {
                        try { pfd.close(); } catch (Exception e) { }
                    }
                    if (got >= need) data = buf;
                } else if (sFrames <= 3) {
                    Log.e(TAG, "bundle has no memoryfile_descriptor: " + extras.keySet());
                }
            }
            if (data == null || data.length < need) {
                Log.e(TAG, "no frame data (" + (data == null ? "null" : Integer.valueOf(data.length)) + " bytes)");
                return;
            }
            SurfaceTexture st = ((TextureView) view).getSurfaceTexture();
            if (st == null) {
                Log.e(TAG, "TextureView has no SurfaceTexture yet (available=" + ((TextureView) view).isAvailable() + ")");
                return;
            }
            if (sWorker == null) sWorker = new Worker();
            sWorker.offer(new Frame(st, data, w, h, orientation, sFrames));
        } catch (Throwable t) {
            Log.e(TAG, "render failed", t);
        }
    }

    public static void release() {
        try {
            Worker wk = sWorker;
            sWorker = null;
            if (wk != null) wk.quit();
        } catch (Throwable t) {
            Log.e(TAG, "release failed", t);
        }
    }

    private static final class Frame {
        final SurfaceTexture texture; final byte[] data; final int w, h, orientation, number;

        Frame(SurfaceTexture texture, byte[] data, int w, int h, int orientation, int number) {
            this.texture = texture; this.data = data; this.w = w; this.h = h; this.orientation = orientation; this.number = number;
        }
    }

    private static final class Worker implements Runnable {
        private final HandlerThread mThread = new HandlerThread(TAG);
        private final Handler mHandler;
        private final AtomicReference<Frame> mPending = new AtomicReference<>();
        private final AtomicReference<byte[]> mSpare = new AtomicReference<>();
        private volatile boolean mQuit;
        // worker thread only
        private Surface mSurface;
        private SurfaceTexture mTexture;
        private Bitmap mBitmap;
        private final ByteArrayOutputStream mJpeg = new ByteArrayOutputStream();
        private final Rect mRect = new Rect();
        private final Matrix mMatrix = new Matrix();
        private final RectF mBounds = new RectF();

        Worker() {
            mThread.start();
            mHandler = new Handler(mThread.getLooper());
        }

        byte[] spare(int size) {
            byte[] b = mSpare.getAndSet(null);
            return b != null && b.length == size ? b : null;
        }

        void offer(Frame f) {
            Frame old = mPending.getAndSet(f);
            if (old == null) mHandler.post(this);       // otherwise the queued run() takes the newer frame
            else mSpare.set(old.data);
        }

        void quit() {
            mQuit = true;
            mPending.set(null);
            mHandler.post(new Runnable() {
                @Override public void run() { close(); }
            });
            mThread.quitSafely();
        }

        @Override
        public void run() {
            Frame f = mPending.getAndSet(null);
            if (f == null || mQuit) return;
            try {
                draw(f);
            } catch (Throwable t) {
                Log.e(TAG, "render failed", t);
            }
            mSpare.set(f.data);
        }

        private void draw(Frame f) {
            if (f.texture.isReleased()) return;
            if (f.texture != mTexture) {
                if (mSurface != null) mSurface.release();
                mTexture = f.texture;
                mSurface = new Surface(f.texture);
            }
            mJpeg.reset();
            mRect.set(0, 0, f.w, f.h);
            new YuvImage(f.data, NV21, f.w, f.h, null).compressToJpeg(mRect, 85, mJpeg);
            Bitmap bmp = decode(mJpeg.toByteArray(), mJpeg.size());
            if (bmp == null) return;
            Canvas c = mSurface.lockCanvas(null);
            if (c == null) { Log.e(TAG, "lockCanvas returned null"); return; }
            try {
                c.drawColor(0xff000000);
                Matrix m = mMatrix;
                m.reset();
                m.postRotate(f.orientation, bmp.getWidth() / 2f, bmp.getHeight() / 2f);
                mBounds.set(0f, 0f, bmp.getWidth(), bmp.getHeight());
                m.mapRect(mBounds);
                m.postTranslate(-mBounds.left, -mBounds.top);
                float rw = mBounds.width(), rh = mBounds.height();
                float s = Math.max(c.getWidth() / rw, c.getHeight() / rh);
                m.postScale(-s, s);             // front camera: mirror
                m.postTranslate(c.getWidth() - (c.getWidth() - rw * s) / 2f, (c.getHeight() - rh * s) / 2f);
                c.drawBitmap(bmp, m, null);
            } finally {
                mSurface.unlockCanvasAndPost(c);
            }
            if (f.number <= 3 || f.number % 30 == 0) Log.i(TAG, "drew frame " + f.number + " canvas=" + c.getWidth() + "x" + c.getHeight());
        }

        // decodes into the previous frame's bitmap when the size allows it (same size every frame in practice)
        private Bitmap decode(byte[] jpeg, int len) {
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inMutable = true;
            if (mBitmap != null && !mBitmap.isRecycled()) o.inBitmap = mBitmap;
            Bitmap b;
            try {
                b = BitmapFactory.decodeByteArray(jpeg, 0, len, o);
            } catch (IllegalArgumentException e) {      // cannot reuse it: a fresh one
                o.inBitmap = null;
                b = BitmapFactory.decodeByteArray(jpeg, 0, len, o);
            }
            if (b != null && b != mBitmap) {
                if (mBitmap != null) mBitmap.recycle();
                mBitmap = b;
            }
            return b;
        }

        private void close() {
            if (mSurface != null) mSurface.release();
            mSurface = null;
            mTexture = null;
            if (mBitmap != null) mBitmap.recycle();
            mBitmap = null;
        }
    }
}
