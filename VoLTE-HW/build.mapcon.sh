#!/bin/bash

set -e

if [ "$#" -ne 1 ];then
	echo "Usage: $0 /path/to/HwIms/folder"
	exit 1
fi

app_folder="$(realpath $1)"

rm -f HwIms_classes.cdex
../Tools/vdexExtractor -i "$app_folder"/oat/arm64/HwIms.vdex -o .

rm -f HwIms_classes.cdex.new
../Tools/compact_dex_converter HwIms_classes.cdex

rm -f HwIms_classes.cdex-dex2jar.jar
../Tools/dex2jar/d2j-dex2jar.sh HwIms_classes.cdex.new

rm -f com.hisi.mapcon-java.jar
../Tools/dex2jar/d2j-class-version-switch.sh 8 HwIms_classes.cdex-dex2jar.jar com.hisi.mapcon-java.jar

zip -qd com.hisi.mapcon-java.jar 'android/*' 'vendor/*' 'com/huawei/*' 'com/android/*' # Leaving only com/hisi/mapcon
