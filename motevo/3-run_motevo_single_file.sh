#!/bin/sh
# Jake Yeung
# 3-run_motevo.sh
#  
# 2023-05-30


# sitecountscript="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/calculate_sitecount.bash.py"
sitecountscript=$1
motevobin=$2
infasta=$3
# chunk=$4
outlog=$4

motevodirtmpbase=$(dirname $outlog)

bname=$(basename $infasta)
chunk="${bname##*.}"


## BEGIN MOTEVO ##
# check split fastas exist
[[ ! -e $sitecountscript ]] && echo "$sitecountscript sitecountscript not found, exiting" && exit 1
# [[ ! -d $scratchmain ]] && echo "$scratchmain scratchmain not found, exiting" && exit 1
# [[ ! -d $fastasplitdirtmp ]] && echo "$fastasplitdirtmp fastasplitdirtmp not found, exiting" && exit 1


paramdirname="param_files"

# motevodirtmpbase="$scratchmain/motevo_outputs"
[[ ! -d $motevodirtmpbase ]] && mkdir $motevodirtmpbase
motevodirtmpsplit="$motevodirtmpbase/split"
[[ ! -d $motevodirtmpsplit ]] && mkdir $motevodirtmpsplit

motevodirtmpsplitchunk=$motevodirtmpsplit/$chunk
paramsdir=$motevodirtmpsplitchunk/$paramdirname

python $sitecountscript -w $wmdir -f $infasta -c 0 -o $motevodirtmpsplitchunk -d $paramsdir -m ${motevobin}
ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1

# for infasta in `ls -d $fastasplitdirtmp/*.fa.*`
# do
#         bname=$(basename $infasta)
#         chunk="${bname##*.}"
#         motevodirtmpsplitchunk=$motevodirtmpsplit/$chunk
#         paramsdir=$motevodirtmpsplitchunk/$paramdirname
# 
#         [[ -d $paramsdir ]] && echo "$paramsdir found, continuing" && continue
# 
#         [[ -d $motevodirtmpsplitchunk ]] && echo "chunk: $chunk found Skipping" && continue
#         [[ ! -d $motevodirtmpsplitchunk ]] && mkdir $motevodirtmpsplitchunk
#         [[ ! -d $paramsdir ]] && mkdir $paramsdir
#         cd $paramsdir
#         python $sitecountscript -w $wmdir -f $infasta -c 0 -o $motevodirtmpsplitchunk -d $paramsdir -m ${motevobin}
#         ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1
# done
# 
# # WRAP UP
# while [[ `squeue -u jyeung | grep MOTEVO | wc -l` > 0 ]]; do
#         echo "sleep for 60 seconds"
#         sleep 60
# done

# write a flag output
echo "Finished MOTEVO" > ${outlog}


# echo "Created motevo inputs, but not yet run"
## END MOTEVO ##
