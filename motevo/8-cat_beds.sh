#!/bin/sh
# Jake Yeung
# 8-cat_beds.sh
#  
# 2023-06-08


motevodirtmpbedclosestlong=$1
merged_motevodirtmpbed=$2

# cat beds
# merged_motevodirtmpbed="$motevodirtmpbed/merged_bed_closestbed_long"
[[ ! -d $merged_motevodirtmpbed ]] && mkdir $merged_motevodirtmpbed
[[ ! -d $merged_motevodirtmpbed ]] && echo "$merged_motevodirtmpbed not found, exiting" && exit 1

mergedname="motevo_merged.closest.long.bed"
mergednamezip="motevo_merged.closest.long.bed.gz"
echo "Running cat beds"
echo "Catting beds"
# cat $motevodirtmpbedclosestlong/*.bed >> $merged_motevodirtmpbed/$mergedname
# reorganize
cat $motevodirtmpbedclosestlong/*.bed | sed  's/\;/\t/g' | sed 's/mm10_//g' | awk -F"\t" -v OFS="\t" ' { t = $5; $5 = $6; $6 = $7; $7 = $8; $8 = t; print; } ' | tr -d $"\r" >> $merged_motevodirtmpbed/$mergedname

# gzip output
sort -k1,1 -k2,2n $merged_motevodirtmpbed/$mergedname | bgzip > $merged_motevodirtmpbed/$mergednamezip
