#!/usr/bin/env bash
# Host test of the GPU driver selector's plain-Java parts (GpuDriverModel: entries, selection, removal;
# GpuDriverPackage: zip layouts, checks, version strings): the real classes from ../io, a test in the same package.
# They use no Android classes, so no stubs or fakes are needed. Nothing here is shipped.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
JDK="${JDK:-$HOME/jdk17}"
JAVAC="$JDK/bin/javac"; [ -x "$JAVAC" ] || JAVAC=javac
JAVA="$JDK/bin/java"; [ -x "$JAVA" ] || JAVA=java
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
U="$HERE/../io/mesalabs/unica/settings/ui"
"$JAVAC" --release 11 -nowarn -encoding UTF-8 -d "$TMP" "$U/GpuDriverModel.java" "$U/GpuDriverPackage.java" \
    $(find "$HERE/io" -name "*.java")
"$JAVA" -cp "$TMP" io.mesalabs.unica.settings.ui.GpuDriverHostTest
