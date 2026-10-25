#!/usr/bin/env bash
# Host test of k4-leveldb-stale: every scenario builds a fake /data under K4LDB_ROOT, runs the real script and compares
# the whole tree before/after (path, owner, type), so anything removed that should not be shows up. The tree has
# real owners: the test re-runs itself in a user namespace (unshare --map-auto --map-root-user, needs a subuid range
# of at least 65536) so it can chown to app uids like 10274/10293; users other than 0 have uids above 65535, so they
# are only covered by "not an app uid of this user" cases here (multi-user removal is covered on the phone).
# SELinux contexts come from a K4LDB_LABELS file. Nothing here is shipped.
# Usage: run.sh [-v]   (-v: print the script's log of every scenario). K4LDB_TEST_SH=<shell> picks the shell.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
if [ "$(id -u)" != 0 ] && [ -z "${K4LDB_IN_NS:-}" ]; then
    K4LDB_IN_NS=1 exec unshare --map-auto --map-root-user "$BASH" "$0" "$@"
fi
SCRIPT="$HERE/../k4-leveldb-stale"
SH="${K4LDB_TEST_SH:-bash}"
VERBOSE=false
[ "${1:-}" = -v ] && VERBOSE=true
T="$(mktemp -d)"
T="$(cd "$T" && pwd -P)"
trap 'rm -rf "$T"' EXIT
PASS=0
FAIL=0
CASE=""

ok() { PASS=$((PASS + 1)); }
bad() { FAIL=$((FAIL + 1)); echo "FAIL [$CASE]: $*"; }
has() { grep -q -F -- "$1" "$T/log" && ok || bad "'$1' not in the log"; }
hasnt() { grep -q -F -- "$1" "$T/log" && bad "'$1' unexpectedly in the log" || ok; }
quiet() { [ -s "$T/log" ] && bad "expected no log, got: $(cat "$T/log")" || ok; }

MP=10274
OLD=10293
CTX_NEW="u:object_r:media_rw_data_file:s0:c18,c257,c512,c768"
CTX_OLD="u:object_r:media_rw_data_file:s0:c37,c257,c512,c768"

# label <path> <context>
label() { echo "$1 $2" >> "$T/labels"; }

# ldb <dir> <owner> [context]: a LevelDB backup dir as MediaProvider leaves it
ldb() {
    mkdir -p "$1"
    for f in LOCK LOG LOG.old CURRENT MANIFEST-000150 000140.ldb 000151.log; do
        echo x > "$1/$f"
    done
    chown -R "$2:1023" "$1"
    chmod 2750 "$1"
    label "$1" "${3:-$CTX_NEW}"
}

# device: user 0 and Secure Folder 150 with a fresh (correct) backup, media files, obb, a TWRP dir
device() {
    rm -rf "$T/root" "$T/labels" "$T/log"
    R="$T/root"
    : > "$T/labels"
    : > "$T/log"
    mkdir -p "$R/data/system" "$R/data/media/obb" "$R/data/media/TWRP"
    printf '%s\n' \
        "com.android.providers.downloads 10076 0 /data/user/0/com.android.providers.downloads media:privapp:targetSdkVersion=36:partition=system 2001,5050 0 37 1 @system" \
        "com.google.android.providers.media.module $MP 0 /data/user/0/com.google.android.providers.media.module default:privapp:targetSdkVersion=37:partition=system 3007,3007 0 37 1 @system" \
        "com.google.android.overlay.modules.mediaprovider 10026 0 /data/user/0/com.google.android.overlay.modules.mediaprovider release:targetSdkVersion=37:partition=product none 0 37 1 @system" \
        > "$R/data/system/packages.list"
    for u in 0 150; do
        rec="$R/data/media/$u/.transforms/recovery"
        mkdir -p "$rec" "$R/data/media/$u/DCIM/Camera" "$R/data/media/$u/.transforms/synthetic"
        echo jpg > "$R/data/media/$u/DCIM/Camera/IMG_0001.jpg"
        echo other > "$rec/notes.txt"
    done
    for n in internal external_primary ownership deleted-files-external_primary; do
        ldb "$R/data/media/0/.transforms/recovery/leveldb-$n" $MP
    done
    # user 150's uids are above the namespace's 65536 range: no backup dirs there (cases below add some)
    REC="$R/data/media/0/.transforms/recovery"
}

