#!/usr/bin/env bash
# Regenerates ../smali/com/k4/face/*.smali from the Java source here (javac + d8 + baksmali). Public SDK only.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="${SRC_DIR:-$(cd "$HERE/../../../../.." && pwd)}"
SDK="${ANDROID_HOME:-$HOME/Android/Sdk}"
BT="$(ls -d "$SDK"/build-tools/* | sort -V | tail -1)"
JAR="$(ls -d "$SDK"/platforms/android-* | sort -V | tail -1)/android.jar"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/cls" "$TMP/dex"
javac -nowarn -source 11 -target 11 -g:none -XDstringConcat=inline -cp "$JAR" -d "$TMP/cls" $(find "$HERE/com" -name '*.java')
"$BT/d8" --release --min-api 34 --lib "$JAR" --output "$TMP/dex" $(find "$TMP/cls" -name '*.class')
rm -rf "$HERE/../smali"
java -cp "$SRC_DIR/out/tools/bin/apktool.jar" com.android.tools.smali.baksmali.Main d -o "$HERE/../smali" "$TMP/dex/classes.dex"
find "$HERE/../smali" -name '*.smali' | sort
