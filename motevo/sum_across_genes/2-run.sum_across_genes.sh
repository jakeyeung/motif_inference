#!/bin/sh
# Jake Yeung
# 2-run.sum_across_genes.sh
#  
# 2023-08-17

jmem='16G'
jtime='1:00:00'

rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/motevo/sum_across_genes/sum_across_genes.R"
indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS"
outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes"
logdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes/logs"

module load R/4.1.2
for f in `ls -d $indir/*.bed.gz`; do
		infile=${f}
		bname=$(basename $f)
		bname=${bname%%.*}
		motifname=`echo ${bname} | cut -d"_" -f1`
		outfile=${outdir}/${bname}_summed_across_genes.bed.gz
		BNAME=${logdir}/${bname}_sbatch
		DBASE=$(dirname "${BNAME}")
		[[ ! -d $DBASE ]] && echo "$DBASE not found, exiting" && exit 1
		cmd="Rscript $rs -infile $infile -outfile $outfile -motifname $motifname"
		sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --cpus-per-task=1 --job-name=Sum_${motifname} --wrap "$cmd"
done