snap() { (cd "$T/root" && find . -printf '%p %U %y\n' | LC_ALL=C sort); }

# run [args]: run the script, keep before/after snapshots
run() {
    snap > "$T/before"
    K4LDB_ROOT="$T/root" K4LDB_LOG="$T/log" K4LDB_LABELS="$T/labels" "$SH" "$SCRIPT" "$@"
    RC=$?
    snap > "$T/after"
    [ $RC = 0 ] && ok || bad "exit status $RC"
    $VERBOSE && [ -s "$T/log" ] && sed "s/^/    [$CASE] /" "$T/log"
}

# removed <path>...: exactly these paths (and everything below them) disappeared, nothing else changed
removed() {
    local expect="$T/expect" p
    cp "$T/before" "$expect"
    for p in "$@"; do
        p="./${p#"$T/root/"}"
        grep -v -F -e "$p " -e "$p/" "$expect" > "$expect.n"
        mv "$expect.n" "$expect"
    done
    if diff -q "$expect" "$T/after" > /dev/null; then ok; else bad "tree changed unexpectedly:$(diff "$expect" "$T/after" | head -20 | sed 's/^/ | /')"; fi
}
unchanged() { removed; }

CASE="clean phone"
device
run
unchanged
quiet

CASE="stale after dirty flash"
device
for n in internal external_primary ownership fef7-d915; do
    rm -rf "$REC/leveldb-$n"
    ldb "$REC/leveldb-$n" $OLD "$CTX_OLD"
done
run
removed "$REC/leveldb-internal" "$REC/leveldb-external_primary" "$REC/leveldb-ownership" "$REC/leveldb-fef7-d915"
has "removed stale MediaProvider backup $REC/leveldb-internal (owner $OLD, MediaProvider is $MP)"
has "removed stale MediaProvider backup $REC/leveldb-fef7-d915"
hasnt "leveldb-deleted-files-external_primary"
[ "$(grep -c removed "$T/log")" = 4 ] && ok || bad "expected 4 removals: $(cat "$T/log")"
CASE="second run is a no-op"
: > "$T/log"
ldb "$REC/leveldb-internal" $MP # MediaProvider recreates it
run
unchanged
quiet

CASE="symlinked leveldb dir"
device
rm -rf "$REC/leveldb-internal"
chown -R $OLD "$R/data/media/0/DCIM"
ln -s ../../DCIM/Camera "$REC/leveldb-internal"
chown -h $OLD "$REC/leveldb-internal"
run
unchanged
has "left alone $REC/leveldb-internal: symlink"

CASE="symlinked .transforms"
device
mkdir -p "$T/root/elsewhere/recovery"
ldb "$T/root/elsewhere/recovery/leveldb-internal" $OLD "$CTX_OLD"
mv "$R/data/media/0/.transforms" "$R/data/media/0/.transforms.real"
ln -s ../../../elsewhere "$R/data/media/0/.transforms"
run
unchanged
has "left alone user 0: symlink"

CASE="symlinked recovery"
device
mkdir -p "$T/root/elsewhere"
ldb "$T/root/elsewhere/leveldb-internal" $OLD "$CTX_OLD"
mv "$REC" "$REC.real"
ln -s ../../../../elsewhere "$REC"
run
unchanged
has "left alone user 0: symlink"

CASE="symlinked user dir"
device
mkdir -p "$T/root/elsewhere/.transforms/recovery"
ldb "$T/root/elsewhere/.transforms/recovery/leveldb-internal" $OLD "$CTX_OLD"
ln -s ../../elsewhere "$R/data/media/10"
run
unchanged
has "left alone user 10: symlink"

CASE="symlinked /data/media/0 parent path"
device
mkdir -p "$T/root/x"
mv "$R/data/media" "$T/root/x/media"
ln -s ../x/media "$R/data/media"
rm -rf "$T/root/x/media/0/.transforms/recovery/leveldb-internal"
ldb "$T/root/x/media/0/.transforms/recovery/leveldb-internal" $OLD "$CTX_OLD"
run
unchanged
has "is not where it should be"

