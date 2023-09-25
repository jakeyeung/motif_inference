#!/bin/sh
# Jake Yeung
# 9-intersect_beds_with_TSS.sh
#  
# 2023-08-16

jmem='32G'
jtime='1:00:00'


indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed"
bedfile1="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/exprs_mats/pbulks/RNAseq/bedfile_TSS.2023-08-16.sorted.bed"
outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS"
logdir="${outdir}/logs"
[[ ! -d $logdir ]] && mkdir $logdir

module load bedtools
for bedfile2 in `ls -d $indir/*.bed.gz`; do
	bedname=$(basename $bedfile2)
	bedname=${bedname%%.*}
	outname=${bedname}_intersect_with_TSS
	outbed=${outdir}/${outname}.bed
    [[ ! -e $bedfile2 ]] && echo "bedfile2 $bedfile2 not found, exiting for safety" && exit 1
    [[ -e $outbed ]] && echo "outbed $outbed found, exiting for safety" && exit 1

    BNAME=${logdir}/${bedname}.log
    DBASE=$(dirname "${BNAME}")
    [[ ! -d $DBASE ]] && echo "$DBASE not found, exiting" && exit 1

	cmd="bedtools intersect -a ${bedfile1} -b ${bedfile2} -wa -wb > $outbed; gzip $outbed"
	sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --cpus-per-task=1 --job-name=${outname} --wrap "$cmd"
done

# bedfile2="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.top_30000.sorted.bed"
# outbed="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/merged_bed_closestbed_long/intersect_out.bed"


