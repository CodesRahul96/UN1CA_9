#!/usr/bin/env bash
# Host test of the engine's reload / fingerprint logic and the clock gate (HostTest.java): the real classes from ../com
# are compiled against the SpriteWallpaper stubs (like ../build.sh) and run against the fakes here (fakes/: Android and
# SpriteWallpaper classes with working bodies, a virtual-clock main looper). Nothing here is shipped.
# Usage: run.sh [-v]   (-v: echo every log line)
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SDK="${ANDROID_HOME:-$HOME/Android/Sdk}"
JAR="$(ls -d "$SDK"/platforms/android-* | sort -V | tail -1)/android.jar"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/stubs" "$TMP/cls" "$TMP/fakes" "$TMP/test"
javac -nowarn -source 11 -target 11 -cp "$JAR" -d "$TMP/stubs" $(find "$HERE/../stubs" -name '*.java')
javac -nowarn -source 11 -target 11 -cp "$JAR:$TMP/stubs" -d "$TMP/cls" $(find "$HERE/../com" -name '*.java') 2>&1 | grep -v '^Note: ' || true
javac -nowarn -source 11 -target 11 -cp "$JAR" -d "$TMP/fakes" $(find "$HERE/fakes" -name '*.java')
javac -nowarn -source 11 -target 11 -cp "$TMP/fakes:$TMP/cls:$JAR" -d "$TMP/test" $(find "$HERE/com" -name '*.java')
java -Decho="$([ "${1:-}" = -v ] && echo true || echo false)" -cp "$TMP/fakes:$TMP/test:$TMP/cls:$JAR" com.k4.homeclock.HostTest
