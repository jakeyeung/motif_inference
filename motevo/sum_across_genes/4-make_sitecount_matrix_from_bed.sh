#!/bin/sh
# Jake Yeung
# 10-make_sitecont_matrix_from_bed.sh
#  
# 2023-06-09

# rs=$1
# rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/make_sitecount_matrix_from_bed.R"
rs="/nfs/scistore12/hpcgrp/jyeung/projects/motif_inference/utils/make_sitecount_matrix_from_bed_sum_across_TSS.R"
[[ ! -e $rs ]] && echo "$rs not found, exiting" && exit 1

# dont scale or center, but scale and center the expression matrix?
jscale=0
jcenter=0
byrow=0

# inf=$2 
inf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes/merged/all_motifs_intersect_with_TSS.bed.gz"
# outf=$3 
outf="/nfs/scistore12/hpcgrp/jyeung/IST_data/Siegert_lab/motevo_outputs_fa_fix_full/motevo_outputs/bed/intersect_with_TSS/summed_across_genes/merged/all_motifs_intersect_with_TSS.mat"

if [ $byrow -eq 0 ]
    then
		module load R/4.1.2; Rscript $rs $inf $outf --scale $jscale --center $jcenter
    else
		module load R/4.1.2; Rscript $rs $inf $outf --scale $jscale --center $jcenter --byrow
fi
