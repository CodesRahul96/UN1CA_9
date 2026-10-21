# See module.prop. Every line is removed only if it is there exactly once, so a changed base aborts instead of guessing.
VEND="$WORK_DIR/vendor/etc/selinux/vendor_sepolicy.cil"
[ -f "$VEND" ] || ABORT "sepolicy_tighten: vendor_sepolicy.cil not found"
for RULE in "(allow platform_app_30_0 shell_data_file_30_0 (file (execute execute_no_trans)))" \
    "(allow platform_app_30_0 sec_debugfs (file (read)))"; do
    N="$(grep -c -x -F -- "$RULE" "$VEND" || true)"
    if [ "$N" = 1 ]; then
        RULE="$RULE" python3 -c 'import os,sys; p=sys.argv[1]; r=os.environ["RULE"]+"\n"; s=open(p).read(); assert s.count(r)==1; open(p,"w").write(s.replace(r,"",1))' "$VEND" \
            || ABORT "sepolicy_tighten: failed to remove $RULE"
    elif [ "$N" != 0 ]; then
        ABORT "sepolicy_tighten: $RULE is in vendor_sepolicy.cil $N times"
    fi
    ! grep -q -x -F -- "$RULE" "$VEND" || ABORT "sepolicy_tighten: $RULE still present"
done
for f in precompiled_sepolicy precompiled_sepolicy.plat_sepolicy_and_mapping.sha256 \
    precompiled_sepolicy.product_sepolicy_and_mapping.sha256 precompiled_sepolicy.system_ext_sepolicy_and_mapping.sha256; do
    [ ! -f "$WORK_DIR/odm/etc/selinux/$f" ] || DELETE_FROM_WORK_DIR "odm" "etc/selinux/$f"
done
[ ! -e "$WORK_DIR/odm/etc/selinux/precompiled_sepolicy" ] || ABORT "sepolicy_tighten: odm precompiled_sepolicy still present"
LOG "- SELinux: dropped A14-only platform_app rules (exec in /data/local/tmp, sec_debugfs), removed the stale odm precompiled policy"
unset VEND RULE N f