CASE="stale dir with a media file in it"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
echo jpg > "$REC/leveldb-internal/IMG_0002.jpg"
chown $OLD "$REC/leveldb-internal/IMG_0002.jpg"
run
unchanged
has "left alone $REC/leveldb-internal: it holds something that is not a LevelDB file"

CASE="stale dir with a hidden file"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
echo x > "$REC/leveldb-internal/.nomedia"
run
unchanged
has "not a LevelDB file"

CASE="stale dir with a subdirectory"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
mkdir "$REC/leveldb-internal/000001.ldb"
run
unchanged
has "not a LevelDB file"

CASE="stale dir with a symlink named like a LevelDB file"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
rm "$REC/leveldb-internal/LOCK"
ln -s ../../../DCIM/Camera/IMG_0001.jpg "$REC/leveldb-internal/LOCK"
run
unchanged
has "not a LevelDB file"

CASE="stale dir with odd LevelDB-like names"
for n in MANIFEST- MANIFEST-12a x.ldb .ldb 000001.ldb.jpg LOG.old.1; do
    device
    rm -rf "$REC/leveldb-internal"
    ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
    echo x > "$REC/leveldb-internal/$n"
    run
    unchanged
    has "not a LevelDB file"
done

CASE="all LevelDB file kinds are removed"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
for n in 000003.sst 000004.dbtmp MANIFEST-000001 000009.log; do echo x > "$REC/leveldb-internal/$n"; done
chown $OLD "$REC/leveldb-internal/"*
run
removed "$REC/leveldb-internal"
has "removed stale MediaProvider backup $REC/leveldb-internal"

CASE="empty stale dir"
device
rm -rf "$REC/leveldb-internal"
mkdir "$REC/leveldb-internal"
chown $OLD "$REC/leveldb-internal"
label "$REC/leveldb-internal" "$CTX_OLD"
run
removed "$REC/leveldb-internal"

CASE="owner is not an app uid"
for o in 0 1000 1023 9999 20000; do
    device
    rm -rf "$REC/leveldb-internal"
    ldb "$REC/leveldb-internal" $o
    run
    unchanged
    has "left alone $REC/leveldb-internal: owner $o is not an app uid of user 0"
done

CASE="user 150 dir owned by a user-0 uid"
device
ldb "$R/data/media/150/.transforms/recovery/leveldb-internal" $OLD
run
unchanged
has "owner $OLD is not an app uid of user 150 (MediaProvider is 15010274)"

CASE="wrong label"
for c in "u:object_r:app_data_file:s0:c37,c257,c512,c768" "?" "u:object_r:media_rw_data_file" \
    "u:object_r:media_rw_data_file:s0x" "u:object_r:media_rw_data_file_x:s0" ""; do
    device
    rm -rf "$REC/leveldb-internal"
    ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
    label "$REC/leveldb-internal" "$c"
    run
    unchanged
    has "left alone $REC/leveldb-internal: label"
done

CASE="current owner, other categories"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $MP "$CTX_OLD"
run
unchanged
has "note $REC/leveldb-internal: owner $MP is MediaProvider's but the categories are c37,c257,c512,c768 (expected c18,c257,c512,c768), left alone"

CASE="not a directory / odd names"
device
echo x > "$REC/leveldb-file"
chown $OLD "$REC/leveldb-file"
label "$REC/leveldb-file" "$CTX_OLD"
mkdir "$REC/leveldb-" "$REC/leveldb-a b" "$REC/leveldb-a.b"
chown $OLD "$REC/leveldb-" "$REC/leveldb-a b" "$REC/leveldb-a.b"
run
unchanged
has "left alone $REC/leveldb-file: not a directory"
has "left alone $REC/leveldb-: unexpected name"
has "left alone $REC/leveldb-a b: unexpected name"
has "left alone $REC/leveldb-a.b: unexpected name"

CASE="non-numeric user dirs are ignored"
device
for u in TWRP obb 0x 00000001234; do
    mkdir -p "$R/data/media/$u/.transforms/recovery"
    ldb "$R/data/media/$u/.transforms/recovery/leveldb-internal" $OLD "$CTX_OLD"
