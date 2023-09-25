#!/bin/sh
# Jake Yeung
# 1-get_fasta_run_motevo_general.sh
#  
# 2023-05-30

windowsf=args[1]
fastaref=args[2]
scratchmain=args[3]
wmdir=args[4]
sitecountscript=args[5]
motevobin=args[6]


# wmdir="/hpc/hub_oudenaarden/jyeung/data/databases/WMs/SwissRegulon/mm10_weight_matrices_v2_split"
wmdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/public_data/WMs/SwissRegulon"
[[ ! -d $wmdir ]] && echo "$wmdir not found, exiting" && exit 1

# sitecountscript="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/calculate_sitecount.sbatch.py"
sitecountscript="/nfs/scistore12/hpcgrp/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/calculate_sitecount.sbatch.py"
[[ ! -e $sitecountscript ]] && echo "$sitecountscript not found, exiting" && exit 1
motevobin="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/software/motevo_ver1.12/source/motevo"

[[ ! -e $windowsf ]] && echo "$windowsf not found, exiting" && exit 1
windowsbname=$(basename $windowsf)
windowsnoext=${windowsbname%.*}

[[ ! -e $fastaref ]] && echo "$fastaref not found, exiting" && exit 1

## BEGIN GET FASTA ##
fastadirtmp=$scratchmain/fasta
[[ ! -d $fastadirtmp ]] && mkdir $fastadirtmp
fname=${windowsbname%%.*}
fastaftmp=$fastadirtmp/$windowsnoext.fa
[[ ! -e $fastaftmp ]] && bedtools getfasta -fi $fastaref -bed $windowsf | awk 'NR % 2 { print } !(NR % 2) {print toupper($0)}' > $fastaftmp && ret=$?; [[ $ret -ne 0  ]] && echo "ERROR: getfasta failed" && exit 1

## END GET FASTA ##



## BEGIN SPLIT BEDS ##
[[ ! -e $fastaftmp ]] && echo "$fastaftmp not found, exiting" && exit 1

fastasplitdirtmp="$scratchmain/fastasplit"

if [ ! -d $fastasplitdirtmp ]
then
    [[ ! -d $fastasplitdirtmp ]] && mkdir $fastasplitdirtmp
    [[ ! -d $fastasplitdirtmp ]] && echo "$fastasplitdirtmp not found, exiting" && exit 1

    # use same number as in dhs_merged_tissue
    # n=60000 # works for H3K4me1 and H3K4me3
    n=10000  # must be EVEN number because fasta
    rem=$(( $n % 2 ))
    if [ $rem -eq 0 ]
    then
      echo "Even number check: $n is OK!"
    else
      echo "Even number check: $n is NOT OK... exiting!"
      exit 1
    fi

    # make into motevo format also
    fastabase=$(basename $fastaftmp)
    sed 's/>/>>mm10_/' $fastaftmp | split --lines=$n - $fastasplitdirtmp/$fastabase.
else
        echo "fastasplitdirtmp $fastasplitdirtmp exists, skipping the split"
fi


## END SPLIT BEDS ##




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
