#!/bin/sh
# Jake Yeung
# 4-merge_motevo_output.sh
#  
# 2023-06-01

# mergescript="/home/hub_oudenaarden/jyeung/projects/from_PhD/tissue-specificity-shellscripts/mara_dhs/3-run_motevo_on_regions/merge_motevo_output.py"
# mergescript="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/merge_motevo_output.py"
mergescript=$1
wmdir=$2
motevodirtmpsplit=$3
motevodirtmpmerged=$4
wmnames=$5

outlog=${motevodirtmpmerged}/merge_motevo_output.log

[[ ! -e $mergescript ]] && echo "$mergescript not found, exiting" && exit 1

# check required directories
[[ ! -d $wmdir ]] && echo "$wmdir not found, exiting" && exit 1
[[ ! -d $motevodirtmpsplit ]] && echo "$motevodirtmpsplit not found, exiting" && exit 1

# Run mergescript
# motevodirtmpmerged="$motevodirtmpbase/merged"
# wmnames="/hpc/hub_oudenaarden/jyeung/data/databases/WMs/SwissRegulon/mm10_v2_WMs.list"

echo "Running merge script"
mkdir $motevodirtmpmerged
python $mergescript --wmnamesfile $wmnames $motevodirtmpsplit $motevodirtmpmerged
ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1

echo "Running merge script done" > $outlog