done
run
unchanged
quiet

CASE="locked user (no .transforms visible)"
device
mkdir -p "$R/data/media/11/AbCdEfGh0123"
run
unchanged
quiet

CASE="no MediaProvider in packages.list"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
grep -v providers.media.module "$R/data/system/packages.list" > "$T/pl" && cp "$T/pl" "$R/data/system/packages.list"
run
unchanged
quiet

CASE="no packages.list"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
rm "$R/data/system/packages.list"
run
unchanged
quiet

CASE="both MediaProvider packages, different uids"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
echo "com.android.providers.media.module 10111 0 /data/user/0/com.android.providers.media.module media:privapp:targetSdkVersion=37 none 0 37 1 @system" >> "$R/data/system/packages.list"
run
unchanged
has "more than one MediaProvider package"

CASE="AOSP MediaProvider package"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
sed -i "s/^com.google.android.providers.media.module $MP /com.android.providers.media.module $MP /" "$R/data/system/packages.list"
run
removed "$REC/leveldb-internal"

CASE="MediaProvider uid is not an app uid"
for u in 1013 9999 20000 x10274; do
    device
    rm -rf "$REC/leveldb-internal"
    ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
    sed -i "s/^com.google.android.providers.media.module $MP /com.google.android.providers.media.module $u /" "$R/data/system/packages.list"
    run
    unchanged
done

CASE="package name prefix does not match"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
sed -i "s/^com.google.android.providers.media.module $MP /com.google.android.providers.media.modulex $MP /" "$R/data/system/packages.list"
run
unchanged
quiet

CASE="no recovery dir yet"
device
rm -rf "$REC"
run
unchanged
quiet

CASE="ce: user 0 only"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
ldb "$R/data/media/150/.transforms/recovery/leveldb-internal" $OLD
run ce
removed "$REC/leveldb-internal"
has "removed stale MediaProvider backup $REC/leveldb-internal"
hasnt "user 150"

CASE="late: every user but 0"
device
rm -rf "$REC/leveldb-internal"
ldb "$REC/leveldb-internal" $OLD "$CTX_OLD"
ldb "$R/data/media/150/.transforms/recovery/leveldb-internal" $OLD
ldb "$R/data/media/10/.transforms/recovery/leveldb-internal" 1023
K4LDB_WAIT=0 run late
unchanged
hasnt "$REC/leveldb-internal"
has "owner $OLD is not an app uid of user 150"
has "owner 1023 is not an app uid of user 10"

CASE="late: waits for a user whose storage unlocks later"
device
mkdir -p "$R/data/media/11/AbCdEfGh0123" # locked: encrypted names only
mkdir -p "$T/unlocked/.transforms/recovery"
ldb "$T/unlocked/.transforms/recovery/leveldb-internal" 1023
label "$R/data/media/11/.transforms/recovery/leveldb-internal" "$CTX_NEW"
(sleep 2; mv "$T/unlocked/.transforms" "$R/data/media/11/.transforms") &
start=$(date +%s)
K4LDB_WAIT=10 run late
wait
took=$(($(date +%s) - start))
has "left alone $R/data/media/11/.transforms/recovery/leveldb-internal: owner 1023 is not an app uid of user 11"
[ $took -ge 2 ] && [ $took -le 6 ] && ok || bad "late run took $took s (expected 2-6: stop once nobody is locked)"

CASE="late: gives up after the wait"
device
mkdir -p "$R/data/media/11/AbCdEfGh0123"
start=$(date +%s)
K4LDB_WAIT=3 run late
took=$(($(date +%s) - start))
unchanged
quiet
[ $took -ge 3 ] && [ $took -le 5 ] && ok || bad "late run took $took s (expected 3-5)"

CASE="late: nothing locked, no wait"
device
start=$(date +%s)
run late
took=$(($(date +%s) - start))
[ $took -le 1 ] && ok || bad "late run took $took s with nobody locked"
quiet

echo "k4-leveldb-stale host test ($SH): $PASS passed, $FAIL failed"
[ $FAIL = 0 ]
