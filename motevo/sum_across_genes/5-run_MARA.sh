#!/bin/sh
# Jake Yeung
# 12-run_MARA.sh
#  
# 2023-06-21

jmem='96G'
jtime='12:00:00'

bs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/run_mara_batch_promoters.sh"

indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/exprs_mats/pbulks/RNAseq"

N="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes/merged/all_motifs_intersect_with_TSS.txt"

outmain="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/mara_outputs_RNAseq"
[[ ! -d $outmain ]] && mkdir $outmain
# for E in `ls -d ${indir}/exprs_mat*30.txt`; do
for E in `ls -d ${indir}/exprs_mat*31.txt`; do
	echo $E
# for E in `ls -d ${indir}/exprs_mat*17.txt`; do
	base=$(basename $E)
	base=${base%.*}

	outdir=${outmain}/${base}.marcin
	[[ ! -d $outdir ]] && mkdir $outdir

    BNAME=${outdir}/sbatch.${base}.log
    DBASE=$(dirname "${BNAME}")
    [[ ! -d $DBASE ]] && echo "$DBASE not found, exiting" && exit 1

	module load R/4.1.2
	cmd="bash $bs $E $outdir $N"
	# sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --cpus-per-task=1 --job-name=${base} --wrap "$cmd"
	bash $bs $E $outdir $N
done
