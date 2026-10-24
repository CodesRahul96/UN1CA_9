#!/usr/bin/env bash
# Host test of the DressRoom helpers' pure logic (StretchHoldTest.java: the saved home clock's stretch heights hold).
# Only classes without Android dependencies are compiled from ../com; nothing here is shipped.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
javac -nowarn -source 11 -target 11 -d "$TMP" "$HERE/../com/k4/dressroom/StretchHold.java" $(find "$HERE/com" -name '*.java')
java -cp "$TMP" com.k4.dressroom.StretchHoldTest
