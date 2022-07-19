#!/bin/bash

set -e

if [ "$#" -ne 1 ];then
	echo "Usage: $0 /path/to/gnss_supl20service_hisi/folder"
	exit 1
fi

app_folder="$(realpath $1)"

rm -f gnss_supl20service_hisi_classes.cdex
../Tools/vdexExtractor -i "$app_folder"/oat/arm64/gnss_supl20service_hisi.vdex -o .

rm -f gnss_supl20service_hisi_classes.cdex.new
../Tools/compact_dex_converter gnss_supl20service_hisi_classes.cdex

rm -f gnss_supl20service_hisi_classes.cdex-dex2jar.jar
../Tools/dex2jar/d2j-dex2jar.sh gnss_supl20service_hisi_classes.cdex.new

rm -f gnss_supl20service_hisi_classes.jar
../Tools/dex2jar/d2j-class-version-switch.sh 8 gnss_supl20service_hisi_classes.cdex-dex2jar.jar gnss_supl20service_hisi_classes.jar
