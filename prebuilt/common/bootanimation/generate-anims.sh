#!/bin/sh

RESOLUTIONS="240 320 360 480 540 600 720 768 800 1080 1200 1440"

for i in $RESOLUTIONS; do
	rm -f $i.zip
	mkdir $i
	cd $i
	unzip ../bootanimation.zip
	for j in */*.[pP][nN][gG]; do
		convert $j -resize "$i"x$(bc <<< "scale=0;$i*0.4186/1") tmp.png
		pngquant --force --output $j tmp.png
		rm tmp.png
	done
	frameliney=$i
	framelinex=$(bc <<< "scale=0; $i*0.4186/1")
	frameline=$(echo $frameliney $framelinex 30)
	sed "1s/.*/$frameline/" desc.txt > desc.tmp
	mv desc.tmp desc.txt
	zip -r0 ../$i.zip .
	cd ..
	rm -rf $i
done
