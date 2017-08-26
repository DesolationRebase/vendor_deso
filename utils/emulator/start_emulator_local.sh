#!/bin/sh

# assumes the image zip has been extracted in /tmp

/opt/android-sdk/tools/emulator  -verbose -skindir $ANDROID_BUILD_TOP/vendor/deso/utils/emulator/skins/ -skin pixel_xl -ramdisk /opt/android-sdk/system-images/android-26/google_apis/x86/ramdisk.img  -kernel /opt/android-sdk/system-images/android-26/google_apis/x86/kernel-ranchu -gpu host
