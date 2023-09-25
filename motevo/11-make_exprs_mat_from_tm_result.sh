#!/bin/sh
# Jake Yeung
# 11-make_exprs_mat_from_tm_result.sh
#  
# 2023-06-21

jmem='96G'
jtime='6:00:00'


rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/make_merged_exprs_mat_for_MARA.args_tmresult.R"

indir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/cistopic_outputs"
outdir="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/exprs_mats"

for infile in `ls -d ${indir}/tm_result_topn_300000*.rds`; do
  base=$(basename $infile)
  base=${base%%.*}

  BNAME=${outdir}/logfiles.${base}.log
  DBASE=$(dirname "${BNAME}")
  [[ ! -d $DBASE ]] && echo "$DBASE not found, exiting" && exit 1

  outfile=${outdir}/exprs_mat.${base}.txt

  module load R/4.1.2
  echo "Rscript $rs $infile $outfile"
  cmd="Rscript $rs $infile $outfile"
  sbatch --time=${jtime} --mem-per-cpu=$jmem --output=${BNAME}_%j.log --ntasks=1 --nodes=1 --cpus-per-task=1 --job-name=${base} --wrap "$cmd"
done

