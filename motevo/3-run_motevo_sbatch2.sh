#!/bin/sh
# Jake Yeung
# 3-run_motevo.sh
#  
# 2023-05-30


# sitecountscript="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/calculate_sitecount.sbatch.py"
sitecountscript=$1
motevobin=$2
wmdir=$3
fastasplitdirtmp=$4
outmain=$5
outlog="${outmain}/motevo_outputs.log"

## BEGIN MOTEVO ##
# check split fastas exist
[[ ! -e $sitecountscript ]] && echo "$sitecountscript sitecountscript not found, exiting" && exit 1
# [[ ! -d $scratchmain ]] && echo "$scratchmain scratchmain not found, exiting" && exit 1
[[ ! -d $fastasplitdirtmp ]] && echo "$fastasplitdirtmp fastasplitdirtmp not found, exiting" && exit 1


paramdirname="param_files"

# motevodirtmpbase="$scratchmain/motevo_outputs"
motevodirtmpbase="${outmain}"
[[ ! -d $motevodirtmpbase ]] && mkdir $motevodirtmpbase
motevodirtmpsplit="$motevodirtmpbase/split"
# motevodirtmpsplitlog="$motevodirtmpsplit/motevo_outputs.log"
motevodirtmpsplitlog="${outlog}"
[[ ! -d $motevodirtmpsplit ]] && mkdir $motevodirtmpsplit
[[ ! -d $motevodirtmpsplit ]] && echo "$motevodirtmpsplit not found, exiting" && exit 1

# check output file does not exist
# [[ ! -e $motevodirtmpsplitlog ]] && echo "$motevodirtmpsplitlog found, exiting" && exit 1

for infasta in `ls -d $fastasplitdirtmp/*.fa.*`
do
        bname=$(basename $infasta)
        chunk="${bname##*.}"
        motevodirtmpsplitchunk=$motevodirtmpsplit/$chunk
        paramsdir=$motevodirtmpsplitchunk/$paramdirname

        [[ -d $paramsdir ]] && echo "$paramsdir found, continuing" && continue

        [[ -d $motevodirtmpsplitchunk ]] && echo "chunk: $chunk found Skipping" && continue
        [[ ! -d $motevodirtmpsplitchunk ]] && mkdir $motevodirtmpsplitchunk
        [[ ! -d $paramsdir ]] && mkdir $paramsdir
        cd $paramsdir
        echo "python $sitecountscript -w $wmdir -f $infasta -c 0 -o $motevodirtmpsplitchunk -d $paramsdir -m ${motevobin}"
        python $sitecountscript -w $wmdir -f $infasta -c 0 -o $motevodirtmpsplitchunk -d $paramsdir -m ${motevobin}
        ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1
done

# WRAP UP
while [[ `squeue -u jyeung | grep MOTEVO | wc -l` > 0 ]]; do
        echo "sleep for 60 seconds"
        sleep 60
done

# write a flag output
echo "Finished MOTEVO" > $motevodirtmpsplitlog


# echo "Created motevo inputs, but not yet run"
## END MOTEVO ##
