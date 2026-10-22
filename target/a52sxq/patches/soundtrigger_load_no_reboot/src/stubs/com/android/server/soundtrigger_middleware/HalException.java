package com.android.server.soundtrigger_middleware;
public class HalException extends RuntimeException {
    public int errorCode; // final in the real class; not a constant here so javac emits iget
}
