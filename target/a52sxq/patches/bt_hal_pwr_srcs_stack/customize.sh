# android.hardware.bluetooth@1.0-impl-qti.so: PowerManager::GetAndLogPwrRsrcStates(char*) (0x79540) clears a 30-int
# power source buffer at sp+0x10..sp+0x88, calls ioctl(/dev/btpower, BT_CMD_GETVAL_POWER_SRCS = 0xbfb1, sp+0x10), then
# formats it into the caller's 1024-byte log string. btpower.ko copy_to_user()s sizeof(bt_power_src_status) = 128
# bytes (32 ints since BT_VDD_SMPS/BT_VDD_SMPS_CURRENT were added; same in the stock A528BXXU5FWK4 module and in the
# bone-machine one), so the last 8 bytes overwrite the stack canary at x29-8 = sp+0x88 and the function always ends
# in __stack_chk_fail. It is only reached from error paths (UartController::LogPwrSrcsUartFlowCtrl, called by
# Logger::HandleHciEvent on a SoC HW error / ramdump event, by SsrCleanup and by UartController::Init), so a single
# controller hiccup, e.g. during the TLV patch download, kills the whole HAL instead of being recovered.
# Fix: keep the canary at x29+0x18 = sp+0xa8 instead, the unused 8-byte slot between x25 (sp+0xa0) and the x24/x23
# pair (sp+0xb0). sp+0x88..0x8f then just absorbs the BT_VDD_SMPS pair (not printed by the HAL).
LIB="$WORK_DIR/vendor/lib64/hw/android.hardware.bluetooth@1.0-impl-qti.so"
[ -f "$LIB" ] || ABORT "bt_hal_pwr_srcs_stack: $LIB not found"
python3 - "$LIB" << 'PYEOF' || ABORT "Failed to patch android.hardware.bluetooth@1.0-impl-qti.so"
import struct, sys
p = sys.argv[1]
d = bytearray(open(p, "rb").read())
def u32(o):
    return struct.unpack_from("<I", d, o)[0]
# file offset == vaddr in this segment (.text at 0x44000)
assert len(d) == 712848, "file size"
assert u32(0x79540) == 0xD10383FF, "sub sp, sp, #0xe0"
assert u32(0x79544) == 0xA9097BFD, "stp x29, x30, [sp, #0x90]"
assert u32(0x79548) == 0xF90053F9, "str x25, [sp, #0xa0]"
assert u32(0x7954C) == 0xA90B5FF8, "stp x24, x23, [sp, #0xb0]"
assert u32(0x79558) == 0x910243FD, "add x29, sp, #0x90"
assert u32(0x795C8) == 0x5297F621, "mov w1, #0xbfb1"
assert u32(0x7957C) == 0xF81F83A8, "stur x8, [x29, #-0x8]  (canary store)"
assert u32(0x79AE4) == 0xF85F83A9, "ldur x9, [x29, #-0x8]  (canary check)"
struct.pack_into("<I", d, 0x7957C, 0xF80183A8)   # stur x8, [x29, #0x18]
struct.pack_into("<I", d, 0x79AE4, 0xF84183A9)   # ldur x9, [x29, #0x18]
open(p, "wb").write(d)
PYEOF
LOG "- Bluetooth HAL: power source logging no longer smashes the stack canary"
unset LIB
