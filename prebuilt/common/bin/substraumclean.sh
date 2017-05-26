#!/sbin/sh
PATH=/sbin:/system/bin:/system/xbin

OUTFD=$2

ui_print() {
echo -n -e "ui_print $1\n" > /proc/self/fd/$OUTFD
echo -n -e "ui_print\n" > /proc/self/fd/$OUTFD
}

ui_print "===================================================="
ui_print "  Substratum Overlay Manager Service Rescue System"
ui_print "===================================================="

ui_print "- Mounting /system"
mount /system
mount -o rw,remount /system
mount -o rw,remount /system /system

ui_print "- Removing overlay saved states"
rm -rf /data/system/overlays.xml

ui_print "- Removing Substratum directories"
rm -rf /sdcard/substratum
rm -rf /sdcard/.substratum

ui_print "- Removing theme directory"
rm -rf /data/system/theme

ui_print "- Unmounting /system"
umount /system
