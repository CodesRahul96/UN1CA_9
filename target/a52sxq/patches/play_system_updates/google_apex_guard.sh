# Sourced by target/a52sxq/post_mods.sh, i.e. after every device patch, unica/patches and unica/mods have run.
# Google Play system updates (mainline trains) only install over a pre-installed APEX signed with the same keys, so
# every Google APEX the ROM ships must be the source firmware's file, byte for byte: a re-signed or rebuilt one makes
# Play's update fail before the reboot ("APK container signature ... is not compatible", 10-10, census R6), a
# modified payload breaks the precompiled odex/boot classpath that comes with it. Checked: com.google.* (.apex, .capex)
# and every *tzdata* APEX in system/apex, system_ext/apex and product/apex (vendor/apex comes from the
# target firmware and holds no Play-updatable Google module). Our own modified APEXes are all com.android.* and so not
# covered on purpose: com.android.bt.apex (bt_a2dp_offload), com.android.runtime.apex (__desixtification),
# com.android.virt.apex (virt) - Samsung/AOSP-built modules that Play never updates.
# A patch that replaces a Google APEX on purpose must be listed here (work dir name -> what it replaces):
GAG_INTENDED=()
if ${TARGET_TETHERING_RESIGN_APEX:-false}; then
    # tethering: our re-signed Tethering (Play then cannot update Tethering, accepted in that rollback mode)
    GAG_INTENDED+=("system/apex/com.google.android.tethering.apex")
    GAG_INTENDED+=("-system/apex/com.google.android.tethering_compressed.apex")   # removed by it
fi
if [ ! -f "$SRC_DIR/target/a52sxq/patches/degoogle/disable" ]; then
    # degoogle: the GMS system APEX goes with the rest of the Google services stack
    GAG_INTENDED+=("-product/apex/com.google.android.gmssystem.prodvic.apex")
fi

GAG_SRC="$FW_DIR/$SOURCE_FIRMWARE_PATH"
[ -d "$GAG_SRC/system/system/apex" ] || ABORT "play_system_updates: source firmware apex dir not found ($GAG_SRC)"
# module name without its container suffix, to tell "differs" from "shipped as another container"
GAG_BASE() { local b="${1##*/}"; b="${b%.capex}"; b="${b%.apex}"; echo "${b%_compressed}"; }
GAG_N=0; GAG_NSRC=0; GAG_BAD=""
for GAG_DIR in system/apex system_ext/apex product/apex; do
    case "$GAG_DIR" in
        system/apex) GAG_W="$WORK_DIR/system/system/apex"; GAG_S="$GAG_SRC/system/system/apex" ;;
        system_ext/apex)   # own partition or inside /system, whichever the image has
            GAG_W="$WORK_DIR/system_ext/apex"; [ -d "$GAG_W" ] || GAG_W="$WORK_DIR/system/system/system_ext/apex"
            GAG_S="$GAG_SRC/system_ext/apex"; [ -d "$GAG_S" ] || GAG_S="$GAG_SRC/system/system/system_ext/apex" ;;
        product/apex) GAG_W="$WORK_DIR/product/apex"; GAG_S="$GAG_SRC/product/apex" ;;
    esac
    GAG_SEEN=" "
    for GAG_F in "$GAG_W"/com.google.* "$GAG_W"/*tzdata*; do
        [ -f "$GAG_F" ] || continue
        GAG_NAME="$GAG_DIR/$(basename "$GAG_F")"
        [[ "$GAG_SEEN" == *" $GAG_NAME "* ]] && continue   # com.google.android.tzdata* matches both globs
        GAG_SEEN="$GAG_SEEN$GAG_NAME "
        if [[ " ${GAG_INTENDED[*]} " == *" $GAG_NAME "* ]]; then
            LOG "- $GAG_NAME: replaced on purpose (listed in google_apex_guard.sh)"
        elif [ ! -f "$GAG_S/$(basename "$GAG_F")" ]; then
            GAG_OTHER=""
            for GAG_O in "$GAG_S"/*; do
                if [ -f "$GAG_O" ] && [ "$(GAG_BASE "$GAG_O")" = "$(GAG_BASE "$GAG_F")" ]; then GAG_OTHER="$(basename "$GAG_O")"; fi
            done
            if [ -n "$GAG_OTHER" ]; then
                GAG_BAD="$GAG_BAD $GAG_NAME(the source ships this module as $GAG_OTHER, a different file)"
            else
                GAG_BAD="$GAG_BAD $GAG_NAME(not in the source firmware)"
            fi
        elif ! cmp -s "$GAG_F" "$GAG_S/$(basename "$GAG_F")"; then
            GAG_BAD="$GAG_BAD $GAG_NAME(differs from the source firmware)"
        else
            GAG_N=$((GAG_N + 1))
        fi
    done
    # the other way round: a Google APEX of the source that the ROM no longer ships cannot be updated by Play either
    GAG_SEEN=" "
    for GAG_F in "$GAG_S"/com.google.* "$GAG_S"/*tzdata*; do
        [ -f "$GAG_F" ] || continue
        GAG_NAME="$GAG_DIR/$(basename "$GAG_F")"
        [[ "$GAG_SEEN" == *" $GAG_NAME "* ]] && continue
        GAG_SEEN="$GAG_SEEN$GAG_NAME "
        GAG_NSRC=$((GAG_NSRC + 1))
        if [ ! -f "$GAG_W/$(basename "$GAG_F")" ]; then
            if [[ " ${GAG_INTENDED[*]} " == *" -$GAG_NAME "* ]]; then
                LOG "- $GAG_NAME: removed on purpose (listed in google_apex_guard.sh)"
            else
                LOGW "play_system_updates: $GAG_NAME of the source firmware is not in the ROM - Play cannot update that module"
            fi
        fi
    done
done
[ -z "$GAG_BAD" ] || ABORT "play_system_updates: Google APEX not byte-identical to the source firmware, Play system updates for it would fail:$GAG_BAD - ship the source's file, or list it in play_system_updates/google_apex_guard.sh if that is intended"
if [ "$GAG_NSRC" = 0 ]; then
    LOG "- The source firmware ships no Google APEX: nothing for the Google APEX guard to check"
else
    [ "$GAG_N" -gt 0 ] || ABORT "play_system_updates: the source firmware has $GAG_NSRC Google APEXes but none of them is in the work dir (path changed?)"
    LOG "- $GAG_N Google APEXes are byte-identical to the source firmware (Play system updates can install over them)"
fi
unset GAG_INTENDED GAG_SRC GAG_N GAG_NSRC GAG_BAD GAG_DIR GAG_W GAG_S GAG_F GAG_NAME GAG_SEEN GAG_O GAG_OTHER
unset -f GAG_BASE
