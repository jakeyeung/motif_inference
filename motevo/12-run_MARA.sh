#!/bin/sh
# Jake Yeung
# 12-run_MARA.sh
#  
# 2023-06-21

jmem='96G'
jtime='12:00:00'

bs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/run_mara_batch_promoters.sh"


indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/exprs_mats"

# N="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/sitecount_matrix/sitecount_matrix_cortex.txt"
# N="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/sitecount_matrix/sitecount_matrix_cortex.cutoff_0.35.txt"
N="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/sitecount_matrix/sitecount_matrix_cortex.top_30000.txt"

outmain="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/mara_outputs_top_30000"
[[ ! -d $outmain ]] && mkdir $outmain
for E in `ls -d ${indir}/exprs_mat*.txt`; do
	base=$(basename $E)
	base=${base%.*}

	outdir=${outmain}/${base}
	[[ ! -d $outdir ]] && mkdir $outdir

    BNAME=${outdir}/sbatch.${base}.log
    DBASE=$(dirname "${BNAME}")
    [[ ! -d $DBASE ]] && echo "$DBASE not found, exiting" && exit 1

	module load R/4.1.2
	cmd="bash $bs $E $outdir $N"
	sbatch --time=$jtime --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --cpus-per-task=1 --job-name=${base} --wrap "$cmd"
done
