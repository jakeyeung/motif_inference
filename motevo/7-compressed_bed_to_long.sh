#!/bin/sh
# Jake Yeung
# 7-compressed_bed_to_long.sh
#  
# 2023-06-08

# assign to each line
# decompress="/Home/jyeung/projects/tissue_specificity_hogenesch_shellscripts/merged_dhs/convert_compressed_bed_to_long.py"
# decompress="/home/hub_oudenaarden/jyeung/projects/scChiC/scripts/processing/motevo/lib/convert_compressed_bed_to_long.py"
# decompress="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/convert_compressed_bed_to_long.py"
# decompress="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/convert_compressed_bed_to_long.py"

decompress=$1
[[ ! -e $decompress ]] && echo "$decompress not found, exiting" && exit 1
motevodirtmpbedclosest=$2

[[ ! -d $motevodirtmpbedclosest ]] && echo "$motevodirtmpbedclosest not found, exiting" && exit 1

# motevodirtmpbedclosestlong=$motevodirtmpbedclosest/long_format
motevodirtmpbedclosestlong=$3
[[ ! -d $motevodirtmpbedclosestlong ]] && mkdir $motevodirtmpbedclosestlong

# # nohupdir="/scratch/el/monthly/jyeung/nohups/closestmulti_to_long_motifpeak"
# nohupdir="$scratchmain/nohups_closestmulti_to_long_motifpeak"
nohupdir=${motevodirtmpbedclosestlong}/nohups
outlog=${motevodirtmpbedclosestlong}/bed_to_long.out

[[ ! -e $decompress ]] && echo "$decompress not found, exiting" && exit 1
[[ ! -d $motevodirtmpbedclosest ]] && echo "$motevodirtmpbedclosest not found, exiting" && exit 1
[[ ! -d $motevodirtmpbedclosestlong ]] && mkdir $motevodirtmpbedclosestlong
[[ ! -d $nohupdir ]] && mkdir $nohupdir

jmem="1G"
jtime="1:00:00"
for b in `ls -d $motevodirtmpbedclosest/*.bed`; do
        base=$(basename $b)
        basenoext=${base%.*}.long.bed
        bout=$motevodirtmpbedclosestlong/$basenoext
        [[ -e $bout ]] && echo "$bout found, continuing" && continue
        errf=$nohupdir/$basenoext.err
        outf=$nohupdir/$basenoext.out
        # bsub -e $errf -o $outf -M 4000000 "python $decompress $b $bout --has_dist --gene_col_i 5"
        BNAME=$nohupdir/$base
        # echo "python $decompress $b $bout --has_dist --gene_col_i 5" | qsub -l h_rt=${jtime} -l h_vmem=${jmem} -o ${BNAME}.out -e ${BNAME}.err -N MOTEVO
        cmd="python $decompress $b $bout --has_dist --gene_col_i 5"
        sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --job-name=MOTEVO --wrap "$cmd"
done

# wait for jobs
while [[ `squeue -u jyeung | grep MOTEVO | wc -l` > 0 ]]; do
        echo "sleep for 60 seconds"
        sleep 60
done

echo "Finished compressed bed to long" > ${outlog}
