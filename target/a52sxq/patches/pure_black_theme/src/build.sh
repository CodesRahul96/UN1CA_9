#!/usr/bin/env bash
# Regenerates ../K4PureBlackPreferenceController.smali from the Java source here (javac + d8 + baksmali) and keeps the
# comment block of the current smali (everything between the .implements lines and "# static fields").
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="${SRC_DIR:-$(cd "$HERE/../../../../.." && pwd)}"
SDK="${ANDROID_HOME:-$HOME/Android/Sdk}"
BT="$(ls -d "$SDK"/build-tools/* | sort -V | tail -1)"
JAR="$(ls -d "$SDK"/platforms/android-* | sort -V | tail -1)/android.jar"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/stubs" "$TMP/cls" "$TMP/dex"
javac -nowarn -source 11 -target 11 -g:none -cp "$JAR" -d "$TMP/stubs" $(find "$HERE/stubs" -name '*.java')
javac -nowarn -source 11 -target 11 -g:none -cp "$TMP/stubs:$JAR" -d "$TMP/cls" $(find "$HERE/com" -name '*.java')
"$BT/d8" --release --min-api 34 --lib "$JAR" --classpath "$TMP/stubs" --output "$TMP/dex" $(find "$TMP/cls" -name '*.class')
java -cp "$SRC_DIR/out/tools/bin/apktool.jar" com.android.tools.smali.baksmali.Main d -o "$TMP/smali" "$TMP/dex/classes.dex"
python3 - "$HERE/../K4PureBlackPreferenceController.smali" "$TMP/smali/com/k4/settings/display/K4PureBlackPreferenceController.smali" << 'PYEOF'
import re, sys
old, new = open(sys.argv[1]).read(), open(sys.argv[2]).read()
m = re.search(r"\n\.implements Ljava/lang/Runnable;\n\n(.*?)\n# (?:static|instance) fields\n", old, re.S)
note = m.group(1).strip("\n") + "\n" if m else ""
new = new.replace("\n.implements Ljava/lang/Runnable;\n", "\n.implements Ljava/lang/Runnable;\n\n" + note, 1) if note else new
open(sys.argv[1], "w").write(new)
PYEOF
