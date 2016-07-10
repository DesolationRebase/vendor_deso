#!/bin/bash

# ------ CONFIGURATION ------
FILE_MATCH=Desolation*.zip
DEVICE=$DESO_BUILD
OLD_BUILD=`ls -t /usr/share/nginx/html/ota/delta/builds/$DEVICE/$FILE_MATCH | head -n1`
CURRENT_BUILD=`ls -t $ANDROID_PRODUCT_OUT/$FILE_MATCH | head -n1`
BASEOLDNAME=$(echo $OLD_BUILD | awk -F/ '{print $NF}')
BASENAME=$(echo $CURRENT_BUILD | awk -F/ '{print $NF}')

mkdir -p /usr/share/nginx/html/ota/delta/ota/$DEVICE/

DEV=${OTATYPE}
echo $DEV

# ------ PROCESS ------
getFileMD5() {
	TEMP=$(md5sum -b $1)
	for T in $TEMP; do echo $T; break; done
}

getFileSize() {
	echo $(stat --print "%s" $1)
}

nextPowerOf2() {
    local v=$1;
    ((v -= 1));
    ((v |= $v >> 1));
    ((v |= $v >> 2));
    ((v |= $v >> 4));
    ((v |= $v >> 8));
    ((v |= $v >> 16));
    ((v += 1));
    echo $v;
}

rm -rf /tmp/delta
mkdir -p /tmp/delta
LASTPWD=`pwd`
cd /tmp/delta
rm -rf work
mkdir work
rm -rf out
mkdir out

zipadjust --decompress $CURRENT_BUILD work/current.zip
zipadjust --decompress $OLD_BUILD work/last.zip

SRC_BUFF=$(nextPowerOf2 $(getFileSize work/current.zip));
xdelta3 -B ${SRC_BUFF} -9 -s work/last.zip work/current.zip out/$BASENAME.update

MD5_CURRENT=$(getFileMD5 work/current.zip)
MD5_LAST=$(getFileMD5 work/last.zip)
MD5_UPDATE=$(getFileMD5 out/$BASENAME.update)

SIZE_CURRENT=$(getFileSize work/current.zip)
SIZE_LAST=$(getFileSize work/last.zip)
SIZE_UPDATE=$(getFileSize out/$BASENAME.update)

DELTA=out/$BASEOLDNAME.delta

echo "{" > $DELTA
echo "  \"in\": {" >> $DELTA
echo "      \"name\": \"$BASEOLDNAME\"," >> $DELTA
echo "      \"size\": $SIZE_LAST," >> $DELTA
echo "      \"md5\": \"$MD5_LAST\"" >> $DELTA
echo "  }," >> $DELTA
echo "  \"out\": {" >> $DELTA
echo "      \"name\": \"$BASENAME\"," >> $DELTA
echo "      \"size\": $SIZE_CURRENT," >> $DELTA
echo "      \"md5\": \"$MD5_CURRENT\"" >> $DELTA
echo "  }," >> $DELTA
echo "  \"update\": {" >> $DELTA
echo "      \"file\": \"$BASENAME.update\"," >> $DELTA
echo "      \"dev\": \"$DEV\"," >> $DELTA
echo "      \"size\": $SIZE_UPDATE," >> $DELTA
echo "      \"md5\": \"$MD5_UPDATE\"" >> $DELTA
echo "  }" >> $DELTA
echo "}" >> $DELTA

cd work
md5sum last.zip > last.md5sum
md5sum current.zip > current.md5sum
cd ..
cp -v work/last.md5sum /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASEOLDNAME.md5sum
mv -v work/last.zip /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASEOLDNAME
cp -v work/current.md5sum /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASENAME.md5sum
mv -v work/current.zip /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASENAME
touch /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASEOLDNAME.md5sum
touch /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASEOLDNAME
touch /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASENAME.md5sum
touch /usr/share/nginx/html/ota/delta/builds/$DEVICE/$BASENAME
cp -v $DELTA /usr/share/nginx/html/ota/delta/ota/$DEVICE/
cp -v out/$BASENAME.update /usr/share/nginx/html/ota/delta/ota/$DEVICE/

rm -rf work
rm -rf out
cd $LASTPWD
rm -rf /tmp/delta

exit 0
