#!/bin/sh
# Jake Yeung
# 5-make_bed_from_merged_motevo_output.sh
#  
# 2023-06-08


# make bed
# convertscript="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/merged_sites_to_bed.py"
# convertscript="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/merged_sites_to_bed.py"
convertscript=$1
[[ ! -e $convertscript ]] && echo "$convertscript not found, exiting" && exit 1

motevodirtmpmerged=$2
[[ ! -d $motevodirtmpmerged ]] && echo "$motevodirtmpmerged not found, exiting" && exit 1

# motevodirtmpbed="$motevodirtmpbase/bed"
motevodirtmpbed="$3"

outlog="${motevodirtmpbed}/make_bed_output.log"

# if [[ -d $motevodirtmpbed ]]
# then
#         echo "$motevodirtmpbed exists, skipping"
# else
        echo "Running convert script"
        mkdir $motevodirtmpbed
        python $convertscript $motevodirtmpmerged $motevodirtmpbed --get_exact_region
		ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1
# fi

echo "Running convert script done" > $outlog
