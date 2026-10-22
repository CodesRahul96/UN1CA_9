package com.android.server.soundtrigger_middleware;
public class RecoverableException extends RuntimeException {
    public RecoverableException(int errorCode, String message) { throw new RuntimeException(); }
}
