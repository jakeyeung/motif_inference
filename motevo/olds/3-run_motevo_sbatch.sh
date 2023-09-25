#!/bin/sh
# Jake Yeung
# 3-run_motevo.sh
#  
# 2023-05-30


fastasplitdirtmp=args[1]
scratchmain=args[2]

## BEGIN MOTEVO ##
# check split fastas exist
[[ ! -d $fastasplitdirtmp ]] && echo "$fastasplitdirtmp not found, exiting" && exit 1

paramdirname="param_files"

motevodirtmpbase="$scratchmain/motevo_outputs"
[[ ! -d $motevodirtmpbase ]] && mkdir $motevodirtmpbase
motevodirtmpsplit="$motevodirtmpbase/split"
[[ ! -d $motevodirtmpsplit ]] && mkdir $motevodirtmpsplit
[[ ! -d $motevodirtmpsplit ]] && echo "$motevodirtmpsplit not found, exiting" && exit 1

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
        python $sitecountscript -w $wmdir -f $infasta -c 0 -o $motevodirtmpsplitchunk -d $paramsdir
                ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: script failed" && exit 1
done



# echo "Created motevo inputs, but not yet run"
## END MOTEVO ##
