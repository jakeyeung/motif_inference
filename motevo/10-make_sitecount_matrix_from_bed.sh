#!/bin/sh
# Jake Yeung
# 10-make_sitecont_matrix_from_bed.sh
#  
# 2023-06-09

# rs="/home/hub_oudenaarden/jyeung/projects/scchic-functions/scripts/motevo_scripts/lib/make_sitecount_matrix_from_bed.R"
# rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/make_sitecount_matrix_from_bed.R"
rs=$1
[[ ! -e $rs ]] && echo "$rs not found, exiting" && exit 1

# dont scale or center, but scale and center the expression matrix?
jscale=0
jcenter=0
byrow=0

# inf="/hpc/hub_oudenaarden/jyeung/data/scChiC/tfbs_output_cluster_BM_${jsuffix}/${jmark}/motevo_outputs/bed/merged_bed_closestbed_long/motevo_merged.closest.long.bed.reannotated.bed"
inf=$2 
# outf="${outdir}/hiddenDomains_motevo_merged.closest.long.scale_${jscale}.center_${jcenter}.byrow_${byrow}.${jmark}.txt"
outf=$3 

if [ $byrow -eq 0 ]
    then
		module load R/4.1.2; Rscript $rs $inf $outf --scale $jscale --center $jcenter
    else
		module load R/4.1.2; Rscript $rs $inf $outf --scale $jscale --center $jcenter --byrow
fi
