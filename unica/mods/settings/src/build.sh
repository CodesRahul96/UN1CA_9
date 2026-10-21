#!/bin/bash
# Compiles the hand-written Settings controllers in this directory to smali for SecSettings.apk/smali_classes3.
# javac (JDK 17) against stubs/ (exact signatures of the One UI 9 SecSettings build) + the SDK android.jar, then d8 and
# baksmali. Only classes under io/mesalabs/unica/settings/ are emitted; the stubs are never shipped.
#   AOSP=~/git/android ./build.sh
set -e
cd "$(dirname "$0")"
AOSP=${AOSP:-$HOME/git/android}
JDK=${JDK:-$HOME/jdk17}
ANDROID_JAR=${ANDROID_JAR:-$AOSP/prebuilts/sdk/36/public/android.jar}
D8=${D8:-$AOSP/out/host/linux-x86/bin/d8}
APKTOOL=${APKTOOL:-$(dirname "$0")/../../../../out/tools/bin/apktool.jar}
OUT=../SecSettings.apk/smali_classes3
for f in "$JDK/bin/javac" "$ANDROID_JAR" "$D8" "$APKTOOL"; do [ -e "$f" ] || { echo "missing: $f" >&2; exit 1; }; done
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
"$JDK/bin/javac" --release 11 -nowarn -encoding UTF-8 -cp "$ANDROID_JAR" \
    -d "$T/classes" $(find stubs io -name "*.java")
mkdir -p "$T/ship"
(cd "$T/classes" && find io/mesalabs/unica/settings -name "*.class" | cpio -pdm --quiet "$T/ship")
(cd "$T/classes" && rm -rf io/mesalabs/unica/settings && jar cf "$T/stubs.jar" .)
"$D8" --release --min-api 33 --lib "$ANDROID_JAR" --classpath "$T/stubs.jar" --output "$T" $(find "$T/ship" -name "*.class")
java -cp "$APKTOOL" com.android.tools.smali.baksmali.Main d --api 33 -o "$T/smali" "$T/classes.dex"
(cd "$T/smali" && find . -name "*.smali") | while read -r f; do
    mkdir -p "$OUT/$(dirname "$f")"; cp "$T/smali/$f" "$OUT/$f"; echo "  $OUT/${f#./}"
done
