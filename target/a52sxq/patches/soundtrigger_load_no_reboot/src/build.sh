#!/usr/bin/env bash
# Regenerates ../K4StRetry*.smali from com/k4/soundtrigger/K4StRetry.java (javac --release 11 + d8 + baksmali).
# stubs/ only declares the hidden framework / services.jar members the helper uses; they are not shipped
# (the helper is copied into services.jar, next to the real classes).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="${SRC_DIR:-$(cd "$HERE/../../../../.." && pwd)}"
SDK="${ANDROID_HOME:-$HOME/Android/Sdk}"
BT="$(ls -d "$SDK"/build-tools/* | sort -V | tail -1)"
JAR="$(ls -d "$SDK"/platforms/android-* | sort -V | tail -1)/android.jar"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/stubs" "$TMP/cls" "$TMP/dex" "$TMP/smali"
javac -nowarn --release 11 -cp "$JAR" -d "$TMP/stubs" $(find "$HERE/stubs" -name '*.java')
javac -nowarn --release 11 -cp "$TMP/stubs:$JAR" -d "$TMP/cls" $(find "$HERE/com" -name '*.java')
"$BT/d8" --min-api 36 --lib "$JAR" --classpath "$TMP/stubs" --output "$TMP/dex" $(find "$TMP/cls" -name '*.class')
java -cp "$SRC_DIR/out/tools/bin/apktool.jar" com.android.tools.smali.baksmali.Main d -o "$TMP/smali" "$TMP/dex/classes.dex"
rm -f "$HERE"/../K4StRetry*.smali
cp "$TMP"/smali/com/k4/soundtrigger/K4StRetry*.smali "$HERE/.."
ls "$HERE"/../K4StRetry*.smali
